//
//  MenuView.swift
//  GBEmulator
//
//  Created by Андрей Чернышев on 25.04.2024.
//

import UIKit

final class MenuView: UIView {
    lazy var navBar = makeNavBar()
    lazy var termsOfUseButton = makeRouteButton(route: .termsOfUse)
    lazy var privacyPolicyButton = makeRouteButton(route: .privacyPolicy)
    lazy var contactUsButton = makeRouteButton(route: .contactUs)
    lazy var importInstructionButton = makeRouteButton(route: .importInstruction)
    lazy var clearCashButton = makeClearCashButton()
    
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
private extension MenuView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension MenuView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale),
            navBar.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            termsOfUseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            termsOfUseButton.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            contactUsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            contactUsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            contactUsButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            importInstructionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            importInstructionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            importInstructionButton.topAnchor.constraint(equalTo: contactUsButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            clearCashButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            clearCashButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            clearCashButton.topAnchor.constraint(equalTo: importInstructionButton.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuView {
    func makeNavBar() -> NavBar {
        let view = NavBar(
            leftIconName: "Back",
            title: "Menu.Title".localized
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRouteButton(route: MenuRouteButton.Route) -> MenuRouteButton {
        let view = MenuRouteButton(route: route)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeClearCashButton() -> MenuClearCashButton {
        let view = MenuClearCashButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
