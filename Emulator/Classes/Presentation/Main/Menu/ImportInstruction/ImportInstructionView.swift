//
//  ImportInstructionView.swift
//  Delta
//
//  Created by Андрей Чернышев on 15.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ImportInstructionView: UIView {
    lazy var indicatorsView = makeIndicatorsView()
    lazy var closeButton = makeCloseButton()
    lazy var slidesView = makeSlidesView()
    lazy var previousButton = makeSwitchButton()
    lazy var nextButton = makeSwitchButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ImportInstructionView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension ImportInstructionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            indicatorsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale),
            indicatorsView.heightAnchor.constraint(equalToConstant: 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: indicatorsView.bottomAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            slidesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            slidesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            slidesView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16.scale),
            slidesView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: slidesView.leadingAnchor),
            previousButton.topAnchor.constraint(equalTo: slidesView.topAnchor),
            previousButton.bottomAnchor.constraint(equalTo: slidesView.bottomAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: slidesView.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: slidesView.topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: slidesView.bottomAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 50.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ImportInstructionView {
    func makeIndicatorsView() -> ImportInstructionIndicatorsView {
        let view = ImportInstructionIndicatorsView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlidesView() -> ImportInstructionSlidesView {
        let view = ImportInstructionSlidesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSwitchButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
