//
//  PlayingCardView.swift
//  SetGame
//
//  Created by Charlton Smith on 9/29/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SetCardView: UIView {
    
    
    
    private(set) var card = SetCard(shape: SetCard.Shapes.oval, shade: SetCard.Shades.outlined, color: SetCard.Colors.red, count: 3) {
        didSet {
            self.shade = card.shade.rawValue
            self.shape = card.shape.rawValue
            self.color = card.color.rawValue
            self.count = card.count
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    
    
    private lazy var cardLabel = createLabel()
    
    
    var isSelected: Bool = false {
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var isCheating: Bool = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private var cardString: NSAttributedString {
        return card.attributedContents()
    }
    
    @IBInspectable var isVisible: Bool = true {
        didSet {
            self.isHidden = !isVisible
            setNeedsDisplay()
            setNeedsLayout()
            
        }
    }
    
    @IBInspectable var shape: Int = 0 {
        didSet {
            card.shape = SetCard.Shapes.init(rawValue: shape % 3) ?? SetCard.Shapes.oval
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    public func setCard(card: SetCard?){
        if let c = card {
            self.isVisible = true
            self.card = c;
        }
    }
    
    @IBInspectable var shade: Int = 0 {
        didSet {
            card.shade = SetCard.Shades.init(rawValue: shade % 3) ?? SetCard.Shades.outlined
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var color: Int = 0 {
        didSet {
            card.color = SetCard.Colors.init(rawValue: color % 3) ?? SetCard.Colors.green
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var count: Int = 3 {
        didSet {
            let real_count = count % 4;
            card.count = real_count == 0 ? real_count + 1 : real_count
        }
    }
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    
    override func draw(_ rect: CGRect) {
        if(self.isVisible) {
            let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)

            roundedRect.addClip()
            if(!self.isCheating){
                UIColor.white.setFill()
            }else{
                UIColor.darkGray.setFill()
            }
            roundedRect.fill()
            
            if(isSelected){
                UIColor.lightGray.setFill()
                roundedRect.fill()
            }
            addSubview(cardLabel)
        }
        
    }
    
    private func centeredAttributedString(_ string: String,
                                          fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string,
                                  attributes: [.paragraphStyle: paragraphStyle,
                                               .font: font])
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLabel(cardLabel)
        cardLabel.frame.origin = bounds.origin.offsetBy(dx: self.bounds.midX/3, dy: self.bounds.midY/2)
        
    }
    
    private func configureLabel(_ label: UILabel) {
        label.attributedText = cardString
        label.frame.size = CGSize.zero
        label.sizeToFit()
    }
    
}


extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
}


