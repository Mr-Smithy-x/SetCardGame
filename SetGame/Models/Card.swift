//
//  Card.swift
//  CardGame
//
//  Created by Charlton Smith on 9/3/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int {
        return identifier
    }
 
    var identifier: Int
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var isDead = false;
 
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(identifier: Int) {
        self.identifier = identifier
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
