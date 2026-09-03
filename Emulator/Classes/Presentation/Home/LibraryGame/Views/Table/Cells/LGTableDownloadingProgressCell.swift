//
//  LGTableDownloadingProgressCell.swift
//  Delta
//
//  Created by Андрей Чернышев on 04.09.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class LGTableDownloadingProgressCell: UITableViewCell {
    lazy var progressView = makeProgressView()
    lazy var progressLabel = makeProgressLabel()
    lazy var downloadedView = makeDownloadedView()
    
    private var observer: LibraryGameDownloadOperationObserver?
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.RobotoMono.bold(size: 16.scale))
        .lineHeight(23.scale)
        .letterSpacing(-0.24.scale)
        .textAlignment(.center)
    
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
extension LGTableDownloadingProgressCell {
    func setup(element: LGTableProgressElement) {
        switch element {
        case .loading(let observer):
            guard self.observer?.identifier != observer.identifier else { return }
            
            self.observer = observer
            
            self.observer?.progress = { [weak self] progress in
                guard let self else { return }
                
                progressView.progress = Float(progress)
                
                let percent = Int(progress * 100)
                progressLabel.attributedText = String(format: "%i%%", percent).attributed(with: attrs)
                progressLabel.isHidden = false
            }
            
            self.observer?.completed = { [weak self] libraryGame, result in
                guard let self else { return }
                
                switch result {
                case .cancelled, .error:
                    progressLabel.isHidden = true
                    downloadedView.isHidden = true
                    progressView.progress = 0
                case .game:
                    progressLabel.isHidden = true
                    downloadedView.isHidden = false
                    progressView.progress = 1
                }
            }
        case .downloaded:
            progressLabel.isHidden = true
            downloadedView.isHidden = false
            progressView.progress = 1
        }
    }
}

// MARK: Private
private extension LGTableDownloadingProgressCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        progressLabel.isHidden = true
        downloadedView.isHidden = true
    }
}

// MARK: Make constraints
private extension LGTableDownloadingProgressCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 178.scale),
            progressView.heightAnchor.constraint(equalToConstant: 24.scale),
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22.scale),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            downloadedView.widthAnchor.constraint(equalToConstant: 24.scale),
            downloadedView.heightAnchor.constraint(equalToConstant: 24.scale),
            downloadedView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            downloadedView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LGTableDownloadingProgressCell {
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = Appearance.mono100.cgColor
        view.trackTintColor = Appearance.main100
        view.progressTintColor = Appearance.main400
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeDownloadedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "LibraryGame.DownloadCompleted")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
