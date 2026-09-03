//
//  LGTableElement.swift
//  Delta
//
//  Created by Андрей Чернышев on 18.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import Foundation

enum LGTableElement {
    case image(URL)
    case category(String)
    case name(String)
    case country(LibraryGame.Country)
    case title(String)
    case description(String)
    case action(LGTableActionElement)
    case similarGames([LibraryGame])
    case importInstruction
    case progress(LGTableProgressElement)
}

enum LGTableActionElement {
    case download
    case cancelLoading
    case play
}

enum LGTableProgressElement {
    case loading(LibraryGameDownloadOperationObserver)
    case downloaded
}
