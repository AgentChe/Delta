//
//  ImportInstructionSlideView.swift
//  Delta
//
//  Created by Андрей Чернышев on 15.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ImportInstructionSlideView: UIView {
    enum Slide: CaseIterable {
        case exploring, searching, importing
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var textLabel = makeTextLabel()
    lazy var imageView = makeImageView()
    
    private let slide: Slide
    
    init(slide: Slide) {
        self.slide = slide
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension ImportInstructionSlideView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: {
                switch slide {
                case .exploring:
                    return 240.scale
                case .searching:
                    return 281.scale
                case .importing:
                    return 219.scale
                }
            }()),
            imageView.heightAnchor.constraint(equalToConstant: {
                switch slide {
                case .exploring:
                    return 293.scale
                case .searching:
                    return 99.scale
                case .importing:
                    return 98.scale
                }
            }()),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: {
                switch slide {
                case .exploring:
                    return 64.scale
                case .searching:
                    return 141.scale
                case .importing:
                    return 119.scale
                }
            }())
        ])
    }
}

// MARK: Lazy initialization
private extension ImportInstructionSlideView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 20.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = slide.title.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.RobotoMono.regular(size: 16.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = slide.text.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: slide.imageName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension ImportInstructionSlideView.Slide {
    var title: String {
        switch self {
        case .exploring:
            return "ImportInstruction.Slide1.Title".localized.uppercased()
        case .searching:
            return "ImportInstruction.Slide2.Title".localized.uppercased()
        case .importing:
            return "ImportInstruction.Slide3.Title".localized.uppercased()
        }
    }
    
    var text: String {
        switch self {
        case .exploring:
            return "ImportInstruction.Slide1.Text".localized.uppercased()
        case .searching:
            return "ImportInstruction.Slide2.Text".localized.uppercased()
        case .importing:
            return "ImportInstruction.Slide3.Text".localized.uppercased()
        }
    }
    
    var imageName: String {
        switch self {
        case .exploring:
            return "ImportInstruction.Slide1"
        case .searching:
            return "ImportInstruction.Slide2"
        case .importing:
            return "ImportInstruction.Slide3"
        }
    }
}
