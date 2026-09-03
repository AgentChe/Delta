//
//  HomeViewController.swift
//  Delta
//
//  Created by Андрей Чернышев on 16.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    private lazy var mainView = HomeView()
    
    private lazy var viewModel = HomeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: HomeViewModel.Input(
            focusOnSearch: mainView.searchField.focus,
            cancelSearch: mainView.searchField.cancel,
            search: mainView.searchField.search,
            menuTapped: mainView.navBar.rightButton?.rx.tap.asSignal() ?? .never(),
            selectCategory: mainView.categoriesView.category,
            gamesDidScrollToBottom: mainView.collectionView.didScrollToBottom,
            selectGame: mainView.collectionView.didSelect
        ))
        
        output.searchTransformMode
            .drive(Binder(mainView) { base, mode in
                base.searchTransformMode(mode: mode)
            })
            .disposed(by: disposeBag)
        
        output.categories
            .drive(Binder(mainView.categoriesView) { base, categories in
                base.setup(categories: categories)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.firstPageActivity
            .drive(Binder(self) { base, activity in
                base.firstPage(activity: activity)
            })
            .disposed(by: disposeBag)
        
        output.paginationActivity
            .drive(Binder(self) { base, activity in
                base.pagination(activity: activity)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension HomeViewController {
    static func make() -> HomeViewController {
        let vc = HomeViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension HomeViewController {
    func route(_ route: HomeViewModel.Route) {
        switch route {
        case .menu:
            let vc = MenuViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .libraryGame(let game):
            let vc = LibraryGameViewController.make(libraryGame: game)
            navigationController?.pushViewController(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func action(_ action: HomeViewModel.Action) {
        switch action {
        case .reset:
            mainView.collectionView.reset()
            mainView.searchEmptyView.isHidden = true
        case .gamesPack(let gamePack):
            mainView.collectionView.add(elements: gamePack.games)
            
            mainView.searchEmptyView.isHidden = {
                switch gamePack.fetchBy {
                case .category:
                    return true
                case .search:
                    return !mainView.collectionView.elements.isEmpty
                }
            }()
        }
    }
    
    func firstPage(activity: Bool) {
        activity ? mainView.centerPreloader.startAnimating() : mainView.centerPreloader.stopAnimating()
    }
    
    func pagination(activity: Bool) {
        mainView.collectionView.contentInset.bottom = activity ? 48.scale : 0
        activity ? mainView.collectionPreloader.startAnimating() : mainView.collectionPreloader.stopAnimating()
    }
}
