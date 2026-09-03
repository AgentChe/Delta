//
//  FavoritesEmptyView.swift
//  Delta
//
//  Created by Андрей Чернышев on 24.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class FavoritesEmptyView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initiailize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension FavoritesEmptyView {
    func initiailize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension FavoritesEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 164.scale),
            imageView.heightAnchor.constraint(equalToConstant: 80.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 96.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FavoritesEmptyView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Imported.Empty")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 20.scale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Imported.Empty.Title".localized.uppercased().attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
