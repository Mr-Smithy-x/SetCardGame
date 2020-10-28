//
//  SetCardGridContainerView.swift
//  SetGame
//
//  Created by Charlton Smith on 10/27/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SetCardGridContainerView: UIView {

    var timer = Timer()
    var countdown = 15;
    var timerProtocol: SetGameTimerProtocol? = nil
    @IBInspectable
    var rows: Int = 6 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var columns: Int = 3 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBInspectable
    var playing: Int = 2 {
        didSet {
            players[0] = 0
            players[1] = 0
            self.startNewGame()
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private var currentPlayer: Int = 1 {
        didSet {
            timerProtocol?.onTicked(player: currentPlayer)
        }
    }
    private var scoreCard: String = ""
    private var players: [Int: Int] = [Int:Int]()
    private var startTime: Int64 = 0
    private var lastMatchTime: Int64 = 0
    private var endTime: Int64 = 0
    private(set) var cardViews: [SetCardView] = [SetCardView]()
    private(set) var deck: SetCardDeck = SetCardDeck()
    
    
    private func getView(index: Int) -> SetCardView {
        return subviews[index] as! SetCardView
    }
    
    private func getView(row: Int, column: Int) -> SetCardView {
         return subviews[(row * columns) + column] as! SetCardView
     }
     
    ///Hints to the user that there are matches
    func peek(){
        if(cardViews.peek()){
            players[currentPlayer]? -= 10
        }else{
            gameOver()
        }
    }
    
    ///Adds card back to deck and replaces a card and reshuffle deck on each iteration to assure random cards
    func reshuffle(){
        for view in cardViews {
            let card = view.card
            view.isSelected = false
            view.isCheating = false
            deck.addCardBack(card: card)
            deck.shuffle()
            view.setCard(card: deck.dealCard())
        }
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    ///Adds a new row which then deals a new call via didSet observer + calling draw in the background
    func dealNewCards(){
        self.rows += 1
    }
    
    func startNewGame(){
        deck.reset()
        for card in cardViews {
            card.setCard(card: deck.dealCard())
        }
        rows = 4
        
        if timer.isValid {
            timer.invalidate()
        }
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func timerAction(){
        countdown-=1
        if countdown == 0 {
            currentPlayer = (currentPlayer + 1) % 2
            print("Current Player: \(currentPlayer)")
            countdown = 15
        }else{
            print("Current Countdown: \(countdown)")
        }
    }
    
    private func fixCardContraints(){
        for index in 0..<subviews.count {
            let row    = Int((index / columns))
            let column = index % columns
            //print("Grid Index = (Row: \(row), Column: \(column), Quik Maffs: \(row * columns), Index: \(indexi) or \(index)")
            if index <= subviews.count {
                let view = getView(row: row, column: column)
                let paddingX = (self.columnWidth - self.viewWidth) / 2
                let positionX = paddingX + (self.columnWidth * CGFloat(column))
                                   
                let paddingY = (self.columnHeight - self.viewHeight) / 2
                let positionY = paddingY + (self.columnHeight * CGFloat(row))
                              
                view.frame = CGRect(
                    x:  positionX, y: positionY,
                    width: self.viewWidth, height: self.viewHeight
                )
            }
        }
    }
    
    
    private func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    /**
     * let player know its a game over
     */
    private func gameOver(){
        endTime = self.getCurrentMillis()
        let in_seconds = (endTime - startTime) / 1000
        let minutes = (in_seconds / 60)
        let seconds = (in_seconds % 60)
        if playing > 1 {
            let playerOneScore = players[0] ?? 0
            let playerTwoScore = players[1] ?? 0
            if playerOneScore > playerTwoScore {
                scoreCard = """
                    Player One wins with: \(playerOneScore)
                """
            } else if playerTwoScore > playerOneScore {
                scoreCard = """
                    Player Two wins with: \(playerTwoScore)
                """
            }else{
                scoreCard = """
                    Tied Score: \(playerOneScore)
                """
            }
        }else{
            let score = players[currentPlayer] ?? 0
            scoreCard = """
                            Final Score: \(score) in \(minutes)m \(seconds)s
                        """
        }
    }
    
    private func dealCards(){
        let calculatedSize = columns * rows
        let cardCount = self.cardViews.count
        if cardCount < calculatedSize  {
            for index in 0..<calculatedSize {
                let row = Int((index / columns))
                let column = index % columns
                if let card = deck.dealCard() {
                    let view = SetCardEnhancedView()
                    view.setCard(card: card)
                    let paddingX = (self.columnWidth - self.viewWidth)
                    let positionX = paddingX / 2 + (self.columnWidth * CGFloat(column))
                    let paddingY = (self.columnHeight - self.viewHeight)
                    let positionY = paddingY / 2 + (self.columnHeight * CGFloat(row))
                    view.frame = CGRect(x:  positionX, y: positionY, width: self.viewWidth, height: self.viewHeight)
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapSetCardView(_:)))
                    view.isOpaque = false
                    view.isUserInteractionEnabled = true
                    view.addGestureRecognizer(tap)
                    self.cardViews.append(view)
                    self.addSubview(view)
                }
            }
        }else if(cardCount > calculatedSize) {
            //we need to remove from the top and add it back to deck, resizing deck
            for _ in 0..<columns {
                if let view = cardViews.popLast() {
                    let card = view.card
                    self.deck.addCardBack(card: card)
                    view.removeFromSuperview()
                }
            }
        }
        self.fixCardContraints()
    }
    
    
    @objc func tapSetCardView(_ sender : UITapGestureRecognizer ) {
        guard sender.view != nil else { return }
        let view = (sender.view as! SetCardView)
        view.isSelected = !view.isSelected
        if(cardViews.validate()){
            //We found a set match
            //We should add a score
            self.lastMatchTime = getCurrentMillis()
            players[currentPlayer]? += 5
            let remainingCards = deck.count()
            if(remainingCards >= 3){
                cardViews.replace(cards: [deck.dealCard()!, deck.dealCard()!, deck.dealCard()!])
            }else if(remainingCards > 0){
                var remaining: [SetCard] = [SetCard]()
                for _ in 0...deck.count() {
                    if let c = deck.dealCard(){
                        remaining.append(c)
                    }
                }
                cardViews.replace(cards: remaining)
            }else if(cardViews.count > 0){
                //Handle Remaining Game
                cardViews.wipeMatches()
            }
            cardViews.reset()
            
        }else if(cardViews.has3selected()){
            cardViews.reset()
            if(cardViews.hasMatch()){
                players[currentPlayer]? -= 5
            }
        }
        if(!cardViews.hasMatch()){
            gameOver()
        }
    }
    

    
    //region Override Functions
    
    override func draw(_ rect: CGRect) {
        dealCards()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        subviews.forEach { (view) in
            view.traitCollectionDidChange(previousTraitCollection)
        }
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    func setProtocol(_ proto: SetGameTimerProtocol?){
        self.timerProtocol = proto
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fixCardContraints()
        print("CLASS CARDS: \(cardViews.count). DECK CARDS \(deck.count())  rows: \(rows) + columns: \(columns)")
    }
    
    //endregion
        
}

extension SetCardGridContainerView {
    
    struct ViewRatios {
        static let widthRatio: CGFloat = 0.75
        static let heightRatio: CGFloat = 0.75
    }
    
    var columnHeight: CGFloat {
        return  self.bounds.size.height / CGFloat(rows)
    }
    var columnWidth: CGFloat {
        return  self.bounds.size.width / CGFloat(columns)
    }
    
    var viewWidth: CGFloat {
        return self.columnWidth * ViewRatios.widthRatio
    }
    
    var viewHeight: CGFloat {
        return self.columnHeight * ViewRatios.heightRatio
    }
    
}
