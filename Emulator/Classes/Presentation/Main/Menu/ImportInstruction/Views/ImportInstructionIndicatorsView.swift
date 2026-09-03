//
//  ImportInstructionIndicatorsView.swift
//  Delta
//
//  Created by Андрей Чернышев on 15.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ImportInstructionIndicatorsView: UIView {
    lazy var slide1ProgressView = makeProgressView()
    lazy var slide2ProgressView = makeProgressView()
    lazy var slide3ProgressView = makeProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ImportInstructionIndicatorsView {
    func seconds(passed: Float, total: Float) {
        let forEach = total / 3
        
        slide1ProgressView.progress = passed / forEach
        slide2ProgressView.progress = (passed / forEach) - 1
        slide3ProgressView.progress = (passed / forEach) - 2
    }
}

// MARK: Make constraints
private extension ImportInstructionIndicatorsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            slide1ProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            slide1ProgressView.trailingAnchor.constraint(equalTo: slide2ProgressView.leadingAnchor, constant: -8.scale),
            slide1ProgressView.heightAnchor.constraint(equalToConstant: 6.scale),
            slide1ProgressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            slide1ProgressView.widthAnchor.constraint(equalTo: slide2ProgressView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            slide2ProgressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            slide2ProgressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            slide2ProgressView.heightAnchor.constraint(equalToConstant: 6.scale),
            slide2ProgressView.widthAnchor.constraint(equalTo: slide3ProgressView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            slide3ProgressView.leadingAnchor.constraint(equalTo: slide2ProgressView.trailingAnchor, constant: 8.scale),
            slide3ProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            slide3ProgressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            slide3ProgressView.heightAnchor.constraint(equalToConstant: 6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ImportInstructionIndicatorsView {
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.trackTintColor = Appearance.main200
        view.progressTintColor = Appearance.main400
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
