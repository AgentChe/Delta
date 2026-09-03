//
//  FavoritesViewModel.swift
//  Delta
//
//  Created by Андрей Чернышев on 24.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import RxSwift
import RxCocoa

final class FavoritesViewModel {
    enum Route {
        case back
        case play(LibraryGame)
    }
    
    private lazy var gamesManager = GamesManager()
}

// MARK: Public
extension FavoritesViewModel {
    struct Input {
        let didSelect: Signal<LibraryGame>
        let didTapBack: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[LibraryGame]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(),
            route: makeRoute(
                didTapBack: input.didTapBack,
                didSelect: input.didSelect
            )
        )
    }
}

// MARK: Private
private extension FavoritesViewModel {
    func makeElements() -> Driver<[LibraryGame]> {
        let initial = gamesManager
            .fetchFavorites()
            .asDriver(onErrorJustReturn: [])
        
        return initial
            .flatMapLatest { initial -> Driver<[LibraryGame]> in
                GamesMediator.shared.didRemoveFavorite
                    .scan(initial) { result, remove -> [LibraryGame] in
                        var games = result
                        games.removeAll(where: { $0.slug == remove.slug })
                        return games
                    }
                    .startWith(initial)
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeRoute(
        didTapBack: Signal<Void>,
        didSelect: Signal<LibraryGame>
    ) -> Driver<Route> {
        let back = didTapBack
            .map { Route.back }
            .asDriver(onErrorDriveWith: .never())
        
        let play = didSelect
            .map { Route.play($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(back, play)
    }
}
