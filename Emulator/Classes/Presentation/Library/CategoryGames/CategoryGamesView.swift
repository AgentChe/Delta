//
//  CategoryGamesView.swift
//  Delta
//
//  Created by Андрей Чернышев on 23.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class CategoryGamesView: UIView {
    lazy var navBar = makeNavBar()
    lazy var collectionView = makeCollectionView()
    
    private let title: String
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CategoryGamesView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension CategoryGamesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale),
            navBar.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            collectionView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CategoryGamesView {
    func makeNavBar() -> NavBar {
        let view = NavBar(
            leftIconName: "Back",
            title: title
        )
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> CGCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 171.scale, height: 223.scale)
        layout.minimumLineSpacing = 15.scale
        layout.minimumInteritemSpacing = 15.scale
        layout.scrollDirection = .vertical
        
        let view = CGCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
