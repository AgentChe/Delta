//
//  MainViewCoordinator.swift
//  Delta
//
//  Created by Андрей Чернышев on 15.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class MainViewCoordinator {
    weak var parentVC: MainViewController?
    
    lazy var homeVC = HomeViewController.make()
    lazy var libraryVC = ImportedViewController.make()
    lazy var wallpapersVC = WallpapersCategoriesViewController.make()
    
    private var previousVC: UIViewController?
    
    init(parentVC: MainViewController) {
        self.parentVC = parentVC
    }
    
    func change(tab: TabView.Tab) {
        parentVC?.mainView.tabView.selectedTab = tab
        
        switch tab {
        case .home:
            changeVC(on: homeVC)
        case .library:
            changeVC(on: libraryVC)
        case .wallpapers:
            changeVC(on: wallpapersVC)
        }
    }
}

// MARK: Private
private extension MainViewCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC = self.parentVC else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = parentVC.mainView.container.bounds
        parentVC.mainView.container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
