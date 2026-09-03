//
//  LGTableImageCell.swift
//  Delta
//
//  Created by Андрей Чернышев on 18.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import Kingfisher

final class LGTableImageCell: UITableViewCell {
    lazy var imageBackground = makeImageBackground()
    lazy var pictureView = makeImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension LGTableImageCell {
    func setup(url: URL) {
        pictureView.kf.setImage(with: url)
    }
}

// MARK: Private
private extension LGTableImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension LGTableImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageBackground.widthAnchor.constraint(equalToConstant: 292.scale),
            imageBackground.heightAnchor.constraint(equalToConstant: 316.scale),
            imageBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 244.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 244.scale),
            pictureView.centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor),
            pictureView.topAnchor.constraint(equalTo: imageBackground.topAnchor, constant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LGTableImageCell {
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
}
