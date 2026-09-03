//
//  CGCollectionCell.swift
//  Delta
//
//  Created by Андрей Чернышев on 23.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class CGCollectionCell: UICollectionViewCell {
    var didTapMenu: (() -> Void)?
    
    lazy var imageBackground = makeImageBackground()
    lazy var imageView = makeImageView()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

// MARK: Public
extension CGCollectionCell {
    func setup(element: Game) {
        imageView.kf.setImage(with: element.artworkURL, placeholder: UIImage(named: "Imported.NotImage"))
        label.attributedText = element.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension CGCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func menuTapped() {
        didTapMenu?()
    }
}

// MARK: Make constraints
private extension CGCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageBackground.widthAnchor.constraint(equalToConstant: 171.scale),
            imageBackground.heightAnchor.constraint(equalToConstant: 185.scale),
            imageBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageBackground.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 142.scale),
            imageView.heightAnchor.constraint(equalToConstant: 142.scale),
            imageView.centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: imageBackground.topAnchor, constant: 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.scale),
            label.centerYAnchor.constraint(equalTo: menuButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 24.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 24.scale),
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            menuButton.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CGCollectionCell {
    func makeImageBackground() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Home.GameBackground")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        imageBackground.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Imported.Menu"), for: .normal)
        view.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
