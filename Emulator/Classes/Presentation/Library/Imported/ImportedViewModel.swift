//
//  ImportedViewModel.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import RxSwift
import RxCocoa
import Roxas

final class ImportedViewModel {
    enum Route {
        case favorites
        case importInstruction
        case importGames
        case categoryGames(GameCollection)
        case play(Game)
        case paygate
    }
    
    enum Action {
        case titleHidden(Bool)
        case showMenu(Game)
        case saveImportedGamesUrls(Set<URL>)
        case requestReplaceGames([Game], Set<URL>)
    }
}

// MARK: Public
extension ImportedViewModel {
    struct Input {
        let didTapFavorites: Signal<Void>
        let didTitleHidden: Signal<Bool>
        let didImport: Signal<Void>
        let didOpenInstruction: Signal<Void>
        let didCloseInstruction: Signal<Void>
        let didSelectGame: Signal<Game>
        let didTapMenu: Signal<Game>
        let didSelectCategory: Signal<GameCollection>
        let didImportedGamesUrls: Signal<Set<URL>>
        let didUpdateGames: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let action: Driver<Action>
        let elements: Driver<[ImportedTableElement]>
    }
    
    func configure(input: Input) -> Output {
        let instructionState = makeInstructionState(
            didOpenInstruction: input.didOpenInstruction,
            didCloseInstruction: input.didCloseInstruction
        )
        let gameCollections = makeGamesCollections(didUpdateGames: input.didUpdateGames)
        
        return Output(
            route: makeRoute(
                didTapFavorites: input.didTapFavorites,
                didOpenInstruction: input.didOpenInstruction,
                didImport: input.didImport,
                didSelectCategory: input.didSelectCategory,
                didSelectGame: input.didSelectGame
            ),
            action: makeAction(
                didTitleHidden: input.didTitleHidden,
                didTapMenu: input.didTapMenu,
                didImportedGamesUrls: input.didImportedGamesUrls
            ),
            elements: makeElements(
                instructionState: instructionState,
                gameCollections: gameCollections,
                downloadedGamesIdentifiers: makeDownloadedGamesIdentifiers()
            )
        )
    }
}

// MARK: Private
private extension ImportedViewModel {
    enum InstructionState: Codable {
        case closed
        case style(ImportInstructionButton.Style)
    }
    
    enum Constants {
        static let instructionStateKey = "instruction_state_key"
    }
    
    func makeRoute(
        didTapFavorites: Signal<Void>,
        didOpenInstruction: Signal<Void>,
        didImport: Signal<Void>,
        didSelectCategory: Signal<GameCollection>,
        didSelectGame: Signal<Game>
    ) -> Driver<Route> {
        let favorites = didTapFavorites
            .map { Route.favorites }
            .asDriver(onErrorDriveWith: .never())
        
        let importInstruction = didOpenInstruction
            .map { Route.importInstruction }
            .asDriver(onErrorDriveWith: .never())
        
        let importGames = didImport
            .map { Route.importGames }
            .asDriver(onErrorDriveWith: .never())
        
        let categoryGames = didSelectCategory
            .map { Route.categoryGames($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let play = didSelectGame
            .map { game -> Route in
                SessionManager().hasActiveSubscriptions() ? Route.play(game) : Route.paygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(favorites, importInstruction, importGames, categoryGames, play)
    }
    
    func makeAction(
        didTitleHidden: Signal<Bool>,
        didTapMenu: Signal<Game>,
        didImportedGamesUrls: Signal<Set<URL>>
    ) -> Driver<Action> {
        let titleHidden = didTitleHidden
            .startWith(false)
            .map { Action.titleHidden(!$0) }
            .asDriver(onErrorDriveWith: .never())
        
        let showMenu = didTapMenu
            .map { Action.showMenu($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let importOrReplace = didImportedGamesUrls
            .flatMapLatest { urls -> Driver<Action> in
                Single
                    .create { single in
                        let games = DatabaseManager.shared.fetchAllGames() ?? []
                        
                        var replacingGames = [Game]()
                        
                        urls.forEach { url in
                            guard let identifier = try? RSTHasher.sha1HashOfFile(at: url) else { return }
                            
                            guard let game = games.first(where: { $0.identifier == identifier }) else { return }
                            
                            replacingGames.append(game)
                        }
                        
                        if replacingGames.isEmpty {
                            single(.success(.saveImportedGamesUrls(urls)))
                        } else {
                            single(.success(.requestReplaceGames(replacingGames, urls)))
                        }
                        
                        return Disposables.create()
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(titleHidden, showMenu, importOrReplace)
    }
    
    func makeElements(
        instructionState: Driver<InstructionState>,
        gameCollections: Driver<[GameCollection]>,
        downloadedGamesIdentifiers: Driver<[String]>
    ) -> Driver<[ImportedTableElement]> {
        Driver
            .combineLatest(
                instructionState, 
                gameCollections,
                downloadedGamesIdentifiers
            )
            .map { instructionState, gameCollections, downloadedGamesIdentifiers -> [ImportedTableElement] in
                var result: [ImportedTableElement] = [.title]
                
                switch instructionState {
                case .closed:
                    result.append(.importWithoutInstruction)
                case .style(let style):
                    result.append(.importWithInstruction(style))
                }
                
                if gameCollections.isEmpty {
                    result.append(.empty)
                } else {
                    gameCollections.forEach { gameCollection in
                        result.append(.section(gameCollection))
                        
                        let gamesElements = Array(gameCollection.games).map { game -> ImportedTableGameElement in
                            ImportedTableGameElement(
                                game: game,
                                downloaded: downloadedGamesIdentifiers.contains(game.identifier)
                            )
                        }
                        result.append(.games(gamesElements))
                    }
                }
                
                return result
            }
    }
    
    func makeInstructionState(
        didOpenInstruction: Signal<Void>,
        didCloseInstruction: Signal<Void>
    ) -> Driver<InstructionState> {
        let initial = Single<InstructionState>
            .create { single in
                let state: InstructionState = {
                    guard 
                        let data = UserDefaults.standard.data(forKey: Constants.instructionStateKey),
                        let style = try? JSONDecoder().decode(InstructionState.self, from: data)
                    else { return .style(.info) }
                    
                    return style
                }()
                
                single(.success(state))
                
                return Disposables.create()
            }
            .asDriver(onErrorDriveWith: .never())
        
        let action = Signal
            .merge(
                didOpenInstruction.map { InstructionState.style(.close) },
                didCloseInstruction.map { InstructionState.closed }
            )
            .flatMapFirst { state -> Signal<InstructionState> in
                Single<InstructionState>.create { single in
                    if let data = try? JSONEncoder().encode(state) {
                        UserDefaults.standard.set(data, forKey: Constants.instructionStateKey)
                    }
                    
                    single(.success(state))
                    
                    return Disposables.create()
                }
                .asSignal(onErrorSignalWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, action)
    }
    
    func makeGamesCollections(didUpdateGames: Signal<Void>) -> Driver<[GameCollection]> {
        Signal
            .merge(
                didUpdateGames,
                CategoryGamesMediator.shared.didUpdateGames,
                LibraryGameDownloaderMediator.shared.didDownloaded.map { _ in Void() },
                DatabaseMediator.shared.didClearAll
            )
            .startWith(())
            .map { DatabaseManager.shared.fetchCollections() ?? [] }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeDownloadedGamesIdentifiers() -> Driver<[String]> {
        Signal
            .merge(
                DatabaseMediator.shared.didClearAll,
                LibraryGameDownloaderMediator.shared.didDownloaded.map { _ in Void() }
            )
            .startWith(Void())
            .map { LibraryGameDownloader.shared.downloadedGameIdentifiers() }
            .asDriver(onErrorJustReturn: [])
    }
}
