//
//  MenuRouteButton.swift
//  GBEmulator
//
//  Created by Андрей Чернышев on 25.04.2024.
//

import UIKit

final class MenuRouteButton: UIButton {
    enum Route {
        case termsOfUse, privacyPolicy, contactUs, importInstruction
    }
    
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
    
    private let route: Route
    
    init(route: Route) {
        self.route = route
        
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
        
        let path = UIBezierPath(rect: bounds)
        dotterLayer.path = path.cgPath
    }
}

// MARK: Make constraints
private extension MenuRouteButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuRouteButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = route.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension MenuRouteButton.Route {
    var title: String {
        switch self {
        case .termsOfUse:
            return "Menu.TermsOfUse".localized
        case .privacyPolicy:
            return "Menu.PrivacyPolicy".localized
        case .contactUs:
            return "Menu.ContactUs".localized
        case .importInstruction:
            return "Menu.ImportInstruction".localized
        }
    }
}
