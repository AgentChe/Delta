//
//  ReplaceGameView.swift
//  Delta
//
//  Created by Андрей Чернышев on 01.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ReplaceGameView: UIView {
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var imageView = makeImageView()
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var nameLabel = makeNameLabel()
    lazy var replaceButton = makeReplaceButton()
    lazy var keepButton = makeKeepButton()
    
    lazy var containerYConstraint = NSLayoutConstraint()
    
    private let gameName: String
    
    init(gameName: String) {
        self.gameName = gameName
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReplaceGameView {
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
private extension ReplaceGameView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ReplaceGameView {
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
            imageView.widthAnchor.constraint(equalToConstant: 84.scale),
            imageView.heightAnchor.constraint(equalToConstant: 84.scale),
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 24.scale),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 26.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -26.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 124.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 26.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -26.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 26.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -26.scale),
            nameLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            replaceButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            replaceButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            replaceButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 34.scale),
            replaceButton.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            keepButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            keepButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            keepButton.topAnchor.constraint(equalTo: replaceButton.bottomAnchor, constant: 27.scale),
            keepButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -55.scale),
            keepButton.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReplaceGameView {
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100.withAlphaComponent(0)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "ReplaceGame.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "ReplaceGame.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 20.scale))
            .textAlignment(.center)
            .lineHeight(24.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "ReplaceGame.Title".localized.uppercased().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.RobotoMono.regular(size: 16.scale))
            .textAlignment(.center)
            .lineHeight(22.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "ReplaceGame.SubTitle".localized.uppercased().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 12.scale))
            .textAlignment(.center)
            .lineHeight(17.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = gameName.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeReplaceButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("ReplaceGame.Replace".localized.uppercased().attributed(with: attrs), for: .normal)
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
    
    func makeKeepButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("ReplaceGame.Keep".localized.uppercased().attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main200
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
