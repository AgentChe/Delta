//
//  CategoryGamesViewModel.swift
//  Delta
//
//  Created by Андрей Чернышев on 23.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import RxSwift
import RxCocoa

final class CategoryGamesViewModel {
    enum Action {
        case back
        case play(Game)
        case elements([Game])
        case showMenu(Game)
    }
    
    private let category: Driver<String>
    
    init(category: GameCollection) {
        self.category = BehaviorRelay(value: category.identifier).asDriver()
    }
}

// MARK: Public
extension CategoryGamesViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didSelectGame: Signal<Game>
        let didTapMenu: Signal<Game>
        let didUpdateGames: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didSelectGame: input.didSelectGame,
                didUpdateGames: input.didUpdateGames,
                didTapMenu: input.didTapMenu
            )
        )
    }
}

// MARK: Private
private extension CategoryGamesViewModel {
    func makeAction(
        didTapClose: Signal<Void>,
        didSelectGame: Signal<Game>,
        didUpdateGames: Signal<Void>,
        didTapMenu: Signal<Game>
    ) -> Driver<Action> {
        let back = didTapClose
            .map { Action.back }
            .asDriver(onErrorDriveWith: .never())
        
        let play = didSelectGame
            .map { Action.play($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let showMenu = didTapMenu
            .map { Action.showMenu($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let elementsOrBack = category
            .flatMapLatest { category -> Driver<[Game]> in
                didUpdateGames
                    .startWith(())
                    .map { DatabaseManager.shared.fetchCollection(identifier: category)?.first?.games ?? Set<Game>() }
                    .map { Array($0) }
                    .asDriver(onErrorDriveWith: .never())
            }
            .map { games -> Action in
                games.isEmpty ? .back : .elements(games)
            }
        
        return Driver
            .merge(back, play, showMenu, elementsOrBack)
    }
}
