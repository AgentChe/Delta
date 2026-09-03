//
//  LibraryGamesPage.swift
//  Delta
//
//  Created by Андрей Чернышев on 16.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

struct LibraryGamesPage {
    let games: [LibraryGame]
    let page: Page
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let games: [LibraryGame] = {
                guard let items = body["items"] as? [[String: Any]] else { return [] }
                return items.compactMap { LibraryGame(json: $0) }
            }(),
            let page: Page = {
                guard let navigation = body["navigation"] as? [String: Any] else { return nil }
                return Page(json: navigation)
            }()
        else {
            return nil
        }
        
        self.games = games
        self.page = page
    }
}
