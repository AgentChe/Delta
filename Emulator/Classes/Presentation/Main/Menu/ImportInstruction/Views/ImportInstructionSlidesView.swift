//
//  ImportInstructionSlidesView.swift
//  Delta
//
//  Created by Андрей Чернышев on 15.07.2024.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import UIKit

final class ImportInstructionSlidesView: UIView {
    lazy var slide1View = makeSlideView(.exploring)
    lazy var slide2View = makeSlideView(.searching)
    lazy var slide3View = makeSlideView(.importing)
    
    private lazy var slide1LeadingConstraint = NSLayoutConstraint()
    private lazy var slide2LeadingConstraint = NSLayoutConstraint()
    private lazy var slide3LeadingConstraint = NSLayoutConstraint()
    
    private lazy var slide = ImportInstructionSlideView.Slide.exploring
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ImportInstructionSlidesView {
    func previous() {
        guard let toSlide = slide.previous else { return }
        
        slide = toSlide
        
        move(direction: 1)
    }
    
    func next() {
        guard let toSlide = slide.next else { return }
        
        slide = toSlide
        
        move(direction: -1)
    }
    
    func hasNext() -> Bool {
        slide.next != nil
    }
    
    func current() -> ImportInstructionSlideView.Slide {
        slide
    }
}

// MARK: Private
private extension ImportInstructionSlidesView {
    func move(direction: CGFloat) {
        NSLayoutConstraint.deactivate([
            slide1LeadingConstraint,
            slide2LeadingConstraint,
            slide3LeadingConstraint
        ])
        
        slide1LeadingConstraint.constant += 390.scale * direction
        slide2LeadingConstraint.constant += 390.scale * direction
        slide3LeadingConstraint.constant += 390.scale * direction
        
        NSLayoutConstraint.activate([
            slide1LeadingConstraint,
            slide2LeadingConstraint,
            slide3LeadingConstraint
        ])
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }
}

// MARK: Make constraints
private extension ImportInstructionSlidesView {
    func makeConstraints() {
        slide1LeadingConstraint = slide1View.leadingAnchor.constraint(equalTo: leadingAnchor)
        NSLayoutConstraint.activate([
            slide1LeadingConstraint,
            slide1View.widthAnchor.constraint(equalToConstant: 390.scale),
            slide1View.topAnchor.constraint(equalTo: topAnchor),
            slide1View.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        slide2LeadingConstraint = slide2View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 390.scale)
        NSLayoutConstraint.activate([
            slide2LeadingConstraint,
            slide2View.widthAnchor.constraint(equalToConstant: 390.scale),
            slide2View.topAnchor.constraint(equalTo: topAnchor),
            slide2View.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        slide3LeadingConstraint = slide3View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 780.scale)
        NSLayoutConstraint.activate([
            slide3LeadingConstraint,
            slide3View.widthAnchor.constraint(equalToConstant: 390.scale),
            slide3View.topAnchor.constraint(equalTo: topAnchor),
            slide3View.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ImportInstructionSlidesView {
    func makeSlideView(_ slide: ImportInstructionSlideView.Slide) -> UIView {
        let view = ImportInstructionSlideView(slide: slide)
        view.backgroundColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension ImportInstructionSlideView.Slide {
    var previous: ImportInstructionSlideView.Slide? {
        switch self {
        case .exploring:
            return nil
        case .searching:
            return .exploring
        case .importing:
            return .searching
        }
    }
    
    var next: ImportInstructionSlideView.Slide? {
        switch self {
        case .exploring:
            return .searching
        case .searching:
            return .importing
        case .importing:
            return nil
        }
    }
}
