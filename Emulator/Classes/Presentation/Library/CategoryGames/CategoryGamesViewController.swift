//
//  CategoryGamesViewController.swift
//  Delta
//
//  Created by Андрей Чернышев on 23.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryGamesViewController: UIViewController {
    private let mainView: CategoryGamesView
    
    private let viewModel: CategoryGamesViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didUpdateGamesTrigger = PublishRelay<Void>()
    
    private init(category: GameCollection) {
        self.mainView = CategoryGamesView(title: category.name)
        self.viewModel = CategoryGamesViewModel(category: category)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: CategoryGamesViewModel.Input(
            didTapClose: mainView.navBar.leftButton?.rx.tap.asSignal() ?? .never(),
            didSelectGame: mainView.collectionView.didSelect,
            didTapMenu: mainView.collectionView.didTapMenu,
            didUpdateGames: didUpdateGamesTrigger.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CategoryGamesViewController {
    static func make(category: GameCollection) -> CategoryGamesViewController {
        let vc = CategoryGamesViewController(category: category)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension CategoryGamesViewController {
    func action(_ action: CategoryGamesViewModel.Action) {
        switch action {
        case .back:
            navigationController?.popViewController(animated: true)
        case .play(let game):
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! LaunchViewController
            vc.game = game
            vc.modalPresentationStyle = .fullScreen
        case .elements(let games):
            mainView.collectionView.setup(elements: games)
        case .showMenu(let game):
            let vc = ImportMenuController(game: game) { game in
                DatabaseManager.shared.deleteGame(game) { [weak self] error in
                    self?.didUpdateGamesTrigger.accept(Void())
                    CategoryGamesMediator.shared.updateGames()
                }
            }
            present(vc, animated: false)
        }
    }
}
