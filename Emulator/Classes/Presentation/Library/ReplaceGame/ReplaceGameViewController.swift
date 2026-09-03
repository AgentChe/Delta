//
//  ReplaceGameViewController.swift
//  Delta
//
//  Created by Андрей Чернышев on 01.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ReplaceGameViewController: UIViewController {
    private lazy var mainView = ReplaceGameView(gameName: gameName)
    
    private lazy var disposeBag = DisposeBag()
    
    private let gameName: String
    private let replace: () -> Void
    private let keep: () -> Void
    
    init(gameName: String, replace: @escaping () -> Void, keep: @escaping () -> Void) {
        self.gameName = gameName
        self.replace = replace
        self.keep = keep
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
       Signal
            .merge(
                mainView.replaceButton.rx.tap.asSignal(),
                mainView.keepButton.rx.tap.asSignal()
            )
            .emit(to: Binder(self) { base, void in
                base.mainView.hide { [weak self] in
                    self?.dismiss(animated: false) { [weak self] in
                        self?.replace()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.show()
    }
}
