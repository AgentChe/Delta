//
//  ConfirmClearCashView.swift
//  Delta
//
//  Created by Андрей Чернышев on 05.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ConfirmClearCashView: UIView {
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var closeButton = makeCloseButton()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var textLabel = makeTextLabel()
    lazy var completeView = makeCompleteView()
    lazy var button = makeButton()
    
    lazy var containerYConstraint = NSLayoutConstraint()
    
    private lazy var textAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.RobotoMono.regular(size: 16.scale))
        .textAlignment(.center)
        .lineHeight(22.scale)
    private lazy var buttonAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Joystix.monospace(size: 16.scale))
        .textAlignment(.center)
    
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
extension ConfirmClearCashView {
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
    
    func makeCompleteUI() {
        textLabel.attributedText = "ClearCash.Text.Complete".localized.uppercased().attributed(with: textAttrs)
        button.setAttributedTitle("ClearCash.Button.Complete".localized.uppercased().attributed(with: buttonAttrs), for: .normal)
        completeView.isHidden = false
    }
}

// MARK: Private
private extension ConfirmClearCashView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ConfirmClearCashView {
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
            container.heightAnchor.constraint(equalToConstant: 414.scale),
            containerYConstraint
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 84.scale),
            imageView.heightAnchor.constraint(equalToConstant: 84.scale),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            completeView.widthAnchor.constraint(equalToConstant: 178.scale),
            completeView.heightAnchor.constraint(equalToConstant: 24.scale),
            completeView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 74.scale),
            completeView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -46.scale),
            button.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ConfirmClearCashView {
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
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Menu.ConfirmCC.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Menu.ConfirmCC.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "ClearCash.Title".localized.uppercased().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let view = UILabel()
        view.attributedText = "ClearCash.Text.Start".localized.uppercased().attributed(with: textAttrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCompleteView() -> UIImageView {
        let view = UIImageView()
        view.isHidden = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Menu.ConfirmCC.Complete")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.setAttributedTitle("ClearCash.Button.Start".localized.uppercased().attributed(with: buttonAttrs), for: .normal)
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
}
