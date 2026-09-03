//
//  ImportedTableElement.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

enum ImportedTableElement {
    case title
    case importWithInstruction(ImportInstructionButton.Style)
    case importWithoutInstruction
    case section(GameCollection)
    case games([ImportedTableGameElement])
    case empty
}

struct ImportedTableGameElement {
    let game: Game
    let downloaded: Bool
}
