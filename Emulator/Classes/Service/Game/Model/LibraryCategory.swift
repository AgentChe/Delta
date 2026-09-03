//
//  LibraryCategory.swift
//  Delta
//
//  Created by Андрей Чернышев on 16.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

typealias LibraryCategories = [LibraryCategory]

extension LibraryCategories {
    init(response: Any) {
        self = {
            guard
                let json = response as? [String: Any],
                let body = json["body"] as? [String]
            else { return [] }
            
            return body.map { LibraryCategory(name: $0) }
        }()
    }
}

struct LibraryCategory {
    let name: String
}
