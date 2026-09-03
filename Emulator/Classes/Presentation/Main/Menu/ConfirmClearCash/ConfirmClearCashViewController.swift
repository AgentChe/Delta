//
//  ConfirmClearCashViewController.swift
//  Delta
//
//  Created by Андрей Чернышев on 05.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ConfirmClearCashViewController: UIViewController {
    private lazy var mainView = ConfirmClearCashView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.rx.tap.asSignal()
            .asSignal()
            .emit(to: Binder(self) { base, void in
                base.mainView.hide {
                    base.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.button.rx.tap
            .take(1)
            .bind(to: Binder(mainView) { base, void in
                DatabaseManager.shared.deleteAllGames()
                base.makeCompleteUI()
            })
            .disposed(by: disposeBag)
        
        mainView.button.rx.tap
            .skip(1)
            .bind(to: Binder(self) { base, void in
                base.mainView.hide {
                    base.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.show()
    }
}

// MARK: Public
extension ConfirmClearCashViewController {
    static func make() -> ConfirmClearCashViewController {
        let vc = ConfirmClearCashViewController()
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}
