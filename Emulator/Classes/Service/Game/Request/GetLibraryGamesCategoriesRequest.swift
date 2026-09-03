//
//  GetLibraryGamesCategoriesRequest.swift
//  Delta
//
//  Created by Андрей Чернышев on 16.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import Alamofire

struct GetLibraryGamesCategoriesRequest: APIRequestBody {
    var url: String {
        GlobalDefinitions.libraryDomain + "/api/platforms"
    }
    
    var method: HTTPMethod {
        .get
    }
}
