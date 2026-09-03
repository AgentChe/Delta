//
//  ITGamesCollectionCell.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ITGamesCollectionCell: UICollectionViewCell {
    var didTapMenu: (() -> Void)?
    
    lazy var imageBackground = makeImageBackground()
    lazy var imageView = makeImageView()
    lazy var stackView = makeStackView()
    lazy var bottomView = ITGCBottomView()
    lazy var importedView = makeImportedView()
    
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
extension ITGamesCollectionCell {
    func setup(element: ImportedTableGameElement) {
        imageView.kf.setImage(with: element.game.artworkURL, placeholder: UIImage(named: "Imported.NotImage"))
        bottomView.setup(name: element.game.name)
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if !element.downloaded {
            stackView.addArrangedSubview(importedView)
        }
        
        stackView.addArrangedSubview(bottomView)
        
        layoutIfNeeded()
    }
}

// MARK: Private
private extension ITGamesCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
        
        bottomView.menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
    }
    
    @objc
    func menuTapped() {
        didTapMenu?()
    }
}

// MARK: Make constraints
private extension ITGamesCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageBackground.widthAnchor.constraint(equalToConstant: 164.scale),
            imageBackground.heightAnchor.constraint(equalToConstant: 177.scale),
            imageBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageBackground.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 136.scale),
            imageView.heightAnchor.constraint(equalToConstant: 136.scale),
            imageView.centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: imageBackground.topAnchor, constant: 13.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ITGamesCollectionCell {
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
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.backgroundColor = UIColor.clear
        view.axis = .vertical
        view.spacing = 8.scale
        view.distribution = .fill
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImportedView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 12.scale))
            .lineHeight(17.scale)
            .textAlignment(.left)
        
        let label = PaddingLabel()
        label.backgroundColor = Appearance.main200
        label.insets = UIEdgeInsets(vertical: 2.scale, horizontal: 4.scale)
        label.attributedText = "Imported.Imported".localized.uppercased().attributed(with: attrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
}
