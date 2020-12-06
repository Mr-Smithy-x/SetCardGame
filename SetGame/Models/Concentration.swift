//
//  Concentration.swift
//  CardGame
//
//  Created by Charlton Smith on 9/3/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation

class Concentration {
    
    private var deck: CardDeck
    private var onCardRefresh: OnGameListener
    private var numberOfCardsToMatch: Int
    private(set) var cards: [Card] = [Card]()
    private(set) var flipCount: Int = 0
    private(set) var scoreCount: Int = 0
    private var isEmpty: Bool {
        get {
            return deck.isEmpty() && cards.completedMatched
        }
    }
    
    
    public static let themes  = [
           "Candy": "👻🎃🍬🍭🍫🍪🍏🍗🌭🥩🥖🥯🍅🍇🍋🍝🍥🍰🍶🍙",
           "Sports": "⚽️🏀🏈🥎🎱⚾️🎾🏐🏉🥏🎱🪀🏓🏸🏒🏑🥍🏏🥅⛳️",
           "Animals": "🦢🦧🦜🦘🦓🦙🦈🐋🐳🐬🐟🐠🐡🦀🦞🦐🦑🐙🦕🦖",
           "Faces": "🤩🤭🥰🥱🥳🤓🤯🥶🥵😠😏😍🤣🙃🙂😱🤫😨😰😥",
           "Tech": "📱💻🖥🖨☎️⌚️🖲🕹💽💾⏱📡⏳⌛️🕰⏰💡🧰🔩⚖️🔋",
           "Flags": "🇦🇹🇧🇸🇧🇼🇧🇫🇹🇩🇨🇽🇰🇾🇧🇬🇯🇲🇱🇷🇯🇵🇦🇺🏴‍☠️🇨🇮🇨🇬🇩🇰🇬🇫🇪🇺🇬🇾🇮🇩"
    ]
    
    
    init(numberOfCardsToMatch: Int = 2, onCardRefresh: OnGameListener){
        if numberOfCardsToMatch < 2 || numberOfCardsToMatch > 3 {
            //throw error
        }
        self.onCardRefresh = onCardRefresh
        self.numberOfCardsToMatch = numberOfCardsToMatch
        self.deck = CardDeck(numberOfCardsToMatch: numberOfCardsToMatch)
        self.initGame(numberOfCardsToMatch: numberOfCardsToMatch)
    }
    
    private func initGame(numberOfCardsToMatch: Int) -> Void {
        self.numberOfCardsToMatch = numberOfCardsToMatch
        deck.setNumberOfMatch(match: numberOfCardsToMatch)
        cards.removeAll()
        dealCards()
        verifyDeck()
    }
    
    func replaceCard(){
        self.cards = deck.replaceCard(cards: self.cards)
        verifyDeck()
    }
    
    func hasReplacements() {
        
    }
    
    
    
    func verifyDeck(){
        if(isEmpty){
            completed()
        }else if(self.cards.hasMatch(level: numberOfCardsToMatch)){
            print("Verified to atleast 1 match")
        }else{
            while !self.cards.hasMatch(level: numberOfCardsToMatch) {
                refreshDeck() //Refresh deck until match is found
            }
        }
    }
    
    func completed(){
        for i in self.cards.indices {
            self.cards[i].isFaceUp = false
        }
        self.onCardRefresh.onCompleted()
    }
    
    func dealCards(){
        if !deck.isEmpty() {
            let size = 20
            let cardCount = cards.count;
            if cards.count != size {
                for _ in cardCount..<size{
                    if let card = deck.dealCard() {
                        cards.append(card)
                    }
                }
            }
        } else{
            onCardRefresh.onCompleted()
        }

    }
    
    
    func chooseCard(at index: Int) -> Bool {
        if cards.isEmpty {
            return false
        }
        if(!cards[index].isFaceUp && cards[index].isMatched){
            return false;
        }
        flipCount += 1
        //Verify functions checks if the card has the same identifier
        //If not then it should facedown pickup where it left off started with
        //the newly failed match card
        if(!cards.verifyCard(card: cards[index])){
            cards.faceDown() //facedown all cards if no match
            scoreCount -= 1
            onCardRefresh.onScoreBoardUpdate(flip: flipCount, score: scoreCount)
            cards[index].isFaceUp = true //if not matched show card up regardless as a new card being clicked
            return false
        }
        
        cards[index].isFaceUp = true //if matched or no matched show card up regardless
        if(cards.facedUp.count == numberOfCardsToMatch){
            //we can assume that all $[numberOfCardsToMatch] cards are identical and faced up
            //thanks to the verify card function
            scoreCount += 10
            onCardRefresh.onScoreBoardUpdate(flip: flipCount, score: scoreCount)
            return cards.match()
        }
        return false
    }
    
    
    func reset(numberOfCardsToMatch: Int = 2) -> Void {
        self.onCardRefresh.onReset()
        flipCount = 0
        scoreCount = 0
        onCardRefresh.onScoreBoardUpdate(flip: flipCount, score: scoreCount)
        initGame(numberOfCardsToMatch: numberOfCardsToMatch)
        for i in cards.indices {
            cards[i].isFaceUp = false
            cards[i].isMatched = false
        }
        cards.shuffle()
    }
    
    func refreshDeck() -> Void {
        self.deck.refreshDeck(concentrationCards: self.cards)
        self.cards.removeAll()
        self.dealCards()
    }
    
}
