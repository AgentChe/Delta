//
//  HomeViewModel.swift
//  Delta
//
//  Created by Андрей Чернышев on 16.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    enum FetchBy {
        case category(String)
        case search(String)
    }
    
    struct GamePack {
        let games: [LibraryGame]
        let fetchBy: FetchBy
    }
    
    enum Route {
        case menu
        case libraryGame(LibraryGame)
        case paygate
    }
    
    enum Action {
        case reset
        case gamesPack(GamePack)
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var gamesManager = GamesManager()
}

// MARK: Public
extension HomeViewModel {
    struct Input {
        let focusOnSearch: Signal<Void>
        let cancelSearch: Signal<Void>
        let search: Signal<String>
        let menuTapped: Signal<Void>
        let selectCategory: Signal<LibraryCategory>
        let gamesDidScrollToBottom: Signal<Void>
        let selectGame: Signal<LibraryGame>
    }
    
    struct Output {
        let searchTransformMode: Driver<HomeSearchField.Mode>
        let categories: Driver<[LibraryCategory]>
        let route: Driver<Route>
        let action: Driver<Action>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            searchTransformMode: makeSearchTransformMode(
                focusOnSearch: input.focusOnSearch,
                cancelSearch: input.cancelSearch
            ),
            categories: makeCategories(),
            route: makeRoute(
                menuTapped: input.menuTapped,
                selectGame: input.selectGame
            ),
            action: makeAction(
                selectCategory: input.selectCategory,
                gamesDidScrollToBottom: input.gamesDidScrollToBottom,
                focusOnSearch: input.focusOnSearch,
                cancelSearch: input.cancelSearch,
                search: input.search
            ),
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver()
        )
    }
}

// MARK: Private
private extension HomeViewModel {
    func makeSearchTransformMode(
        focusOnSearch: Signal<Void>,
        cancelSearch: Signal<Void>
    ) -> Driver<HomeSearchField.Mode> {
        Signal<HomeSearchField.Mode>
            .merge(
                focusOnSearch.map { .cancelable },
                cancelSearch.map { .normal }
            )
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeCategories() -> Driver<[LibraryCategory]> {
        gamesManager
            .fetchCategories()
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRoute(
        menuTapped: Signal<Void>,
        selectGame: Signal<LibraryGame>
    ) -> Driver<Route> {
        let menu = menuTapped
            .map { Route.menu }
            .asDriver(onErrorDriveWith: .never())
        
        let libraryGame = selectGame
            .map { Route.libraryGame($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(menu, libraryGame)
    }
    
    func makeAction(
        selectCategory: Signal<LibraryCategory>,
        gamesDidScrollToBottom: Signal<Void>,
        focusOnSearch: Signal<Void>,
        cancelSearch: Signal<Void>,
        search: Signal<String>
    ) -> Driver<Action> {
        let reset = Signal
            .merge(
                selectCategory.map { _ in Void() },
                focusOnSearch,
                cancelSearch
            )
            .map { Action.reset }
            .asDriver(onErrorDriveWith: .never())
        
        let games = Signal
            .merge(
                selectCategory.map { FetchBy.category($0.name) },
                cancelSearch.withLatestFrom(selectCategory).map { FetchBy.category($0.name) },
                search.map { FetchBy.search($0) }
            )
            .flatMapLatest { [weak self] fetchBy -> Driver<Action> in
                guard let self else { return .never() }
                
                var lastPage: LibraryGamesPage?
                
                func fetch(page: Int) -> Driver<LibraryGamesPage> {
                    let single: Single<LibraryGamesPage?> = {
                        switch fetchBy {
                        case .category(let category):
                            self.gamesManager.fetchGames(category: category, page: page)
                        case .search(let string):
                            self.gamesManager.search(string, page: page)
                        }
                    }()
                    
                    return single
                        .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                        .compactMap { $0 }
                        .asDriver(onErrorDriveWith: .never())
                        .do(onNext: { page in
                            lastPage = page
                        })
                }
                        
                let firstPage = fetch(page: 1)
                
                return firstPage
                    .flatMapLatest { firstPage -> Driver<LibraryGamesPage> in
                        gamesDidScrollToBottom
                            .compactMap { lastPage  }
                            .filter { ($0.page.nextPage <= $0.page.total) && ($0.page.current != $0.page.total) }
                            .flatMapFirst { lastPage -> Driver<LibraryGamesPage> in
                                fetch(page: lastPage.page.nextPage)
                            }
                            .startWith(firstPage)
                    }
                    .map { libraryPage -> Action in
                        let gamePack = GamePack(
                            games: libraryPage.games,
                            fetchBy: fetchBy
                        )
                        return Action.gamesPack(gamePack)
                    }
            }
        
        return Driver
            .merge(reset, games)
    }
}
