//
//  CardMatchHelper.swift
//  SetGame
//
//  Created by Charlton Smith on 10/4/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation

class CardMatchHelper {
    
    
    
    public static func isSet(cardOne: SetCard, cardTwo: SetCard, cardThree: SetCard) -> Bool {
        
        let numberMatch =
            ((cardOne.count == cardTwo.count) && (cardTwo.count == cardThree.count)) ||
                (cardOne.count != cardTwo.count && cardOne.count != cardThree.count && cardTwo.count != cardThree.count)
        
        if(!numberMatch){
            return false;
        }
        
        let colorMatch = ((cardOne.color == cardTwo.color) && (cardTwo.color == cardThree.color)) ||
            (cardOne.color != cardTwo.color && cardTwo.color != cardThree.color && cardOne.color != cardThree.color)
        
        if(!colorMatch) {
            return false;
        }
        
        let shadeMatch = ((cardOne.shade == cardTwo.shade) && (cardTwo.shade == cardThree.shade)) ||
        (cardOne.shade != cardTwo.shade && cardTwo.shade != cardThree.shade && cardOne.shade != cardThree.shade)
        
        if(!shadeMatch) {
            return false
        }
        
        let shapeMatch = ((cardOne.shape == cardTwo.shape) && (cardTwo.shape == cardThree.shape)) ||
               (cardOne.shape != cardTwo.shape && cardTwo.shape != cardThree.shape && cardOne.shape != cardThree.shape)
        
        if(!shapeMatch){
            return false;
        }
        return true;
    }
    
}
