//
//  HomeGameCollectionCell.swift
//  Delta
//
//  Created by Андрей Чернышев on 17.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class HomeGameCollectionCell: UICollectionViewCell {
    lazy var imageBackground = makeImageBackground()
    lazy var imageView = makeImageView()
    lazy var stackView = makeStackView()
    lazy var progressView = makeProgressView()
    lazy var nameLabel = makeLabel()
    
    private var startDownloadDisposable: Disposable?
    private var cancelDownloadDisposable: Disposable?
    private var observer: LibraryGameDownloadOperationObserver?
    
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
extension HomeGameCollectionCell {
    func setup(element: LibraryGame) {
        imageView.kf.setImage(with: element.thumbnail)
        nameLabel.attributedText = element.title.attributed(with: attrs)
        
        startDownloadDisposable?.dispose()
        cancelDownloadDisposable?.dispose()
        startDownloadDisposable = nil
        cancelDownloadDisposable = nil
        
        if let observer, let operation = LibraryGameDownloader.shared.operation(for: element) {
            operation.remove(observer: observer)
        }
        
        observer = nil
        
        if LibraryGameDownloader.shared.isDownloading(libraryGame: element), let operation = LibraryGameDownloader.shared.operation(for: element) {
            makeUI(withProgress: true)
            
            let observer = LibraryGameDownloadOperationObserver()
            
            observer.progress = { [weak self] progress in
                self?.progressView.progress = Float(progress)
            }
            
            observer.completed = { [weak self] libraryGame, result in
                self?.makeUI(withProgress: false)
            }
            
            operation.add(observer: observer)
            
            self.observer = observer
        } else {
            makeUI(withProgress: false)
        }
        
        startDownloadDisposable = LibraryGameDownloaderMediator.shared.didStartDownload
            .filter { $0.slug == element.slug }
            .emit(to: Binder(self) { base, startDownload in
                guard let operation = LibraryGameDownloader.shared.operation(for: element) else { return }
                
                base.makeUI(withProgress: true)
                
                let observer = LibraryGameDownloadOperationObserver()
                
                observer.progress = { [weak self] progress in
                    self?.progressView.progress = Float(progress)
                }
                
                observer.completed = { [weak self] libraryGame, result in
                    self?.makeUI(withProgress: false)
                }
                
                operation.add(observer: observer)
                
                base.observer = observer
            })
    }
}

// MARK: Private
private extension HomeGameCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    func makeUI(withProgress: Bool) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if withProgress {
            stackView.addArrangedSubview(progressView)
        }
        
        stackView.addArrangedSubview(nameLabel)
        
        layoutIfNeeded()
    }
}

// MARK: Make constraints
private extension HomeGameCollectionCell {
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
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 170.scale),
            progressView.heightAnchor.constraint(equalToConstant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeGameCollectionCell {
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
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 6.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = Appearance.mono100.cgColor
        view.trackTintColor = Appearance.main100
        view.progressTintColor = Appearance.main400
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
