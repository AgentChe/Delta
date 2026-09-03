//
//  LibraryGameDownloaderMediator.swift
//  Delta
//
//  Created by Андрей Чернышев on 03.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import RxSwift
import RxCocoa

final class LibraryGameDownloaderMediator {
    static let shared = LibraryGameDownloaderMediator()
    
    private lazy var didStartDownloadTrigger = PublishRelay<LibraryGame>()
    private lazy var didDownloadedTrigger = PublishRelay<(LibraryGame, Game)>()
    private lazy var didProgressTrigger = PublishRelay<(LibraryGame, Double)>()
    private lazy var didErrorTrigger = PublishRelay<LibraryGame>()
    private lazy var didCancelTrigger = PublishRelay<LibraryGame>()
    
    private init() {}
}

// MARK: Public
extension LibraryGameDownloaderMediator {
    func startDownload(libraryGame: LibraryGame) {
        didStartDownloadTrigger.accept(libraryGame)
    }
    
    func downloaded(libraryGame: LibraryGame, game: Game) {
        didDownloadedTrigger.accept((libraryGame, game))
    }
    
    func progress(libraryGame: LibraryGame, progress: Double) {
        didProgressTrigger.accept((libraryGame, progress))
    }
    
    func error(libraryGame: LibraryGame) {
        didErrorTrigger.accept(libraryGame)
    }
    
    func cancel(libraryGame: LibraryGame) {
        didCancelTrigger.accept(libraryGame)
    }
    
    var didStartDownload: Signal<LibraryGame> {
        didStartDownloadTrigger.asSignal()
    }
    
    var didDownloaded: Signal<(LibraryGame, Game)> {
        didDownloadedTrigger.asSignal()
    }
    
    var didProgress: Signal<(LibraryGame, Double)> {
        didProgressTrigger.asSignal()
    }
    
    var didError: Signal<LibraryGame> {
        didErrorTrigger.asSignal()
    }
    
    var didCancel: Signal<LibraryGame> {
        didCancelTrigger.asSignal()
    }
}
