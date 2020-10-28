//
//  SetCardDeck.swift
//  SetGame
//
//  Created by Charlton Smith on 9/21/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation

struct SetCardDeck {
    
    var deck = [SetCard]()
    
    func count() -> Int {
        return deck.count
    }
    
    mutating func reset() {
        deck.removeAll()
        initialize()
    }
    
    mutating func addCardBack(card: SetCard){
        self.deck.append(card)
    }
    
    mutating func shuffle(){
        self.deck.shuffle()
    }
    
    
    
    mutating func dealCard() -> SetCard? {
        if self.isEmpty() {
            return nil
        } else {
            return deck.remove(at: 0)
        }
    }
    
    func isEmpty() -> Bool {
        return count() == 0
    }
    
    mutating func initialize(){
        for color in SetCard.Colors.all {
            for shape in SetCard.Shapes.all {
                for shade in SetCard.Shades.all {
                    for count in 1...3 {
                        deck += [SetCard(shape: shape, shade: shade, color: color, count: count)]
                    }
                }
            }
        }
        
        for _ in 1...10 {
            for index in deck.indices {
                let randomIndex = Int(arc4random_uniform(UInt32(index)))
                let card = deck.remove(at: randomIndex)
                deck.append(card)
            }
        }
    }
    
    init() {
        self.initialize()
    }
    
}
