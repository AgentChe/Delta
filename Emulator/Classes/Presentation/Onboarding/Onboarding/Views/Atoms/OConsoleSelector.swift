//
//  OConsoleSelector.swift
//  Delta
//
//  Created by Андрей Чернышев on 11.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class OConsoleSelector: UIView {
    lazy var lIconView = makeIconView(iconName: "Onboarding.Console.SelectorL")
    lazy var rIconView = makeIconView(iconName: "Onboarding.Console.SelectorR")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OConsoleSelector {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            lIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            lIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            lIconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lIconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            rIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            rIconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rIconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OConsoleSelector {
    func makeIconView(iconName: String) -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
