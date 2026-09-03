//
//  CGCollectionView.swift
//  Delta
//
//  Created by Андрей Чернышев on 23.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CGCollectionView: UICollectionView {
    lazy var elements = [Game]()
    
    private lazy var didSelectTrigger = PublishRelay<Game>()
    private lazy var didTapMenuTrigger = PublishRelay<Game>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CGCollectionView {
    func setup(elements: [Game]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<Game> {
        didSelectTrigger.asSignal()
    }
    
    var didTapMenu: Signal<Game> {
        didTapMenuTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension CGCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CGCollectionCell.self), for: indexPath) as! CGCollectionCell
        cell.setup(element: element)
        cell.didTapMenu = { [weak self] in
            self?.didTapMenuTrigger.accept(element)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CGCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension CGCollectionView {
    func initialize() {
        register(CGCollectionCell.self, forCellWithReuseIdentifier: String(describing: CGCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
