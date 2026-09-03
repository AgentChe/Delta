//
//  LibraryGameDownloader.swift
//  Delta
//
//  Created by Андрей Чернышев on 03.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import Alamofire

protocol LibraryGameDownloaderProtocol {
    func download(libraryGame: LibraryGame)
    func cancel(libraryGame: LibraryGame)
    func isDownloading(libraryGame: LibraryGame) -> Bool
    func downloaded(libraryGame: LibraryGame) -> Bool
    func downloadedGameIdentifiers() -> [String]
    func gameIdentifier(at libraryGame: LibraryGame) -> String?
    func operation(for libraryGame: LibraryGame) -> LibraryGameDownloadOperation?
    func remove(gameIdentifier: String)
    func removeAll()
}

final class LibraryGameDownloader {
    enum Constants {
        static let downloadedKey = "library_game_downloader_downloaded_key"
    }
    
    static let shared = LibraryGameDownloader()
    
    private lazy var operations = [LibraryGame: LibraryGameDownloadOperation]()
    
    private init() {}
}

// MARK: LibraryGameDownloaderProtocol
extension LibraryGameDownloader: LibraryGameDownloaderProtocol {
    func download(libraryGame: LibraryGame) {
        let observer = LibraryGameDownloadOperationObserver()
        observer.progress = { progress in
            LibraryGameDownloaderMediator.shared.progress(libraryGame: libraryGame, progress: progress)
        }
        observer.completed = { [weak self] libraryGame, operationResult in
            guard let self else { return }
            
            self.operations.removeValue(forKey: libraryGame)
            
            switch operationResult {
            case .game(let game):
                let cacheObject = CacheObject(libraryGame: libraryGame, gameIdentifier: game.identifier)
                cache(object: cacheObject)
                
                LibraryGameDownloaderMediator.shared.downloaded(libraryGame: libraryGame, game: game)
            case .cancelled:
                LibraryGameDownloaderMediator.shared.cancel(libraryGame: libraryGame)
            case .error:
                LibraryGameDownloaderMediator.shared.error(libraryGame: libraryGame)
            }
        }
        
        let operation = LibraryGameDownloadOperation(libraryGame: libraryGame, observer: observer)
        operations[libraryGame] = operation
        
        operation.download()
        
        LibraryGameDownloaderMediator.shared.startDownload(libraryGame: libraryGame)
    }
    
    func cancel(libraryGame: LibraryGame) {
        guard let operation = operations[libraryGame] else { return }
        operation.cancel()
    }
    
    func isDownloading(libraryGame: LibraryGame) -> Bool {
        operations.contains(where: { $0.key.slug == libraryGame.slug })
    }
    
    func downloaded(libraryGame: LibraryGame) -> Bool {
        cached().contains(where: { $0.libraryGame.slug == libraryGame.slug })
    }
    
    func downloadedGameIdentifiers() -> [String] {
        cached().map { $0.gameIdentifier }
    }
    
    func gameIdentifier(at libraryGame: LibraryGame) -> String? {
        cached().first(where: { $0.libraryGame.slug == libraryGame.slug })?.gameIdentifier
    }
    
    func operation(for libraryGame: LibraryGame) -> LibraryGameDownloadOperation? {
        operations[libraryGame]
    }
    
    func remove(gameIdentifier: String) {
        var cached = cached()
        cached.removeAll(where: { $0.gameIdentifier == gameIdentifier })
        
        if let data = try? JSONEncoder().encode(cached) {
            UserDefaults.standard.setValue(data, forKey: Constants.downloadedKey)
        }
    }
    
    func removeAll() {
        UserDefaults.standard.removeObject(forKey: Constants.downloadedKey)
    }
}

// MARK: Private
private extension LibraryGameDownloader {
    struct CacheObject: Codable {
        let libraryGame: LibraryGame
        let gameIdentifier: String
    }
    
    func cached() -> [CacheObject] {
        guard let data = UserDefaults.standard.data(forKey: Constants.downloadedKey) else { return [] }
        
        let array = try? JSONDecoder().decode([CacheObject].self, from: data)
        return array ?? []
    }
    
    func cache(object: CacheObject) {
        var cached = cached()
        cached.append(object)
        
        if let data = try? JSONEncoder().encode(cached) {
            UserDefaults.standard.setValue(data, forKey: Constants.downloadedKey)
        }
    }
}
