//
//  LibraryGameViewController.swift
//  Delta
//
//  Created by Андрей Чернышев on 18.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift

final class LibraryGameViewController: UIViewController {
  
    
    
    private lazy var mainView = LibraryGameView()
    
    private let viewModel: LibraryGameViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(libraryGame: LibraryGame) {
        viewModel = LibraryGameViewModel(libraryGame: libraryGame)
        
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
        
        let output = viewModel.configure(input: LibraryGameViewModel.Input(
            didBackTapped: mainView.navBar.leftButton?.rx.tap.asSignal() ?? .never(),
            didTapAction: mainView.tableView.didTapAction,
            didImportInstruction: mainView.tableView.didImportInstruction,
            didSelectGame: mainView.tableView.didSelect,
            didTapBookmark: mainView.navBar.rightButton?.rx.tap.asSignal() ?? .never()
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
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
        
        output.favorite
            .drive(Binder(self) { base, favorite in
                base.update(favorite: favorite)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension LibraryGameViewController {
    static func make(libraryGame: LibraryGame) -> LibraryGameViewController {
        let vc = LibraryGameViewController(libraryGame: libraryGame)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension LibraryGameViewController {
    func route(_ route: LibraryGameViewModel.Route) {
        switch route {
        case .dismiss:
            navigationController?.popViewController(animated: true)
        case .importInstruction:
            let vc = ImportInstructionViewController.make()
            present(vc, animated: true)
        case .libraryGame(let game):
            let vc = LibraryGameViewController.make(libraryGame: game)
            navigationController?.pushViewController(vc, animated: true)
        case .play(let game):
            let vc = LaunchViewController.make(game: game)
            present(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func action(_ action: LibraryGameViewModel.Action) {
        switch action {
        case .download(let libraryGame):
            LibraryGameDownloader.shared.download(libraryGame: libraryGame)
        case .cancelLoading(let libraryGame):
            LibraryGameDownloader.shared.cancel(libraryGame: libraryGame)
        }
    }
    
    func update(favorite: Bool) {
        let iconName = favorite ? "Favorite.S" : "Favorite.D"
        let icon = UIImage(named: iconName)
        mainView.navBar.rightButton?.setImage(icon, for: .normal)
    }
}
