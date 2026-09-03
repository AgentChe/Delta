//
//  MainViewController.swift
//  GBEmulator
//
//  Created by Андрей Чернышев on 25.04.2024.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MainViewCoordinator(parentVC: self)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, void in
                base.update(selectedTab: .home)
            })
            .disposed(by: disposeBag)
        
        addActionsToTabs()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension MainViewController {
    static func make() -> MainViewController {
        let vc = MainViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension MainViewController {
    func addActionsToTabs() {
        Observable
            .merge([
                mainView.tabView.homeItem
                    .rx.tap.map { TabView.Tab.home },
                mainView.tabView.libraryItem
                    .rx.tap.map { TabView.Tab.library },
                mainView.tabView.wallpapersItem
                    .rx.tap.map { TabView.Tab.wallpapers }
            ])
            .bind(to: Binder(self) { base, tab in
                base.update(selectedTab: tab)
            })
            .disposed(by: disposeBag)
    }
    
    func update(selectedTab: TabView.Tab) {
        coordinator.change(tab: selectedTab)
    }
}
