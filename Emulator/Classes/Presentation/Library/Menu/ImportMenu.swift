//
//  ImportMenu.swift
//  Delta
//
//  Created by Андрей Чернышев on 22.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxCocoa

final class ImportMenu: UIView {
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var deleteButton = makeDeleteButton()
    lazy var closeButton = makeCloseButton()
    
    lazy var containerYConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ImportMenu {
    func show() {
        containerYConstraint.isActive = false
        containerYConstraint = container.centerYAnchor.constraint(equalTo: centerYAnchor)
        containerYConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.backgroundColor = Appearance.mono100.withAlphaComponent(0.8)
            self?.layoutIfNeeded()
        })
    }
    
    func hide(completion: (() -> Void)? = nil) {
        containerYConstraint.isActive = false
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        containerYConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.backgroundColor = Appearance.mono100.withAlphaComponent(0)
            self?.layoutIfNeeded()
        }, completion: { result in
            completion?()
        })
    }
}

// MARK: Private
private extension ImportMenu {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ImportMenu {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            containerYConstraint
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: container.topAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            closeButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 16.scale),
            closeButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ImportMenu {
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100.withAlphaComponent(0)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDeleteButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("Imported.Menu.Delete".localized.uppercased().attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main400
        view.layer.cornerRadius = 12.scale
        view.layer.shadowColor = UIColor(integralRed: 63, green: 128, blue: 50).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 12.scale)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("Imported.Menu.Close".localized.uppercased().attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 12.scale
        view.layer.shadowColor = Appearance.main300.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 12.scale)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
