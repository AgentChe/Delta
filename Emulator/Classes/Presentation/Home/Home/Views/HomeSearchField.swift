//
//  HomeSearchField.swift
//  Delta
//
//  Created by Андрей Чернышев on 16.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeSearchField: UIView {
    enum Mode {
        case normal, cancelable
    }
    
    lazy var iconView = makeIconView()
    lazy var textField = makeTextField()
    lazy var clearButton = makeClearButton()
    lazy var cancelButton = makeCancelButton()
    
    private lazy var textFieldTrailingConstraint = NSLayoutConstraint()
    private lazy var cancelButtonHorizontalConstraint = NSLayoutConstraint()
    
    private lazy var didCancelTrigger = PublishRelay<Void>()
    private lazy var didFocusTrigger = PublishRelay<Void>()
    private lazy var didSearchTrigger = PublishRelay<String>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        textFieldEditing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeSearchField {
    func transform(to mode: Mode, withLayout: Bool) {
        textFieldTrailingConstraint.isActive = false
        
        NSLayoutConstraint.deactivate([
            textFieldTrailingConstraint,
            cancelButtonHorizontalConstraint
        ])
        
        switch mode {
        case .normal:
            textFieldTrailingConstraint = textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
            cancelButtonHorizontalConstraint = cancelButton.leadingAnchor.constraint(equalTo: trailingAnchor)
        case .cancelable:
            textFieldTrailingConstraint = textField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8.scale)
            cancelButtonHorizontalConstraint = cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        }
        
        NSLayoutConstraint.activate([
            textFieldTrailingConstraint,
            cancelButtonHorizontalConstraint
        ])
        
        if withLayout {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        }
    }
    
    var cancel: Signal<Void> {
        didCancelTrigger.asSignal()
    }
    
    var focus: Signal<Void> {
        didFocusTrigger.asSignal()
    }
    
    var search: Signal<String> {
        didSearchTrigger.asSignal()
    }
}

// MARK: UITextFieldDelegate
extension HomeSearchField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didFocusTrigger.accept(Void())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didSearchTrigger.accept(textField.text ?? "")
        return true
    }
}

// MARK: Make constraints
private extension HomeSearchField {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func clearTapped() {
        textField.text = ""
        textFieldEditing()
    }
    
    @objc
    func textFieldEditing() {
        let empty = (textField.text ?? "").isEmpty
        
        clearButton.isHidden = empty
    }
    
    @objc
    func cancelTapped() {
        textField.resignFirstResponder()
        
        clearTapped()
        
        didCancelTrigger.accept(Void())
    }
}

// MARK: Make constraints
private extension HomeSearchField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 8.scale),
            iconView.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
        
        textFieldTrailingConstraint = textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textFieldTrailingConstraint,
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 24.scale),
            clearButton.heightAnchor.constraint(equalToConstant: 24.scale),
            clearButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -8.scale),
            clearButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
        
        cancelButtonHorizontalConstraint = cancelButton.leadingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([
            cancelButtonHorizontalConstraint,
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeSearchField {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Home.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.4))
            .font(Fonts.Joystix.monospace(size: 15.scale))
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 15.scale))
        
        let view = PaddingTextField()
        view.attributedPlaceholder = "Home.Search".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 14.scale, horizontal: 40.scale)
        view.defaultTextAttributes = attrs.dictionary
        view.returnKeyType = .search
        view.delegate = self
        view.backgroundColor = UIColor(integralRed: 118, green: 118, blue: 128, alpha: 0.2)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        addSubview(view)
        return view
    }
    
    func makeClearButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Home.Clear"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(view)
        view.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        return view
    }
    
    func makeCancelButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Joystix.monospace(size: 15.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Cancel".localized.uppercased().attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        view.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
