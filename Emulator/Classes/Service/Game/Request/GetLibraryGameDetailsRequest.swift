//
//  GetLibraryGameDetailsRequest.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import Alamofire

struct GetLibraryGameDetailsRequest: APIRequestBody {
    let gameSlug: String
    
    var url: String {
        GlobalDefinitions.libraryDomain + "/api/roms/\(gameSlug)"
    }
    
    var method: HTTPMethod {
        .get
    }
}
