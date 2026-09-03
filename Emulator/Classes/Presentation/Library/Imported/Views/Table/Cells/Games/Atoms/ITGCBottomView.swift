//
//  ITGCBottomView.swift
//  Delta
//
//  Created by Андрей Чернышев on 05.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ITGCBottomView: UIView {
    lazy var label = makeLabel()
    lazy var menuButton = makeMenuButton()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Joystix.monospace(size: 12.scale))
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
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
extension ITGCBottomView {
    func setup(name: String) {
        label.attributedText = name.uppercased().attributed(with: attrs)
    }
}

// MARK: Private
private extension ITGCBottomView {
    func initialize() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: Make constraints
private extension ITGCBottomView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 24.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 24.scale),
            menuButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuButton.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ITGCBottomView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Imported.Menu"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
