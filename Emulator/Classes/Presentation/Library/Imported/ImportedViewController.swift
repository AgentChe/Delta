//
//  ImportedViewController.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices

final class ImportedViewController: UIViewController {
    private lazy var mainView = ImportedView()
    
    private lazy var viewModel = ImportedViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didImportedGamesUrlsTrigger = PublishRelay<Set<URL>>()
    private lazy var didUpdateGamesTrigger = PublishRelay<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ImportedViewModel.Input(
            didTapFavorites: mainView.navBar.rightButton?.rx.tap.asSignal() ?? .never(),
            didTitleHidden: mainView.tableView.didTitleHidden,
            didImport: mainView.tableView.didImport,
            didOpenInstruction: mainView.tableView.didOpenInstruction,
            didCloseInstruction: mainView.tableView.didCloseInstruction,
            didSelectGame: mainView.tableView.didSelectGame,
            didTapMenu: mainView.tableView.didTapMenu,
            didSelectCategory: mainView.tableView.didSelectCategory,
            didImportedGamesUrls: didImportedGamesUrlsTrigger.asSignal(),
            didUpdateGames: didUpdateGamesTrigger.asSignal()
        ))
        
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
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ImportedViewController {
    static func make() -> ImportedViewController {
        let vc = ImportedViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: ImportControllerDelegate
extension ImportedViewController: ImportControllerDelegate {
    func importController(_ importController: ImportController, didImportItemsAt urls: Set<URL>, errors: [any Error]) {
        didImportedGamesUrlsTrigger.accept(urls)
    }
}

// MARK: Private
private extension ImportedViewController {
    func route(_ route: ImportedViewModel.Route) {
        switch route {
        case .favorites:
            let vc = FavoritesViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .importInstruction:
            let vc = ImportInstructionViewController.make()
            present(vc, animated: true)
        case .importGames:
            let documentTypes = System.registeredSystems.map { $0.gameType.rawValue } + [
                GlobalDefinitions.ImportedTypesIds.zipArchive,
                GlobalDefinitions.ImportedTypesIds.skin,
                GlobalDefinitions.ImportedTypesIds.gba,
                GlobalDefinitions.ImportedTypesIds.gbc,
                GlobalDefinitions.ImportedTypesIds.gb
            ]
            let types = Set(documentTypes)
            
            let importController = ImportController(documentTypes: types)
            importController.delegate = self
            
            present(importController, animated: true, completion: nil)
        case .categoryGames(let category):
            let vc = CategoryGamesViewController.make(category: category)
            navigationController?.pushViewController(vc, animated: true)
        case .play(let game):
            print("GAME TYPE: \(game.type)")
            let vc = LaunchViewController.make(game: game)
            present(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func action(_ action: ImportedViewModel.Action) {
        switch action {
        case .titleHidden(let hidden):
            mainView.titleLabel.isHidden = hidden
        case .showMenu(let game):
            let vc = ImportMenuController(game: game) { game in
                DatabaseManager.shared.deleteGame(game) { [weak self] error in
                    self?.didUpdateGamesTrigger.accept(Void())
                }
            }
            present(vc, animated: false)
        case .saveImportedGamesUrls(let urls):
            DatabaseManager.shared.importGames(at: urls) { [weak self] game, error in
                self?.didUpdateGamesTrigger.accept(Void())
            }
        case .requestReplaceGames(let games, let urls):
            let names = games
                .map { $0.name }
                .joined(separator: "\n")
            let vc = ReplaceGameViewController(gameName: names, replace: {
                DatabaseManager.shared.importGames(at: urls) { [weak self] game, error in
                    self?.didUpdateGamesTrigger.accept(Void())
                }
            }, keep: {
                DatabaseManager.shared.importGames(at: urls) { [weak self] game, error in
                    self?.didUpdateGamesTrigger.accept(Void())
                }
            })
            present(vc, animated: false)
        }
    }
}
