//
//  LGTableView.swift
//  Delta
//
//  Created by Андрей Чернышев on 18.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LGTableView: UITableView {
    lazy var elements = [LGTableElement]()
    
    private lazy var didTapActionTrigger = PublishRelay<LGTableActionElement>()
    private lazy var didImportInstructionTrigger = PublishRelay<Void>()
    private lazy var didSelectTrigger = PublishRelay<LibraryGame>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LGTableView {
    func setup(elements: [LGTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapAction: Signal<LGTableActionElement> {
        didTapActionTrigger.asSignal()
    }
    
    var didImportInstruction: Signal<Void> {
        didImportInstructionTrigger.asSignal()
    }
    
    var didSelect: Signal<LibraryGame> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension LGTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .image(let url):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGTableImageCell.self)) as! LGTableImageCell
            cell.setup(url: url)
            return cell
        case .category(let category):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGTableCategoryCell.self)) as! LGTableCategoryCell
            cell.setup(category: category)
            return cell
        case .name(let name):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGTableNameCell.self)) as! LGTableNameCell
            cell.setup(name: name)
            return cell
        case .country(let country):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGTableCountryCell.self)) as! LGTableCountryCell
            cell.setup(country: country)
            return cell
        case .title(let title):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGTableTitleCell.self)) as! LGTableTitleCell
            cell.setup(title: title)
            return cell
        case .description(let description):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGTableDescriptionCell.self)) as! LGTableDescriptionCell
            cell.setup(description: description)
            return cell
        case .action(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGTableActionCell.self)) as! LGTableActionCell
            cell.setup(element: element)
            return cell
        case .similarGames(let games):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGSimilarGamesCell.self)) as! LGSimilarGamesCell
            cell.collectionView.didSelect = { [weak self] game in
                self?.didSelectTrigger.accept(game)
            }
            cell.collectionView.setup(elements: games)
            return cell
        case .importInstruction:
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGTableImportInstructionCell.self)) as! LGTableImportInstructionCell
            cell.didTap = { [weak self] in
                self?.didImportInstructionTrigger.accept(Void())
            }
            return cell
        case .progress(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: LGTableDownloadingProgressCell.self)) as! LGTableDownloadingProgressCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension LGTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .image:
            return 316.scale
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .action(element) = elements[indexPath.row] else { return }
        didTapActionTrigger.accept(element)
    }
}

// MARK: Private
private extension LGTableView {
    func initialize() {
        register(LGTableImageCell.self, forCellReuseIdentifier: String(describing: LGTableImageCell.self))
        register(LGTableCategoryCell.self, forCellReuseIdentifier: String(describing: LGTableCategoryCell.self))
        register(LGTableNameCell.self, forCellReuseIdentifier: String(describing: LGTableNameCell.self))
        register(LGTableCountryCell.self, forCellReuseIdentifier: String(describing: LGTableCountryCell.self))
        register(LGTableTitleCell.self, forCellReuseIdentifier: String(describing: LGTableTitleCell.self))
        register(LGTableDescriptionCell.self, forCellReuseIdentifier: String(describing: LGTableDescriptionCell.self))
        register(LGTableActionCell.self, forCellReuseIdentifier: String(describing: LGTableActionCell.self))
        register(LGTableImportInstructionCell.self, forCellReuseIdentifier: String(describing: LGTableImportInstructionCell.self))
        register(LGSimilarGamesCell.self, forCellReuseIdentifier: String(describing: LGSimilarGamesCell.self))
        register(LGTableDownloadingProgressCell.self, forCellReuseIdentifier: String(describing: LGTableDownloadingProgressCell.self))
        
        dataSource = self
        delegate = self
    }
}
