//
//  ITImportWithInstructionCell.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ITImportWithInstructionCell: UITableViewCell {
    var didImport: (() -> Void)?
    var didOpenInstruction: (() -> Void)?
    var didCloseInstruction: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var importButton = makeImportButton()
    lazy var separator = makeSeparator()
    lazy var instructionButton = makeInstructionButton()
    
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
extension ITImportWithInstructionCell {
    func setup(style: ImportInstructionButton.Style) {
        instructionButton.style = style
    }
}

// MARK: Private
private extension ITImportWithInstructionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func importTapped() {
        didImport?()
    }
    
    @objc
    func instructionTapped() {
        didOpenInstruction?()
    }
    
    @objc
    func instructionIconTapped() {
        switch instructionButton.style {
        case .info:
            didOpenInstruction?()
        case .close:
            didCloseInstruction?()
        }
    }
}

// MARK: Make constraints
private extension ITImportWithInstructionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 137.scale)
        ])
        
        NSLayoutConstraint.activate([
            importButton.widthAnchor.constraint(equalToConstant: 90.scale),
            importButton.heightAnchor.constraint(equalToConstant: 50.scale),
            importButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            importButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.topAnchor.constraint(equalTo: importButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            instructionButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            instructionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            instructionButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ITImportWithInstructionCell {
    func makeContainer() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Imported.ImportBackground.Large")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImportButton() -> ImportGameButton {
        let view = ImportGameButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(importTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeInstructionButton() -> ImportInstructionButton {
        let view = ImportInstructionButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.button.addTarget(self, action: #selector(instructionIconTapped), for: .touchUpInside)
        view.addTarget(self, action: #selector(instructionTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
