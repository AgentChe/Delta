//
//  ImportMenuController.swift
//  Delta
//
//  Created by Андрей Чернышев on 22.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift

final class ImportMenuController: UIViewController {
    private lazy var mainView = ImportMenu()
    
    private lazy var disposeBag = DisposeBag()
    
    private let game: Game
    private let delete: ((Game) -> Void)
    
    init(game: Game, delete: @escaping ((Game) -> Void)) {
        self.game = game
        self.delete = delete
        
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
        
        mainView.deleteButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.mainView.hide {
                    base.dismiss(animated: false) {
                        base.delete(base.game)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
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
