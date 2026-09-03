//
//  HomeGameCategoriesView.swift
//  Delta
//
//  Created by Андрей Чернышев on 17.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeGameCategoriesView: UIView {
    lazy var leftButton = makeNavigationButton(iconName: "Home.ArrowL")
    lazy var label = makeLabel()
    lazy var rightButton = makeNavigationButton(iconName: "Home.ArrowR")
    
    private lazy var shapeLayer = CAShapeLayer()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Joystix.monospace(size: 16.scale))
        .textAlignment(.center)
    
    private var categories = [LibraryCategory]()
    
    private lazy var current = PublishRelay<LibraryCategory>()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath()
        
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: bounds.width, y: 0)
        let bottomRight = CGPoint(x: bounds.width, y: bounds.height)
        let bottomLeft = CGPoint(x: 0, y: bounds.height)

        path.move(to: CGPoint(x: topLeft.x, y: topLeft.y + 4.scale))
        path.addArc(withCenter: CGPoint(x: topLeft.x + 4.scale, y: topLeft.y + 4.scale), radius: 4.scale, startAngle: CGFloat.pi, endAngle: 3 * CGFloat.pi / 2, clockwise: true)

        path.addLine(to: CGPoint(x: topRight.x - 4.scale, y: topRight.y))
        path.addArc(withCenter: CGPoint(x: topRight.x - 4.scale, y: topRight.y + 4.scale), radius: 4.scale, startAngle: 3 * CGFloat.pi / 2, endAngle: 0, clockwise: true)

        path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - 24.scale))
        path.addArc(withCenter: CGPoint(x: bottomRight.x - 24.scale, y: bottomRight.y - 24.scale), radius: 24.scale, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)

        path.addLine(to: CGPoint(x: bottomLeft.x + 24.scale, y: bottomLeft.y))
        path.addArc(withCenter: CGPoint(x: bottomLeft.x + 24.scale, y: bottomLeft.y - 24.scale), radius: 24.scale, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)

        path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + 4.scale))

        path.close()
        
        shapeLayer.path = path.cgPath
        shapeLayer.shadowPath = path.cgPath
    }
}

// MARK: Public
extension HomeGameCategoriesView {
    func setup(categories: [LibraryCategory]) {
        self.categories = categories
        
        if let first = categories.first {
            setup(category: first)
        }
    }
    
    var category: Signal<LibraryCategory> {
        current
            .compactMap { $0 }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension HomeGameCategoriesView {
    func initialize() {
        shapeLayer.fillColor = Appearance.main200.cgColor
        shapeLayer.shadowColor = Appearance.main300.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 8.scale)
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowRadius = 0
        layer.insertSublayer(shapeLayer, at: 0)
        
        category
            .emit(to: Binder(self) { base, category in
                base.label.attributedText = category.name.attributed(with: base.attrs)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                leftButton.rx.tap.map { -1 },
                rightButton.rx.tap.map { 1 }
            )
            .withLatestFrom(current) { ($0, $1) }
            .compactMap { [weak self] direction, current -> LibraryCategory? in
                guard let self, let index = categories.firstIndex(where: { $0.name == current.name }) else {
                    return nil
                }
                
                let nextIndex = index + direction
                
                if let category = categories[safe: nextIndex] {
                    return category
                }
                
                if direction == -1 {
                    return categories.last
                } else {
                    return categories.first
                }
            }
            .bind(to: current)
            .disposed(by: disposeBag)
    }
    
    func setup(category: LibraryCategory) {
        current.accept(category)
    }
}

// MARK: Make constraints
private extension HomeGameCategoriesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalToConstant: 24.scale),
            leftButton.heightAnchor.constraint(equalToConstant: 24.scale),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightButton.widthAnchor.constraint(equalToConstant: 24.scale),
            rightButton.heightAnchor.constraint(equalToConstant: 24.scale),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeGameCategoriesView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationButton(iconName: String) -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: iconName), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
