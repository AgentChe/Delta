//
//  GamesManager.swift
//  GBEmulator
//
//  Created by Андрей Чернышев on 07.06.2024.
//

import RxSwift

protocol GamesManagerProtocol {
    func fetchCategories() -> Single<LibraryCategories>
    func fetchGames(category: String, page: Int) -> Single<LibraryGamesPage?>
    func search(_ search: String, page: Int) -> Single<LibraryGamesPage?>
    func fetchGameDetails(slug: String) -> Single<LibraryGame?>
    func add(favorite: LibraryGame) -> Single<Void> // TODO: реализовать на бэке
    func remove(favorite: LibraryGame) -> Single<Void> // TODO: реализовать на бэке
    func fetchFavorites() -> Single<[LibraryGame]> // TODO: реализовать на бэке
}

final class GamesManager {
    enum Constants {
        static let favoritesGames = "games_manager_favorites_games_key"
    }
    
    private lazy var restApiTransport = RestAPITransport()
}

// MARK: GamesManagerProtocol
extension GamesManager: GamesManagerProtocol {
    func fetchCategories() -> Single<LibraryCategories> {
        let request = GetLibraryGamesCategoriesRequest()
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { LibraryCategories(response: $0) }
    }
    
    func fetchGames(category: String, page: Int) -> Single<LibraryGamesPage?> {
        let request = GetLibraryGamesRequest(category: category, page: page)
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { LibraryGamesPage(response: $0) }
    }
    
    func search(_ search: String, page: Int) -> Single<LibraryGamesPage?> {
        let request = SearchLibraryGamesRequest(search: search, page: page)
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { LibraryGamesPage(response: $0) }
    }
    
    func fetchGameDetails(slug: String) -> Single<LibraryGame?> {
        let request = GetLibraryGameDetailsRequest(gameSlug: slug)
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { LibraryGame(detailsResponse: $0) }
    }
    
    func add(favorite: LibraryGame) -> Single<Void> {
        fetchFavorites()
            .flatMap { cached -> Single<Void> in
                Single<Void>.create { single in
                    var favorites = cached
                    favorites.append(favorite)
                    
                    if let data = try? JSONEncoder().encode(favorites) {
                        UserDefaults.standard.setValue(data, forKey: Constants.favoritesGames)
                    }
                    
                    single(.success(Void()))
                    
                    GamesMediator.shared.add(favorite: favorite)
                    
                    return Disposables.create()
                }
            }
    }
    
    func remove(favorite: LibraryGame) -> Single<Void> {
        fetchFavorites()
            .flatMap { cached -> Single<Void> in
                Single<Void>.create { single in
                    var favorites = cached
                    favorites.removeAll(where: { $0.slug == favorite.slug })
                    
                    if let data = try? JSONEncoder().encode(favorites) {
                        UserDefaults.standard.setValue(data, forKey: Constants.favoritesGames)
                    }
                    
                    single(.success(Void()))
                    
                    GamesMediator.shared.remove(favorite: favorite)
                    
                    return Disposables.create()
                }
            }
    }
    
    func fetchFavorites() -> Single<[LibraryGame]> {
        Single<[LibraryGame]>.create { single in
            let games: [LibraryGame]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.favoritesGames) else { return [] }
                return try? JSONDecoder().decode([LibraryGame].self, from: data)
            }()
            
            single(.success(games ?? []))
            
            return Disposables.create()
        }
    }
}
