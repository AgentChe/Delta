//
//  NavBar.swift
//  Delta
//
//  Created by Андрей Чернышев on 15.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class NavBar: UIView {
    lazy var leftButton = makeLeftButton()
    lazy var titleLabel = makeLabel()
    lazy var rightButton = makeRightButton()
    
    private let leftIconName: String?
    private let title: String?
    private let rightIconName: String?
    
    init(
        leftIconName: String? = nil,
        title: String? = nil,
        rightIconName: String? = nil
    ) {
        self.leftIconName = leftIconName
        self.title = title
        self.rightIconName = rightIconName
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension NavBar {
    func makeConstraints() {
        if let leftButton {
            NSLayoutConstraint.activate([
                leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
                leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                leftButton.widthAnchor.constraint(equalToConstant: 24.scale),
                leftButton.heightAnchor.constraint(equalToConstant: 24.scale)
            ])
        }
        
        if let titleLabel {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftButton == nil ? 16.scale : 48.scale),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        if let rightButton {
            NSLayoutConstraint.activate([
                rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
                rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                rightButton.widthAnchor.constraint(equalToConstant: 24.scale),
                rightButton.heightAnchor.constraint(equalToConstant: 24.scale)
            ])
        }
    }
}

// MARK: Lazy initialization
private extension NavBar {
    func makeLeftButton() -> TapAreaButton? {
        guard let leftIconName else { return nil }
        
        let view = TapAreaButton()
        view.setImage(UIImage(named: leftIconName), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel? {
        guard let title else { return nil }
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 18.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRightButton() -> TapAreaButton? {
        guard let rightIconName else { return nil }
        
        let view = TapAreaButton()
        view.setImage(UIImage(named: rightIconName), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
