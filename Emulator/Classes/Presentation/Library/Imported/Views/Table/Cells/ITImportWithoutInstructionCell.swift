//
//  ITImportWithoutInstructionCell.swift
//  Delta
//
//  Created by Андрей Чернышев on 19.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ITImportWithoutInstructionCell: UITableViewCell {
    var didImport: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var importButton = makeImportButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ITImportWithoutInstructionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func importTapped() {
        didImport?()
    }
}

// MARK: Make constraints
private extension ITImportWithoutInstructionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 82.scale)
        ])
        
        NSLayoutConstraint.activate([
            importButton.widthAnchor.constraint(equalToConstant: 90.scale),
            importButton.heightAnchor.constraint(equalToConstant: 50.scale),
            importButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            importButton.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ITImportWithoutInstructionCell {
    func makeContainer() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Imported.ImportBackground.Small")
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
}
