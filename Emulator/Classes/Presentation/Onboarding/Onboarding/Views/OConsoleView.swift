//
//  OConsoleView.swift
//  Delta
//
//  Created by Андрей Чернышев on 11.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class OConsoleView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var gbcItemButton = makeItemButton(console: .gbc)
    lazy var gbaItemButton = makeItemButton(console: .gba)
    lazy var nesItemButton = makeItemButton(console: .nes)
    lazy var snesItemButton = makeItemButton(console: .snes)
    lazy var n64ItemButton = makeItemButton(console: .n64)
    lazy var selector = makeSelector()
    lazy var continueButton = makeContinueButton()
    
    private lazy var selectorVerticalConstraint = NSLayoutConstraint()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OConsoleView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    @objc
    func itemTapped(sender: UIButton) {
        selectorVerticalConstraint.isActive = false
        selectorVerticalConstraint = selector.centerYAnchor.constraint(equalTo: sender.centerYAnchor)
        selectorVerticalConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }
}

// MARK: Make constraints
private extension OConsoleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 87.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            gbcItemButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52.scale),
            gbcItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -52.scale),
            gbcItemButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            gbaItemButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52.scale),
            gbaItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -52.scale),
            gbaItemButton.topAnchor.constraint(equalTo: gbcItemButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nesItemButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52.scale),
            nesItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -52.scale),
            nesItemButton.topAnchor.constraint(equalTo: gbaItemButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            snesItemButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52.scale),
            snesItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -52.scale),
            snesItemButton.topAnchor.constraint(equalTo: nesItemButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            n64ItemButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52.scale),
            n64ItemButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -52.scale),
            n64ItemButton.topAnchor.constraint(equalTo: snesItemButton.bottomAnchor)
        ])
        
        selectorVerticalConstraint = selector.centerYAnchor.constraint(equalTo: gbcItemButton.centerYAnchor)
        NSLayoutConstraint.activate([
            selectorVerticalConstraint,
            selector.leadingAnchor.constraint(equalTo: gbcItemButton.leadingAnchor, constant: -24.scale),
            selector.trailingAnchor.constraint(equalTo: gbcItemButton.trailingAnchor, constant: 24.scale),
            selector.heightAnchor.constraint(equalToConstant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OConsoleView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 18.scale))
            .lineHeight(25.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Console.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItemButton(console: OConsoleItemButton.Console) -> OConsoleItemButton {
        let view = OConsoleItemButton(console: console)
        view.backgroundColor = UIColor.clear
        view.addTarget(self, action: #selector(itemTapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSelector() -> OConsoleSelector {
        let view = OConsoleSelector()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.uppercased().attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 12.scale
        view.layer.shadowColor = UIColor(displayP3Red: 0.247, green: 0.502, blue: 0.196, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 12.scale)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 0
        view.backgroundColor = Appearance.main400
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
