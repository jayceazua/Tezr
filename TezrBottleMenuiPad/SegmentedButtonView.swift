//
//  SegmentedButtonView.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/22/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit

@objc protocol SegmentedButtonViewDelegate: class {
    func segmentedButton(_ segementedButtonView: SegmentedButtonView, didPressButtonAt index: Int)
}

@IBDesignable
class SegmentedButtonView: UIView {
    
    @IBInspectable var fontSize: CGFloat {
        return max(selectedButtonStyle.fontSize, unselectedButtonStyle.fontSize)
    }
    
    @IBInspectable var verticalPadding: CGFloat = 8.0
    
    @IBOutlet weak var delegate: SegmentedButtonViewDelegate?
    
    var buttonTitles = [String]() {
        didSet {
            reloadButtons()
        }
    }
    
    var selectedButtonIndex = 0 {
        willSet {
            guard newValue < self.buttons.count else {
                return assertionFailure("out of bounds for selected button index \(newValue)")
            }
            
            let newSelectedButton = self.buttons[newValue]
            self.selectedButton = newSelectedButton
        }
        didSet {
            updateScrollView()
        }
    }
    
    private(set) var selectedButton: UIButton? {
        willSet {
            if let button = selectedButton {
                deselect(button: button)
            }
            if let newButton = newValue {
                select(button: newButton)
            }
        }
    }
    
    struct SelectedStyle {
        let fontSize: CGFloat
        let textColor: UIColor
    }
    
    var selectedButtonStyle = SelectedStyle(fontSize: 48, textColor: .white)
    
    var unselectedButtonStyle = SelectedStyle(fontSize: 28.0, textColor: UIColor.white.withAlphaComponent(0.8))
    
    private lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.isScrollEnabled = true
        sc.showsHorizontalScrollIndicator = false
        sc.alwaysBounceHorizontal = true
        
        return sc
    }()
    
    private lazy var horzStackView: UIStackView = {
        let stackView = UIStackView(
            axis: .horizontal,
            distribution: .fill,
            alignment: .center,
            spacing: 8.0
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var buttons = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initLayout()
    }

    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    func reloadButtons() {
        
        self.horzStackView.removeSubviews()
        self.buttons.removeAll()
        
        for (index, aButtonTitle) in self.buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleWithoutAnimation(aButtonTitle, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
            button.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
            
            if index == selectedButtonIndex {
                select(button: button)
                selectedButton = button
            } else {
                deselect(button: button)
            }
            
            self.horzStackView.addArrangedSubview(button)
            self.buttons.append(button)
        }
    }
    
    private func updateScrollView() {
        guard let buttonFrameCenter = self.selectedButton?.center else {
            return
        }
        let scrollViewFrame = self.scrollView.bounds
        let newCenterOffset = CGPoint(
            x: buttonFrameCenter.x - scrollViewFrame.width / 2.0,
            y: 0
        )
        self.scrollView.setContentOffset(newCenterOffset, animated: true)
    }
    
    private func initLayout() {
        self.scrollView.addSubview(self.horzStackView)
        horzStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        horzStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: horzStackView.trailingAnchor).isActive = true
        horzStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        let widthConstraint = horzStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        widthConstraint.isActive = true
        horzStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        self.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func select(button: UIButton) {
        button.titleLabel!.font = UIFont.systemFont(ofSize: self.selectedButtonStyle.fontSize)
        button.tintColor = self.selectedButtonStyle.textColor
    }
    
    private func deselect(button: UIButton) {
        button.titleLabel!.font = UIFont.systemFont(ofSize: self.unselectedButtonStyle.fontSize)
        button.tintColor = self.unselectedButtonStyle.textColor
    }
    
    // MARK: - IBACTIONS
    
    @objc private func pressButton(_ button: UIButton) {
        self.selectedButtonIndex = button.tag
        self.selectedButton = button
        delegate?.segmentedButton(self, didPressButtonAt: button.tag)
    }
    
    // MARK: - LIFE CYCLE

}
