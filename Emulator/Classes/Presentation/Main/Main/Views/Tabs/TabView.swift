//
//  TabView.swift
//  Delta
//
//  Created by Андрей Чернышев on 15.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case home, library, wallpapers
    }
    
    lazy var container = makeContainer()
    lazy var homeItem = makeItem(code: "Main.Home")
    lazy var libraryItem = makeItem(code: "Main.Library")
    lazy var wallpapersItem = makeItem(code: "Main.Wallpapers")
    
    var selectedTab = Tab.home {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func update() {
        homeItem.marked = selectedTab == .home
        libraryItem.marked = selectedTab == .library
        wallpapersItem.marked = selectedTab == .wallpapers
        
        [homeItem, libraryItem, wallpapersItem].forEach { $0.prepareForUpdateLayout() }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            [homeItem, libraryItem, wallpapersItem].forEach { $0.updateUI() }
            
            layoutIfNeeded()
        })
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 19.scale)
        ])
        
        NSLayoutConstraint.activate([
            homeItem.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            homeItem.trailingAnchor.constraint(equalTo: libraryItem.leadingAnchor, constant: -32.scale),
            homeItem.topAnchor.constraint(equalTo: container.topAnchor),
            homeItem.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            libraryItem.topAnchor.constraint(equalTo: container.topAnchor),
            libraryItem.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            wallpapersItem.leadingAnchor.constraint(equalTo: libraryItem.trailingAnchor, constant: 32.scale),
            wallpapersItem.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            wallpapersItem.topAnchor.constraint(equalTo: container.topAnchor),
            wallpapersItem.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItem(code: String) -> TabItemButton {
        let view = TabItemButton(code: code)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
