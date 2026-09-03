//
//  TabItemButton.swift
//  Delta
//
//  Created by Андрей Чернышев on 15.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class TabItemButton: UIButton {
    lazy var marked = false
    
    lazy var container = makeContainer()
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    private lazy var iconTrailingConstraint = NSLayoutConstraint()
    
    private let code: String
    
    init(code: String) {
        self.code = code
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TabItemButton {
    func prepareForUpdateLayout() {
        iconTrailingConstraint.isActive = false
        iconTrailingConstraint = iconView.trailingAnchor.constraint(equalTo: marked ? label.leadingAnchor : container.trailingAnchor, constant: -8.scale)
        iconTrailingConstraint.isActive = true
    }
    
    func updateUI() {
        container.backgroundColor = marked ? Appearance.main200 : UIColor.clear
        container.layer.borderWidth = marked ? 1.scale : 0
        container.layer.borderColor = marked ? Appearance.main300.cgColor : UIColor.clear.cgColor
        
        label.alpha = marked ? 1 : 0
    }
}

// MARK: Make constraints
private extension TabItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        iconTrailingConstraint = iconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 32.scale),
            iconView.heightAnchor.constraint(equalToConstant: 32.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 5.scale),
            iconView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5.scale),
            iconTrailingConstraint
        ])
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemButton {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: code)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 12.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = code.localized.uppercased().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
