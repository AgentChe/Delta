//
//  FavoritesViewController.swift
//  Delta
//
//  Created by Андрей Чернышев on 24.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift

final class FavoritesViewController: UIViewController {
    private lazy var mainView = FavoritesView()
    
    private lazy var viewModel = FavoritesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: FavoritesViewModel.Input(
            didSelect: mainView.collectionView.didSelect,
            didTapBack: mainView.navBar.leftButton?.rx.tap.asSignal() ?? .never()
        ))
        
        output.elements
            .drive(Binder(mainView) { base, elements in
                base.collectionView.setup(elements: elements)
                base.emptyView.isHidden = !elements.isEmpty
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension FavoritesViewController {
    static func make() -> FavoritesViewController {
        let vc = FavoritesViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension FavoritesViewController {
    func route(_ route: FavoritesViewModel.Route) {
        switch route {
        case .back:
            navigationController?.popViewController(animated: true)
        case .play(let game):
            let vc = LibraryGameViewController.make(libraryGame: game)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
