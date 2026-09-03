//
//  LGSimilarGamesCollectionCell.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class LGSimilarGamesCollectionCell: UICollectionViewCell {
    lazy var imageBackground = makeImageBackground()
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
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
extension LGSimilarGamesCollectionCell {
    func setup(element: LibraryGame) {
        imageView.kf.setImage(with: element.thumbnail)
        label.attributedText = element.title.attributed(with: attrs)
    }
}

// MARK: Private
private extension LGSimilarGamesCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension LGSimilarGamesCollectionCell {
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
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LGSimilarGamesCollectionCell {
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
}
