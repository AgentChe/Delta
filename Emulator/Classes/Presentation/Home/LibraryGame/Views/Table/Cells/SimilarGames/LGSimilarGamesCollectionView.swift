//
//  LGSimilarGamesCollectionView.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class LGSimilarGamesCollectionView: UICollectionView {
    var didSelect: ((LibraryGame) -> Void)?
    
    lazy var elements = [LibraryGame]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LGSimilarGamesCollectionView {
    func setup(elements: [LibraryGame]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension LGSimilarGamesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: LGSimilarGamesCollectionCell.self), for: indexPath) as! LGSimilarGamesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension LGSimilarGamesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 164.scale, height: 219.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(elements[indexPath.row])
    }
}

// MARK: Private
private extension LGSimilarGamesCollectionView {
    func initialize() {
        register(LGSimilarGamesCollectionCell.self, forCellWithReuseIdentifier: String(describing: LGSimilarGamesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
