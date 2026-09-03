//
//  OConsoleItemView.swift
//  Delta
//
//  Created by Андрей Чернышев on 11.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class OConsoleItemButton: UIButton {
    enum Console {
        case gbc, gba, nes, snes, n64
    }
    
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    private lazy var dotterLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Appearance.main300.cgColor
        shapeLayer.lineWidth = 2.scale
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [NSNumber(value: 6.scale), NSNumber(value: 3.scale)]
        layer.addSublayer(shapeLayer)
        return shapeLayer
    }()
    
    private let console: Console
    
    init(console: Console) {
        self.console = console
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dotterLayer.bounds = bounds
        dotterLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let path: UIBezierPath = {
            switch console {
            case .gbc:
                return UIBezierPath(rect: bounds)
            case .gba, .nes, .snes, .n64:
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: bounds.height))
                path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
                path.addLine(to: CGPoint(x: bounds.width, y: 0))
                return path
            }
        }()
        
        dotterLayer.path = path.cgPath
    }
}

// MARK: Make constraints
private extension OConsoleItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 40.scale),
            iconView.heightAnchor.constraint(equalToConstant: 40.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OConsoleItemButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Onboarding.Console.\(console.key)")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Console.\(console.key)".localized.uppercased().attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension OConsoleItemButton.Console {
    var key: String {
        switch self {
        case .gbc:
            return "GBC"
        case .gba:
            return "GBA"
        case .nes:
            return "NES"
        case .snes:
            return "SNES"
        case .n64:
            return "N64"
        }
    }
}
