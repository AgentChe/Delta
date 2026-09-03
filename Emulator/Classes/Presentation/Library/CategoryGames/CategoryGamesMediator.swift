//
//  CategoryGamesMediator.swift
//  Delta
//
//  Created by Андрей Чернышев on 23.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import RxSwift
import RxCocoa

final class CategoryGamesMediator {
    static let shared = CategoryGamesMediator()
    
    private init() {}
    
    private lazy var didUpdateGamesTrigger = PublishRelay<Void>()
}

// MARK: Public
extension CategoryGamesMediator {
    func updateGames() {
        didUpdateGamesTrigger.accept(Void())
    }
    
    var didUpdateGames: Signal<Void> {
        didUpdateGamesTrigger.asSignal()
    }
}
