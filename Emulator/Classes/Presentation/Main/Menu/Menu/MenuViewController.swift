//
//  MenuViewController.swift
//  GBEmulator
//
//  Created by Андрей Чернышев on 25.04.2024.
//

import UIKit
import RxSwift
import Harmony

final class MenuViewController: UIViewController {
    private lazy var mainView = MenuView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton?.rx.tap
            .bind(to: Binder(self) { base, void in
                base.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.termsOfUseButton.rx.tap
            .bind(to: Binder(self) { base, void in
                UIApplication.shared.open(GlobalDefinitions.termsOfUseUrl)
            })
            .disposed(by: disposeBag)
        
        mainView.privacyPolicyButton.rx.tap
            .bind(to: Binder(self) { base, void in
                UIApplication.shared.open(GlobalDefinitions.privacyPolicyUrl)
            })
            .disposed(by: disposeBag)
        
        mainView.contactUsButton.rx.tap
            .bind(to: Binder(self) { base, void in
                UIApplication.shared.open(GlobalDefinitions.contactUsUrl)
            })
            .disposed(by: disposeBag)
        
        mainView.importInstructionButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let vc = ImportInstructionViewController.make()
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.clearCashButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let vc = ConfirmClearCashViewController.make()
                base.present(vc, animated: false)
            })
            .disposed(by: disposeBag)
        
        let games = DatabaseManager.shared.fetchAllGames() ?? []
        
        DispatchQueue.global().async {
            var total = Double(0)
            
            games.forEach { game in
                guard let fileSize = try? game.fileURL.resourceValues(forKeys: [.fileSizeKey]).allValues.first?.value as? Double else { return }
                total += fileSize
            }
            
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            let result = formatter.string(for: total)
            
            DispatchQueue.main.async { [weak self] in
                self?.mainView.clearCashButton.setup(value: result ?? "")
            }
        }
    }
}

// MARK: Public
extension MenuViewController {
    static func make() -> MenuViewController {
        let vc = MenuViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
