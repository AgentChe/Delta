//
//  DatabaseMediator.swift
//  Delta
//
//  Created by Андрей Чернышев on 05.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import RxSwift
import RxCocoa

final class DatabaseMediator {
    static let shared = DatabaseMediator()
    
    private init() {}
    
    private lazy var didClearAllTrigger = PublishRelay<Void>()
}

// MARK: Public
extension DatabaseMediator {
    func clearAll() {
        didClearAllTrigger.accept(Void())
    }
    
    var didClearAll: Signal<Void> {
        didClearAllTrigger.asSignal()
    }
}
