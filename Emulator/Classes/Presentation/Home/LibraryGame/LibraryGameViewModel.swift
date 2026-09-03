//
//  LibraryGameViewModel.swift
//  Delta
//
//  Created by Андрей Чернышев on 18.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import RxSwift
import RxCocoa

final class LibraryGameViewModel {
    enum Route {
        case dismiss
        case importInstruction
        case libraryGame(LibraryGame)
        case play(Game)
        case paygate
    }
    
    enum Action {
        case download(LibraryGame)
        case cancelLoading(LibraryGame)
    }
    
    private let initialLibraryGame: Driver<LibraryGame>
    
    private lazy var gamesManager = GamesManager()
    
    private lazy var downloadObserver = LibraryGameDownloadOperationObserver()
    
    init(libraryGame: LibraryGame) {
        self.initialLibraryGame = BehaviorRelay(value: libraryGame).asDriver()
    }
}

// MARK: Public
extension LibraryGameViewModel {
    struct Input {
        let didBackTapped: Signal<Void>
        let didTapAction: Signal<LGTableActionElement>
        let didImportInstruction: Signal<Void>
        let didSelectGame: Signal<LibraryGame>
        let didTapBookmark: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[LGTableElement]>
        let route: Driver<Route>
        let action: Driver<Action>
        let favorite: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let libraryGame = makeGame()
        
        return Output(
            elements: makeElements(
                game: libraryGame,
                progressElement: makeProgressElement(libraryGame: libraryGame),
                actionElement: makeActionElement(libraryGame: libraryGame)
            ),
            route: makeRoute(
                game: libraryGame,
                didBackTapped: input.didBackTapped,
                didImportInstruction: input.didImportInstruction,
                didSelectGame: input.didSelectGame,
                libraryGame: libraryGame,
                didTapAction: input.didTapAction
            ),
            action: makeAction(
                libraryGame: libraryGame,
                didTapAction: input.didTapAction
            ),
            favorite: makeFavorite(
                game: libraryGame,
                didTapBookmark: input.didTapBookmark
            )
        )
    }
}

// MARK: Private
private extension LibraryGameViewModel {
    func makeElements(
        game: Driver<LibraryGame>,
        progressElement: Driver<LGTableProgressElement?>,
        actionElement: Driver<LGTableActionElement>
    ) -> Driver<[LGTableElement]> {
        Driver
            .combineLatest(game, progressElement, actionElement)
            .map { game, progressElement, actionElement -> [LGTableElement] in
                var result = [LGTableElement]()
                
                result.append(.image(game.thumbnail))
                
                if let progressElement {
                    result.append(.progress(progressElement))
                }
                
                if let category = game.platform {
                    result.append(.category(category))
                }
                
                result.append(.name(game.title))
                
                if let country = game.country {
                    result.append(.country(country))
                }
                
                if let description = game.description, !description.isEmpty {
                    result.append(contentsOf: [
                        .title("LibraryGame.Description".localized.uppercased()),
                        .description(description)
                    ])
                }
                
                result.append(.action(actionElement))
                
                if let similarGames = game.similarGames, !similarGames.isEmpty {
                    result.append(contentsOf: [
                        .title("LibraryGame.SimilarGames".localized.uppercased()),
                        .similarGames(similarGames)
                    ])
                }
                
                result.append(.importInstruction)
                
                return result
            }
    }
    
    func makeProgressElement(libraryGame: Driver<LibraryGame>) -> Driver<LGTableProgressElement?> {
        let initial = libraryGame
            .asObservable()
            .take(1)
            .asDriver(onErrorDriveWith: .never())
            .map { [weak self] libraryGame -> LGTableProgressElement? in
                guard let self else { return nil }
                
                if LibraryGameDownloader.shared.downloaded(libraryGame: libraryGame) {
                    return .downloaded
                } else if LibraryGameDownloader.shared.isDownloading(libraryGame: libraryGame) {
                    if let operation = LibraryGameDownloader.shared.operation(for: libraryGame) {
                        operation.add(observer: downloadObserver)
                        return .loading(downloadObserver)
                    }
                    return nil
                } else {
                    return nil
                }
            }
        
        let loading = LibraryGameDownloaderMediator.shared.didStartDownload
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame) { ($0, $1) }
            .filter { $0.slug == $1.slug }
            .map { [weak self] args -> LGTableProgressElement? in
                guard let self else { return nil }
                
                if let operation = LibraryGameDownloader.shared.operation(for: args.1) {
                    operation.add(observer: downloadObserver) 
                    return .loading(downloadObserver)
                }
                
                return nil
            }
        
        let downloaded = LibraryGameDownloaderMediator.shared.didDownloaded
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame) { ($0.0, $1) }
            .filter { $0.slug == $1.slug }
            .map { [weak self] args -> LGTableProgressElement? in
                guard let self else { return nil }
                
                if let operation = LibraryGameDownloader.shared.operation(for: args.1) {
                    operation.remove(observer: downloadObserver)
                }
                
                return .downloaded
            }
        
        let reset = Signal
            .merge(
                LibraryGameDownloaderMediator.shared.didError,
                LibraryGameDownloaderMediator.shared.didCancel
            )
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame) { ($0, $1) }
            .filter { $0.slug == $1.slug }
            .map { [weak self] args -> LGTableProgressElement? in
                guard let self else { return nil }
                
                if let operation = LibraryGameDownloader.shared.operation(for: args.1) {
                    operation.remove(observer: downloadObserver)
                }
                
                return nil
            }
        
        return Driver
            .merge(initial, loading, downloaded, reset)
    }
    
    func makeActionElement(libraryGame: Driver<LibraryGame>) -> Driver<LGTableActionElement> {
        let initial = libraryGame
            .asObservable()
            .take(1)
            .asDriver(onErrorDriveWith: .never())
            .map { libraryGame -> LGTableActionElement in
                if LibraryGameDownloader.shared.downloaded(libraryGame: libraryGame) {
                    return .play
                } else if LibraryGameDownloader.shared.isDownloading(libraryGame: libraryGame) {
                    return .cancelLoading
                } else {
                    return .download
                }
            }
        
        let resetToDownloadTrigger = Signal
            .merge(
                LibraryGameDownloaderMediator.shared.didError,
                LibraryGameDownloaderMediator.shared.didCancel
            )
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame) { ($0, $1) }
            .compactMap { triggerGame, currentGame -> LGTableActionElement? in
                (triggerGame.slug == currentGame.slug) ? .download : nil
            }
        
        let cancelLoadingTrigger = LibraryGameDownloaderMediator.shared.didStartDownload
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame) { ($0, $1) }
            .compactMap { triggerGame, currentGame -> LGTableActionElement? in
                (triggerGame.slug == currentGame.slug) ? .cancelLoading : nil
            }
        
        let playTrigger = LibraryGameDownloaderMediator.shared.didDownloaded
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame) { ($0.0, $1) }
            .compactMap { triggerGame, currentGame -> LGTableActionElement? in
                (triggerGame.slug == currentGame.slug) ? .play : nil
            }
        
        return Driver
            .merge(initial, resetToDownloadTrigger, cancelLoadingTrigger, playTrigger)
    }
    
    func makeRoute(
        game: Driver<LibraryGame>,
        didBackTapped: Signal<Void>,
        didImportInstruction: Signal<Void>,
        didSelectGame: Signal<LibraryGame>,
        libraryGame: Driver<LibraryGame>,
        didTapAction: Signal<LGTableActionElement>
    ) -> Driver<Route> {
        let dismiss = didBackTapped
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame)
            .map { [weak self] libraryGame -> Route in
                guard let self, let operation = LibraryGameDownloader.shared.operation(for: libraryGame) else { return .dismiss }
                
                operation.remove(observer: downloadObserver)
                
                return .dismiss
            }
            .asDriver(onErrorDriveWith: .never())
        
        let importInstruction = didImportInstruction
            .map { Route.importInstruction }
            .asDriver(onErrorDriveWith: .never())
        
        let selectGame = didSelectGame
            .map { Route.libraryGame($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let playOrPaygate = didTapAction
            .filter { $0 == .play }
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame)
            .compactMap { libraryGame -> Game? in
                guard let identifier = LibraryGameDownloader.shared.gameIdentifier(at: libraryGame) else { return nil }
                return DatabaseManager.shared.fetchGame(byIdentifier: identifier)?.first
            }
            .map { SessionManager().hasActiveSubscriptions() ? Route.play($0) : Route.paygate }
        
        return Driver
            .merge(dismiss, importInstruction, selectGame, playOrPaygate)
    }
    
    func makeGame() -> Driver<LibraryGame> {
        initialLibraryGame
            .flatMapLatest { [weak self] initialGame -> Driver<LibraryGame> in
                guard let self else { return .never() }
                
                return gamesManager
                    .fetchGameDetails(slug: initialGame.slug)
                    .compactMap { $0 }
                    .asDriver(onErrorDriveWith: .never())
                    .startWith(initialGame)
            }
    }
    
    func makeAction(
        libraryGame: Driver<LibraryGame>,
        didTapAction: Signal<LGTableActionElement>
    ) -> Driver<Action> {
        let download = didTapAction
            .filter { $0 == .download }
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame)
            .map { Action.download($0) }
        
        let cancelLoading = didTapAction
            .filter { $0 == .cancelLoading }
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(libraryGame)
            .map { Action.cancelLoading($0) }
        
        return Driver
            .merge(download, cancelLoading)
    }
    
    func makeFavorite(
        game: Driver<LibraryGame>,
        didTapBookmark: Signal<Void>
    ) -> Driver<Bool> {
        game
            .flatMapLatest { [weak self] game -> Driver<Bool> in
                guard let self else { return .never() }
                
                let initial = self.gamesManager
                    .fetchFavorites()
                    .asDriver(onErrorJustReturn: [])
                    .map { $0.contains(where: { $0.slug == game.slug }) }
                
                return initial
                    .flatMapLatest { [weak self] initial -> Driver<Bool> in
                        didTapBookmark
                            .scan(initial) { bookmark, void -> Bool in !bookmark }
                            .flatMapFirst { [weak self] bookmark -> Driver<Bool> in
                                guard let self else { return .never() }
                                
                                let single = bookmark ? self.gamesManager.add(favorite: game) : self.gamesManager.remove(favorite: game)
                                
                                return single
                                    .asDriver(onErrorDriveWith: .never())
                                    .map { bookmark }
                            }
                            .asDriver(onErrorDriveWith: .never())
                            .startWith(initial)
                    }
            }
    }
}
