//
//  Card+Extension.swift
//  CardGame
//
//  Created by Charlton Smith on 10/26/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation


extension Card {
    
    func hash(into hasher: inout Hasher){
        hasher.combine(identifier)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
}
