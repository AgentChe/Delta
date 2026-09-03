//
//  GamesMediator.swift
//  Delta
//
//  Created by Андрей Чернышев on 24.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import RxSwift
import RxCocoa

final class GamesMediator {
    static let shared = GamesMediator()
    
    private lazy var didAddFavoriteTrigger = PublishRelay<LibraryGame>()
    private lazy var didRemoveFavoriteTrigger = PublishRelay<LibraryGame>()
    
    private init() {}
}

// MARK: Public
extension GamesMediator {
    func add(favorite: LibraryGame) {
        didAddFavoriteTrigger.accept(favorite)
    }
    
    func remove(favorite: LibraryGame) {
        didRemoveFavoriteTrigger.accept(favorite)
    }
    
    var didAddFavorite: Signal<LibraryGame> {
        didAddFavoriteTrigger.asSignal()
    }
    
    var didRemoveFavorite: Signal<LibraryGame> {
        didRemoveFavoriteTrigger.asSignal()
    }
}
