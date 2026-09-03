//
//  LibraryGameDownloadOperationObserver.swift
//  Delta
//
//  Created by Андрей Чернышев on 04.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

final class LibraryGameDownloadOperationObserver {
    let identifier: String
    
    var progress: ((Double) -> Void)?
    var completed: ((LibraryGame, LibraryGameDownloadOperation.Result) -> Void)?
    
    init() {
        self.identifier = UUID().uuidString
    }
}
