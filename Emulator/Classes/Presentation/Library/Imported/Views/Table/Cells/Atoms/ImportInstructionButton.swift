//
//  ImportInstructionButton.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ImportInstructionButton: UIButton {
    enum Style: Codable {
        case info, close
    }
    
    lazy var style = Style.info {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ImportInstructionButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        switch style {
        case .info:
            button.setImage(UIImage(named: "Imported.Info"), for: .normal)
        case .close:
            button.setImage(UIImage(named: "Close"), for: .normal)
        }
    }
}

// MARK: Make constraints
private extension ImportInstructionButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 24.scale),
            button.heightAnchor.constraint(equalToConstant: 24.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ImportInstructionButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 14.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Imported.InstructionTitle".localized.uppercased().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
