//
//  SetGame.swift
//  SetGame
//
//  Created by Charlton Smith on 9/21/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation
import UIKit

class SetCard: Equatable {
    var shape: Shapes
    var shade: Shades
    var color: Colors
    var count: Int
    
    var isSelected = false
    var isMatched = false
    var isMisMatch = false
    
    func contents() -> String {
        var shape: String
        switch self.shape {
        case .squiggle:
            shape = "▲"
        case .oval:
            shape = "●"
        case .diamond:
            shape = "◼︎"
        }
        
        var content = ""
        for _ in 1...self.count {
            content += shape
        }
        return content
    }
    
    public enum Shapes: Int {
        case squiggle
        case oval
        case diamond
        static var all = [Shapes.squiggle, .oval, .diamond]
    }
    
    public enum Shades: Int {
        case outlined
        case striped
        case filled
        static var all = [Shades.outlined, .striped, .filled]
    }
    
    public enum Colors: Int {
        case green
        case red
        case purple
        static var all = [Colors.green, .red, .purple]
    }
    
    init(shape: Shapes, shade: Shades, color: Colors, count: Int){
        self.shape = shape
        self.shade = shade
        self.color = color
        self.count = count
    }
    
    func attributedContents() -> NSAttributedString {
        var strokeColor: UIColor
        
        switch self.color {
            case .green: strokeColor =  UIColor.green
            case .red: strokeColor = UIColor.red
            case .purple: strokeColor = UIColor.purple
        }
        var foregroundColor = strokeColor
        switch self.shade {
            case.outlined: foregroundColor = foregroundColor.withAlphaComponent(0.0)
            case.striped: foregroundColor = foregroundColor.withAlphaComponent(0.3)
            case .filled: foregroundColor = foregroundColor.withAlphaComponent(1.0)
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: foregroundColor,
            .strokeColor: strokeColor,
            .strokeWidth: -5.0
        ]
        return NSAttributedString(string: self.contents(), attributes: attributes)
    }
    
}

extension SetCard {
    static func == (lhs: SetCard, rhs: SetCard) -> Bool {
        return (lhs.shape == rhs.shape) && (lhs.shade == rhs.shade) && (lhs.color == rhs.color) && (lhs.count == rhs.count)
    }
}
