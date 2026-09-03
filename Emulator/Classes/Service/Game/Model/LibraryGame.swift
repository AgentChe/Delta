//
//  LibraryGame.swift
//  GBEmulator
//
//  Created by Андрей Чернышев on 07.06.2024.
//

import Foundation

struct LibraryGame: Codable, Hashable {
    let title: String
    let thumbnail: URL
    let rating: Rating
    let country: Country?
    let description: String?
    let link: URL
    let slug: String
    let platform: String?
    let created: Date?
    let paid: Bool
    let similarGames: [LibraryGame]?
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    init?(detailsResponse: Any) {
        guard 
            let json = detailsResponse as? [String: Any],
            let body = json["body"] as? [String: Any],
            let game = LibraryGame(json: body)
        else {
            return nil
        }
        
        self = game
    }
    
    init?(json: [String: Any]) {
        guard
            let title = json["title"] as? String,
            let thumbnail: URL = {
                guard let path = json["thumbnail"] as? String else { return nil }
                return URL(string: path)
            }(),
            let rating: Rating = {
                guard let ratingJSON = json["rating"] as? [String: Any] else { return nil }
                return Rating(json: ratingJSON)
            }(),
            let link: URL = {
                guard
                    let gameJSON = json["game"] as? [String: Any],
                    let path = gameJSON["src"] as? String
                else { return nil }
                
                return URL(string: path)
            }(),
            let slug = json["slug"] as? String
        else {
            return nil
        }
        
        self.title = title
        self.thumbnail = thumbnail
        self.rating = rating
        self.country = {
            guard let countryJSON = json["countries"] as? [String: Any] else { return nil }
            return Country(json: countryJSON)
        }()
        self.description = json["description"] as? String
        self.link = link
        self.slug = slug
        self.platform = json["platform"] as? String
        self.created = {
            guard let string = json["created_at"] as? String else { return nil }
            return Self.dateFormatter.date(from: string)
        }()
        self.paid = json["is_paid"] as? Bool ?? false
        self.similarGames = nil // TODO: получать после реализации на бэке
    }
}

// MARK: Additional (Rating)
extension LibraryGame {
    struct Rating: Codable, Hashable {
        let value: Float
        let count: Int
        
        init?(json: [String: Any]) {
            guard
                let valueString = json["value"] as? String,
                let value = Float(valueString),
                let count = json["count"] as? Int
            else {
                return nil
            }
            
            self.value = value
            self.count = count
        }
    }
}

// MARK: Additional (Country)
extension LibraryGame {
    struct Country: Codable, Hashable {
        let name: String
        let flag: URL
        
        init?(json: [String: Any]) {
            guard
                let country = json["country"] as? String,
                let flag: URL = {
                    guard let flagPath = json["flag"] as? String else { return nil }
                    return URL(string: flagPath)
                }()
            else {
                return nil
            }
            
            self.name = country
            self.flag = flag
        }
    }
}
