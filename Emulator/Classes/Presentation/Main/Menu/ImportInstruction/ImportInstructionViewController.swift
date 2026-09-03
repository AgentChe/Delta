//
//  ImportInstructionViewController.swift
//  Delta
//
//  Created by Андрей Чернышев on 15.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift

final class ImportInstructionViewController: UIViewController {
    enum Constants {
        static let forEach = Float(10)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    private lazy var mainView = ImportInstructionView()
    
    private lazy var disposeBag = DisposeBag()
    
    private var timer: Timer?
    
    private var secondsPassed: Float = 0
    private let totalSeconds = Float(ImportInstructionSlideView.Slide.allCases.count) * Constants.forEach
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.previousButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.previousTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.nextTapped()
            })
            .disposed(by: disposeBag)
        
        startTimer()
    }
}

// MARK: Public
extension ImportInstructionViewController {
    static func make() -> ImportInstructionViewController {
        let vc = ImportInstructionViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension ImportInstructionViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            secondsPassed += 0.1
            
            mainView.indicatorsView.seconds(passed: secondsPassed, total: totalSeconds)
            
            let tolerance: Float = 0.05

            if abs(secondsPassed - Constants.forEach) < tolerance || abs(secondsPassed - Constants.forEach * 2) < tolerance {
                mainView.slidesView.next()
            }
            
            if abs(secondsPassed - totalSeconds) < tolerance {
                dismiss(animated: true)
            }
        }
    }
    
    func previousTapped() {
        mainView.slidesView.previous()
        
        secondsPassed = mainView.slidesView.current().startSeconds
        mainView.indicatorsView.seconds(passed: secondsPassed, total: totalSeconds)
    }
    
    func nextTapped() {
        guard mainView.slidesView.hasNext() else {
            dismiss(animated: true)
            return
        }
        
        mainView.slidesView.next()
        
        secondsPassed = mainView.slidesView.current().startSeconds
        mainView.indicatorsView.seconds(passed: secondsPassed, total: totalSeconds)
    }
}

// MARK: Additional
private extension ImportInstructionSlideView.Slide {
    var startSeconds: Float {
        switch self {
        case .exploring:
            return 0
        case .searching:
            return ImportInstructionViewController.Constants.forEach
        case .importing:
            return ImportInstructionViewController.Constants.forEach * 2
        }
    }
}
