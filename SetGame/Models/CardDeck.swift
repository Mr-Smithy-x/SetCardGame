//
//  CardDeck.swift
//  CardGame
//
//  Created by Charlton Smith on 10/26/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation

class CardDeck {
    
    private(set) var cards = [Card]()
    private var numberOfCardsToMatch: Int = 2
    
    func refreshDeck(concentrationCards: [Card]) {
        self.cards += concentrationCards
        self.cards.shuffle()
    }
    
    init(numberOfCardsToMatch: Int){
        self.numberOfCardsToMatch = numberOfCardsToMatch
        initCards()
    }
    
    private func initCards(){
        self.cards.removeAll()
        for _ in 0..<20 {
            let card = Card()
            for _ in 0..<numberOfCardsToMatch {
                cards.append(card)
            }
        }
        cards.shuffle()
    }
    
    
    func replaceCard(cards: [Card]) -> [Card]{
        var newCards = cards
        for i in newCards.indices {
            if(newCards[i].isMatched){
                if let card = dealCard(){
                    newCards[i] = card
                }else{
                    newCards[i].isDead = true
                }
            }
        }
        return newCards;
    }
    
    func setNumberOfMatch(match: Int){
        self.numberOfCardsToMatch = match
        initCards()
    }
    
    func dealCard() -> Card? {
        return cards.popLast()
    }
    
    func count() -> Int {
        cards.count
    }
    
    func isEmpty() -> Bool {
        return cards.isEmpty
    }
    
}
