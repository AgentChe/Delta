//
//  MenuClearCashButton.swift
//  Delta
//
//  Created by Андрей Чернышев on 05.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class MenuClearCashButton: UIButton {
    lazy var placeholderLabel = makeTitleLabel()
    lazy var valueLabel = makeValueLabel()
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.5))
        .font(Fonts.RobotoMono.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.right)
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dotterLayer.bounds = bounds
        dotterLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let path = UIBezierPath(rect: bounds)
        dotterLayer.path = path.cgPath
    }
}

// MARK: Public
extension MenuClearCashButton {
    func setup(value: String) {
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
}

// MARK: Make constraints
private extension MenuClearCashButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            valueLabel.centerYAnchor.constraint(equalTo: placeholderLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuClearCashButton {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Menu.ClearCash".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
