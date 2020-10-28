//
//  SetCardEnhancedView.swift
//  SetGame
//
//  Created by Charlton Smith on 10/7/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SetCardEnhancedView: SetCardView {
    
    
    @IBInspectable var isMisMatched = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    @IBInspectable var isMatched = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        roundedRect.addClip()
        roundedRect.lineWidth = 5.0
        
        if isSelected {
            UIColor.black.setStroke()
        } else if isMatched {
            UIColor.green.setStroke()
        }else if(isMisMatched) {
            UIColor.red.setStroke()
        }else if(isCheating) {
            UIColor.orange.setStroke()
        }else{
            UIColor.white.setStroke()
        }
        
        UIColor.white.setFill()
        roundedRect.fill()
        roundedRect.stroke()
        let path = UIBezierPath()
        switch card.shape {
            case .diamond:
                path.append(drawDiamond())
            case .oval:
                path.append(drawOval())
            case .squiggle:
                path.append(drawSquiggle())
        }
        showPath(path)
    }
    
    private func showPath(_ path: UIBezierPath) {
        var path = replicatePath(path)
        colorForPath.setStroke()
        path = shadePath(path)
        path.lineWidth = 2.0
        path.fill()
        path.stroke()
    }
    
    private func shadePath(_ path: UIBezierPath) -> UIBezierPath {
        let shadedPath = UIBezierPath()
        shadedPath.append(path)
        switch self.card.shade {
            case .filled:
                colorForPath.setFill()
            case .striped:
                UIColor.clear.setFill()
                shadedPath.addClip()
                var start   = CGPoint(x: 0.0, y: 0.0)
                var end     = CGPoint(x: self.bounds.size.width, y: 0.0)
                let dy: CGFloat = self.bounds.size.height / 10
                while start.y <= self.bounds.size.height {
                    shadedPath.move(to: start)
                    shadedPath.addLine(to: end)
                    start.y += dy;
                    end.y += dy;
                }
            case .outlined:
                UIColor.clear.setFill()
        }
        return shadedPath
    }
    
    private var colorForFill: UIColor {
        switch card.color {
            case .red:
                return UIColor.red
            case .purple:
                return UIColor.purple
            case .green:
                return UIColor.green
        }
    }
    
    private var colorForPath: UIColor {
        switch card.color {
            case .red:
                return UIColor.red
            case .purple:
                return UIColor.purple
            case .green:
                return UIColor.green
        }
    }
    
    private func replicatePath(_ path: UIBezierPath) -> UIBezierPath {
        let replicated = UIBezierPath()
        if self.card.count == 1 {
            replicated.append(path)
        } else if self.card.count == 2 {
            let leftPath = UIBezierPath()
            leftPath.append(path)
            let leftTransform = CGAffineTransform(translationX: leftTwoPathTranslation.x, y: leftTwoPathTranslation.y)
            leftPath.apply(leftTransform)
            let rightPath = UIBezierPath()
            rightPath.append(path)
            let rightTransform = CGAffineTransform(translationX: rightTwoPathTranslation.x, y: rightTwoPathTranslation.y)
            rightPath.apply(rightTransform)
            replicated.append(leftPath)
            replicated.append(rightPath)
        } else if self.card.count == 3 {
            let leftPath = UIBezierPath()
            leftPath.append(path)
            let leftTransform = CGAffineTransform(translationX: leftThreePathTranslation.x, y: leftThreePathTranslation.y)
            leftPath.apply(leftTransform)
            let rightPath = UIBezierPath()
            rightPath.append(path)
            let rightTransform = CGAffineTransform(translationX: rightThreePathTranslation.x, y: rightThreePathTranslation.y)
            rightPath.apply(rightTransform)
            replicated.append(leftPath)
            replicated.append(path)
            replicated.append(rightPath)
        }
        return replicated
    }
    
    private func drawSquiggle() -> UIBezierPath {
        let squiggle = UIBezierPath()
        squiggle.move(to: squiggleBottomLeft)
        squiggle.addCurve(to: squiggleTopLeft, controlPoint1: squiggleControlLeftOne, controlPoint2:
            squiggleControlLeftTwo)
        squiggle.addArc(withCenter: squiggleTopCenter,
                        radius: squiggleTopRadius,
                        startAngle: CGFloat.pi,
                        endAngle: 0,
                        clockwise: true)
        squiggle.addCurve(to: squiggleBottomRight,
                          controlPoint1: squiggleControlRightOne,
                          controlPoint2: squiggleControlRightTwo)
        squiggle.addArc(withCenter: squiggleBottomCenter,
                        radius: squiggleBottomRadius,
                        startAngle: 0,
                        endAngle: CGFloat.pi,
                        clockwise: true)
        
        squiggle.close()
        return squiggle
    }
    
    private func drawOval() -> UIBezierPath {
        let rect = CGRect(x: ovalPositionX, y: ovalPositionY, width: ovalWidth, height: ovalHeight)
        let oval = UIBezierPath(ovalIn: rect)
        return oval;
    }
    
    private func drawDiamond() -> UIBezierPath {
        let diamond = UIBezierPath()
        diamond.move(to: diamondOrigin)
        diamond.addLine(to: diamondLeft)
        diamond.addLine(to: diamondTop)
        diamond.addLine(to: diamondRight)
        diamond.addLine(to: diamondBottom)
        diamond.close()
        return diamond
    }
    
}

extension SetCardEnhancedView {
    
    private struct DiamondRatios {
        static let offsetPercentage: CGFloat = 0.20
        static let widthPercentage: CGFloat = 0.45
    }
    
    
    private var diamondWidth: CGFloat {
        return self.bounds.size.width * OvalRatios.widthPercentage / 2.0
    }
    
    private var diamondHeight: CGFloat {
        return self.bounds.size.height * OvalRatios.widthPercentage / 2.0
    }
    
    private var diamondOrigin: CGPoint {
        return CGPoint(x: self.bounds.size.width / 2 - diamondWidth / 2, y: self.bounds.size.height / 2)
    }
    
    private var diamondLeft: CGPoint {
        return CGPoint(x:diamondOrigin.x, y: diamondOrigin.y)
    }
    
    private var diamondTop: CGPoint {
        return CGPoint(x: diamondOrigin.x + diamondWidth/2, y: diamondOrigin.y - diamondHeight)
    }
    
    private var diamondRight: CGPoint {
        return CGPoint(x: diamondOrigin.x + diamondWidth, y: diamondOrigin.y)
    }
    
    private var diamondBottom: CGPoint {
        return CGPoint(x: diamondOrigin.x + diamondWidth / 2, y: diamondOrigin.y + diamondHeight)
    }
    
    
}

extension SetCardEnhancedView {
    
    private struct OvalRatios {
        static let offsetPercentage: CGFloat = 0.20
        static let widthPercentage: CGFloat = 0.45
    }
    
    private var ovalWidth: CGFloat {
        return (self.bounds.size.width * OvalRatios.widthPercentage / 2.0)
    }
    
    private var ovalHeight: CGFloat {
           return (self.bounds.size.width * OvalRatios.widthPercentage / 2.0)
       }
    
    private var ovalPositionX: CGFloat {
        return self.bounds.size.width/2.0 - ovalWidth / 2
    }
    
    private var ovalPositionY: CGFloat {
        return self.bounds.size.height/2.0 - ovalHeight / 2
    }
    
}

extension SetCardEnhancedView {
    
    private struct SquiggleRatios {
        static let offsetPercentage: CGFloat = 0.20
        static let widthPercentage: CGFloat = 0.15
        static let controlHorizontalOffsetPercentage: CGFloat = 0.10
        static let controlVerticalOffsetPercentage: CGFloat = 0.40
    }
    
    private var squiggleTopLeft: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 - (self.bounds.size.width * SquiggleRatios.widthPercentage / 2.0), y: self.bounds.size.height * SquiggleRatios.offsetPercentage)
    }
    
    private var squiggleBottomLeft: CGPoint {
        return CGPoint(x: self.bounds.size.width / 2.0 - (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0), y: self.bounds.size.height - (self.bounds.size.height * SquiggleRatios.offsetPercentage))
    }
    
    private var squiggleControlLeftOne: CGPoint {
        let topLeft = squiggleTopLeft
        return CGPoint(x: topLeft.x + (self.bounds.size.width * SquiggleRatios.controlHorizontalOffsetPercentage), y: self.bounds.size.height * SquiggleRatios.controlVerticalOffsetPercentage)
    }
    
    private var squiggleControlLeftTwo: CGPoint {
        let topLeft = squiggleTopLeft
        return CGPoint(x: topLeft.x - (self.bounds.size.width * SquiggleRatios.controlHorizontalOffsetPercentage), y: self.bounds.size.height - (self.bounds.size.height * SquiggleRatios.controlVerticalOffsetPercentage))
    }
    
    
    private var squiggleTopRight: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 + (self.bounds.size.width * SquiggleRatios.widthPercentage / 2.0), y: self.bounds.size.height * SquiggleRatios.offsetPercentage)
    }
    
    private var squiggleBottomRight: CGPoint {
        return CGPoint(x: self.bounds.size.width / 2.0 + (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0), y: self.bounds.size.height - (self.bounds.size.height * SquiggleRatios.offsetPercentage))
    }
    
    
    private var squiggleControlRightOne: CGPoint {
        let controlLeftTwo = squiggleControlLeftTwo
        return CGPoint(x: controlLeftTwo.x + (self.bounds.size.width * SquiggleRatios.widthPercentage), y:
            controlLeftTwo.y)
    }
    
    private var squiggleControlRightTwo: CGPoint {
        let controlLeftOne = squiggleControlLeftOne
        return CGPoint(x: controlLeftOne.x + (self.bounds.size.width * SquiggleRatios.widthPercentage), y: controlLeftOne.y)
    }
    
    private var squiggleTopCenter: CGPoint {
        let topLeft = squiggleTopLeft
        let topRight = squiggleTopRight
        return CGPoint(x: (topLeft.x + topRight.x) / 2.0, y: topLeft.y)
    }
    
    private var squiggleBottomCenter: CGPoint {
        let bottomLeft = squiggleBottomLeft
        let bottomRight = squiggleBottomRight
        return CGPoint(x: (bottomLeft.x + bottomRight.x) / 2.0, y: bottomLeft.y)
        
    }
    
    private var squiggleTopRadius: CGFloat {
        let topLeft = squiggleTopLeft
        let topRight = squiggleTopRight
        return (topRight.x - topLeft.x) / 2.0
    }
    
    private var squiggleBottomRadius: CGFloat{
        let bottomLeft = squiggleBottomLeft
        let bottomRight = squiggleBottomRight
        return (bottomRight.x - bottomLeft.x) / 2.0
    }
    
}

extension SetCardEnhancedView {
    
    private var leftTwoPathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * -0.15, y: 0.0)
    }
    private var rightTwoPathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * 0.15, y: 0.0)
    }
    
    private var leftThreePathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * -0.25, y: 0.0)
    }
    
    private var rightThreePathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * 0.25, y: 0.0)
    }
    
    
    
}
