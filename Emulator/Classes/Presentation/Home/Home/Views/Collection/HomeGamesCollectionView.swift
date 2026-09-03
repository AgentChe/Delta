//
//  HomeGamesCollectionView.swift
//  Delta
//
//  Created by Андрей Чернышев on 17.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeGamesCollectionView: UICollectionView {
    lazy var elements = [LibraryGame]()
    
    private lazy var scrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didSelectTrigger = PublishRelay<LibraryGame>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeGamesCollectionView {
    func setup(elements: [LibraryGame]) {
        self.elements = elements
        
        reloadData()
    }
    
    func reset() {
        elements = []
        
        reloadData()
    }
    
    func add(elements: [LibraryGame]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        scrollToBottomTrigger.asSignal()
    }
    
    var didSelect: Signal<LibraryGame> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension HomeGamesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeGameCollectionCell.self), for: indexPath) as! HomeGameCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeGamesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        scrollToBottomTrigger.accept(Void())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension HomeGamesCollectionView {
    func initialize() {
        register(HomeGameCollectionCell.self, forCellWithReuseIdentifier: String(describing: HomeGameCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
