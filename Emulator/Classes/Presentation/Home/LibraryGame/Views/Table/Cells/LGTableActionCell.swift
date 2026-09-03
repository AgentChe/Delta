//
//  LGTableActionCell.swift
//  Delta
//
//  Created by Андрей Чернышев on 18.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class LGTableActionCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var downloadLabel = makeOnlyTextLabel(text: "LibraryGame.Download".localized.uppercased())
    lazy var cancelLoadingView = makeCancelLoadingView()
    lazy var playLabel = makeOnlyTextLabel(text: "LibraryGame.Play".localized.uppercased())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LGTableActionCell {
    func setup(element: LGTableActionElement) {
        switch element {
        case .download, .play:
            container.backgroundColor = Appearance.main400
            container.layer.shadowColor = UIColor(displayP3Red: 0.247, green: 0.502, blue: 0.196, alpha: 1).cgColor
        case .cancelLoading:
            container.backgroundColor = Appearance.main500
            container.layer.shadowColor = UIColor(integralRed: 181, green: 141, blue: 0).cgColor
        }
        
        downloadLabel.isHidden = element != .download
        cancelLoadingView.isHidden = element != .cancelLoading
        playLabel.isHidden = element != .play
    }
}

// MARK: Private
private extension LGTableActionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension LGTableActionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            downloadLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            downloadLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cancelLoadingView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            cancelLoadingView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            playLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LGTableActionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 12.scale
        view.layer.shadowOffset = CGSize(width: 0, height: 12.scale)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeOnlyTextLabel(text: String) -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
            .textAlignment(.center)
            .lineHeight(22.scale)
        
        let view = UILabel()
        view.attributedText = text.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCancelLoadingView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(named: "LibraryGame.CancelLoading")
        iconView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconView)
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 16.scale))
            .textAlignment(.center)
            .lineHeight(22.scale)
        
        let label = UILabel()
        label.attributedText = "LibraryGame.CancelLoading".localized.attributed(with: attrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.scale),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
}
