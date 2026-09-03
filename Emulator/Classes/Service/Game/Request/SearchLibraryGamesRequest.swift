//
//  SearchLibraryGamesRequest.swift
//  Delta
//
//  Created by Андрей Чернышев on 16.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import Alamofire

struct SearchLibraryGamesRequest: APIRequestBody {
    let search: String
    let page: Int
    
    var url: String {
        GlobalDefinitions.libraryDomain + "/api/search/\(search)?page=\(page)"
    }
    
    var method: HTTPMethod {
        .get
    }
}
