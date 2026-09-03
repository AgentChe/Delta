//
//  LibraryGameDownloadOperation.swift
//  Delta
//
//  Created by Андрей Чернышев on 03.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import Alamofire

private final class ObserversStorage {
    var observers = [LibraryGameDownloadOperationObserver]()
}

struct LibraryGameDownloadOperation {
    enum Result {
        case game(Game)
        case cancelled
        case error
    }
    
    let libraryGame: LibraryGame
    
    private let destinationUrl: URL
    
    private var request: DownloadRequest!
    
    private let observersStorage: ObserversStorage
    
    init(
        libraryGame: LibraryGame,
        observer: LibraryGameDownloadOperationObserver? = nil
    ) {
        self.libraryGame = libraryGame
        
        let destinationUrl = {
            let directory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)[0]
            let folder = directory.appendingPathComponent("LibraryGames", isDirectory: true)
            var fileUrl = folder.appendingPathComponent(libraryGame.link.lastPathComponent)
            fileUrl.appendPathExtension(libraryGame.link.pathExtension)
            return fileUrl
        }()
        self.destinationUrl = destinationUrl
        
        let observersStorage = ObserversStorage()
        
        if let observer {
            observersStorage.observers.append(observer)
        }
        
        self.observersStorage = observersStorage
        
        self.request = Alamofire
            .download(URLRequest(url: libraryGame.link)) { temporaryURL, response in
                (destinationUrl, [.removePreviousFile, .createIntermediateDirectories])
            }
            .downloadProgress { downloadProgress in
                observersStorage.observers.forEach { $0.progress?(downloadProgress.fractionCompleted) }
            }
            .responseData { responseData in
                if let nsError = responseData.error as? NSError, nsError.code == NSURLErrorCancelled {
                    return
                }
                
                if responseData.error != nil {
                    observersStorage.observers.forEach { $0.completed?(libraryGame, .error) }
                } else if let destinationURL = responseData.destinationURL {
                    DatabaseManager.shared.importGames(at: [destinationURL]) { games, error in
                        if !error.isEmpty {
                            observersStorage.observers.forEach { $0.completed?(libraryGame, .error) }
                        } else if let game = games.first {
                            observersStorage.observers.forEach { $0.completed?(libraryGame, .game(game)) }
                        } else {
                            observersStorage.observers.forEach { $0.completed?(libraryGame, .error) }
                        }
                    }
                } else {
                    observersStorage.observers.forEach { $0.completed?(libraryGame, .error) }
                }
            }
    }
}

// MARK: Public
extension LibraryGameDownloadOperation {
    func download() {
        request.resume()
    }
    
    func cancel() {
        request.cancel()
        
        observersStorage.observers.forEach { $0.completed?(libraryGame, .cancelled) }
    }
    
    func add(observer: LibraryGameDownloadOperationObserver) {
        observersStorage.observers.append(observer)
    }
    
    func remove(observer: LibraryGameDownloadOperationObserver) {
        observersStorage.observers.removeAll(where: { $0.identifier == observer.identifier })
    }
}
