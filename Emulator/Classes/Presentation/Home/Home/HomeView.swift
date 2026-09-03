//
//  HomeView.swift
//  Delta
//
//  Created by Андрей Чернышев on 16.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class HomeView: UIView {
    lazy var navBar = makeNavBar()
    lazy var titleLabel = makeTitleLabel()
    lazy var searchField = makeSearchField()
    lazy var categoriesView = makeCategoriesView()
    lazy var collectionView = makeCollectionView()
    lazy var centerPreloader = makePreloader()
    lazy var collectionPreloader = makePreloader()
    lazy var searchEmptyView = makeSearchEmptyView()
    
    private lazy var titleTopConstraint = NSLayoutConstraint()
    private lazy var searchFieldTopConstraint = NSLayoutConstraint()
    private lazy var collectionTopConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeView {
    func searchTransformMode(mode: HomeSearchField.Mode) {
        NSLayoutConstraint.deactivate([
            titleTopConstraint,
            searchFieldTopConstraint,
            collectionTopConstraint
        ])
        
        switch mode {
        case .normal:
            titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 16.scale)
            searchFieldTopConstraint = searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.scale)
            collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 16.scale)
        case .cancelable:
            titleTopConstraint = titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            searchFieldTopConstraint = searchField.topAnchor.constraint(equalTo: navBar.topAnchor)
            collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16.scale)
        }
        
        NSLayoutConstraint.activate([
            titleTopConstraint,
            searchFieldTopConstraint,
            collectionTopConstraint
        ])
        
        searchField.transform(to: mode, withLayout: false)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            let alpha: CGFloat = (mode == .normal) ? 1 : 0
            navBar.alpha = alpha
            titleLabel.alpha = alpha
            categoriesView.alpha = alpha
            
            layoutIfNeeded()
        })
    }
}

// MARK: Private
private extension HomeView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension HomeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale),
            navBar.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 16.scale)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleTopConstraint
        ])
        
        searchFieldTopConstraint = searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.scale)
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchField.heightAnchor.constraint(equalToConstant: 48.scale),
            searchFieldTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            categoriesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            categoriesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            categoriesView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16.scale),
            categoriesView.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 16.scale)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            collectionView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
            collectionTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            centerPreloader.widthAnchor.constraint(equalToConstant: 45.scale),
            centerPreloader.heightAnchor.constraint(equalToConstant: 45.scale),
            centerPreloader.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            centerPreloader.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionPreloader.widthAnchor.constraint(equalToConstant: 32.scale),
            collectionPreloader.heightAnchor.constraint(equalToConstant: 32.scale),
            collectionPreloader.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            collectionPreloader.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            searchEmptyView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 42.scale),
            searchEmptyView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -42.scale),
            searchEmptyView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeView {
    func makeNavBar() -> NavBar {
        let view = NavBar(rightIconName: "Menu")
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 32.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Home.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchField() -> HomeSearchField {
        let view = HomeSearchField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCategoriesView() -> HomeGameCategoriesView {
        let view = HomeGameCategoriesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> HomeGamesCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 171.scale, height: 249.scale)
        layout.minimumLineSpacing = 15.scale
        layout.minimumInteritemSpacing = 15.scale
        layout.scrollDirection = .vertical
        
        let view = HomeGamesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = Appearance.main400
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchEmptyView() -> HomeSearchEmptyResultView {
        let view = HomeSearchEmptyResultView()
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
