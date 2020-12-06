//
//  Array+Card.swift
//  CardGame
//
//  Created by Charlton Smith on 10/26/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation


extension Array where Element == Card {
    
    func hasMatch(level: Int) -> Bool {
        for i in 0...count-1 {
            for j in 0...count-1 {
                if level == 2 {
                    if i != j {
                        if(self[i] == self[j]){
                            print("Has Match 2")
                            return true
                        }
                    }
                }else if level == 3{
                    for k in 0...count-1 {
                        if i != j && k != j  && i != k {
                            if(self[i] == self[j] && self[j] == self[k]){
                                print("Has Match 3")
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    var completedMatched: Bool {
        return self.filter { (card) -> Bool in
            return !card.isMatched
        }.count == 0
    }
    
    mutating func match() -> Bool {
        if(self.facedUp.count > 1){
            let card = self.facedUp[0];
            if(verifyCard(card: card)){
                for i in 0..<self.count {
                    if(facedUp.contains(self[i]) && !self[i].isMatched){
                        self[i].isMatched = true
                    }
                }
                return true;
            }else{
                
                self.faceDown()
                return false
            }
        }else{
            return false;
        }
    }
    
    func verifyCard(card: Card) -> Bool {
        if self.facedUp.count == 0 {
            return true
        }
        let cards = self.facedUp.filter { (check) -> Bool in
            check.identifier == card.identifier
        }
        return cards.count == self.facedUp.count
    }
    
    mutating func faceDown(){
        for i in self.indices {
            self[i].isFaceUp = false
        }
    }
    
    var facedUp: [Card] {
        return self.filter { (card) -> Bool in card.isFaceUp}
    }
}
