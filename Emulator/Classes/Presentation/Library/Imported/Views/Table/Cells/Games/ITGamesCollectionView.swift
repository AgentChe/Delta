//
//  ITGamesCollectionView.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ITGamesCollectionView: UICollectionView {
    var didSelect: ((Game) -> Void)?
    var didTapMenu: ((Game) -> Void)?
    
    lazy var elements = [ImportedTableGameElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ITGamesCollectionView {
    func setup(elements: [ImportedTableGameElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension ITGamesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ITGamesCollectionCell.self), for: indexPath) as! ITGamesCollectionCell
        cell.setup(element: element)
        cell.didTapMenu = { [weak self] in
            self?.didTapMenu?(element.game)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ITGamesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 164.scale, height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(elements[indexPath.row].game)
    }
}

// MARK: Private
private extension ITGamesCollectionView {
    func initialize() {
        register(ITGamesCollectionCell.self, forCellWithReuseIdentifier: String(describing: ITGamesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
