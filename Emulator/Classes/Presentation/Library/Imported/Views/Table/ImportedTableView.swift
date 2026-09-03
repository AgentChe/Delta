//
//  ImportedTableView.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ImportedTableView: UITableView {
    lazy var elements = [ImportedTableElement]()
    
    private lazy var didTitleHiddenTrigger = PublishRelay<Bool>()
    private lazy var didImportTrigger = PublishRelay<Void>()
    private lazy var didOpenInstructionTrigger = PublishRelay<Void>()
    private lazy var didCloseInstructionTrigger = PublishRelay<Void>()
    private lazy var didSelectGameTrigger = PublishRelay<Game>()
    private lazy var didTapMenuTrigger = PublishRelay<Game>()
    private lazy var didSelectCategoryTrigger = PublishRelay<GameCollection>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ImportedTableView {
    func setup(elements: [ImportedTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTitleHidden: Signal<Bool> {
        didTitleHiddenTrigger.asSignal()
    }
    
    var didImport: Signal<Void> {
        didImportTrigger.asSignal()
    }
    
    var didOpenInstruction: Signal<Void> {
        didOpenInstructionTrigger.asSignal()
    }
    
    var didCloseInstruction: Signal<Void> {
        didCloseInstructionTrigger.asSignal()
    }
    
    var didSelectGame: Signal<Game> {
        didSelectGameTrigger.asSignal()
    }
    
    var didTapMenu: Signal<Game> {
        didTapMenuTrigger.asSignal()
    }
    
    var didSelectCategory: Signal<GameCollection> {
        didSelectCategoryTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ImportedTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .title:
            return dequeueReusableCell(withIdentifier: String(describing: ITTitleCell.self), for: indexPath)
        case .importWithInstruction(let style):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITImportWithInstructionCell.self)) as! ITImportWithInstructionCell
            cell.setup(style: style)
            cell.didImport = { [weak self] in
                self?.didImportTrigger.accept(Void())
            }
            cell.didOpenInstruction = { [weak self] in
                self?.didOpenInstructionTrigger.accept(Void())
            }
            cell.didCloseInstruction = { [weak self] in
                self?.didCloseInstructionTrigger.accept(Void())
            }
            return cell
        case .importWithoutInstruction:
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITImportWithoutInstructionCell.self)) as! ITImportWithoutInstructionCell
            cell.didImport = { [weak self] in
                self?.didImportTrigger.accept(Void())
            }
            return cell
        case .section(let section):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITSectionCell.self)) as! ITSectionCell
            cell.setup(gameCollection: section)
            return cell
        case .games(let games):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITGamesCell.self)) as! ITGamesCell
            cell.collectionView.setup(elements: games)
            cell.collectionView.didSelect = { [weak self] game in
                self?.didSelectGameTrigger.accept(game)
            }
            cell.collectionView.didTapMenu = { [weak self] game in
                self?.didTapMenuTrigger.accept(game)
            }
            return cell
        case .empty:
            return dequeueReusableCell(withIdentifier: String(describing: ITEmptyCell.self), for: indexPath)
        }
    }
}

// MARK: UITableViewDelegate
extension ImportedTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .games(let elements):
            return (elements.contains(where: { !$0.downloaded }) ? 248.scale : 219.scale) + 16.scale
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let element = elements[safe: indexPath.row], element.isTitle {
            didTitleHiddenTrigger.accept(true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let element = elements[safe: indexPath.row], element.isTitle {
            didTitleHiddenTrigger.accept(false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .section(let category):
            didSelectCategoryTrigger.accept(category)
        default:
            return
        }
    }
}

// MARK: Private
private extension ImportedTableView {
    func initialize() {
        register(ITTitleCell.self, forCellReuseIdentifier: String(describing: ITTitleCell.self))
        register(ITImportWithInstructionCell.self, forCellReuseIdentifier: String(describing: ITImportWithInstructionCell.self))
        register(ITImportWithoutInstructionCell.self, forCellReuseIdentifier: String(describing: ITImportWithoutInstructionCell.self))
        register(ITSectionCell.self, forCellReuseIdentifier: String(describing: ITSectionCell.self))
        register(ITGamesCell.self, forCellReuseIdentifier: String(describing: ITGamesCell.self))
        register(ITEmptyCell.self, forCellReuseIdentifier: String(describing: ITEmptyCell.self))
        
        dataSource = self
        delegate = self
    }
}

// MARK: Additional
private extension ImportedTableElement {
    var isTitle: Bool {
        switch self {
        case .title:
            return true
        default:
            return false
        }
    }
}
