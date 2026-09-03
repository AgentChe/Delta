//
//  Page.swift
//  Delta
//
//  Created by Андрей Чернышев on 16.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

struct Page {
    let current: Int
    let nextPage: Int
    let previousPage: Int
    let total: Int
    
    init?(json: [String: Any]) {
        guard
            let current = json["current"] as? Int,
            let nextPage = json["next_page"] as? Int,
            let previousPage = json["prev_page"] as? Int,
            let total = json["total"] as? Int
        else {
            return nil
        }
        
        self.current = current
        self.nextPage = nextPage
        self.previousPage = previousPage
        self.total = total
    }
}
