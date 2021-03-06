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
    
    let animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear)
    let dynamic = SetGameBehavior()
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    func configureAnimations(_ card: SetCardView){
        animator.addAnimations {
            card.alpha = 1.0
            card.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
    @IBInspectable
    var rows: Int = 6 {
        didSet {
            if(deck.count() > 0){
                setNeedsDisplay()
                setNeedsLayout()
            }else{
                rows = oldValue
            }
        }
    }
    
    @IBInspectable
    var waiting: Int = 15 {
        didSet {
            countdown = waiting
        }
    }
    
    @IBInspectable
    var columns: Int = 3 {
        didSet {
            if(deck.count() > 0){
                setNeedsDisplay()
                setNeedsLayout()
            }else{
                columns = oldValue
            }
        }
    }
    
    private(set) var timer: Timer?
    private(set) var timerProtocol: SetGameTimerProtocol? = nil
    private(set) var countdown = 15 {
        didSet {
            let score = players[currentPlayer] ?? 0
            timerProtocol?.onTicked(player: currentPlayer, current_timer: countdown, score: score)
            setNeedsDisplay()
            setNeedsLayout()
            if(!cardViews.hasMatch() && deck.count() == 0){
                gameOver()
            }
            ///print("!hasMatch: \(!cardViews.hasMatch()) && Deck Count == 0: \(deck.count() == 0)")
        }
    }
    
    @IBInspectable
    var playing: Int = 2 {
        didSet {
            players[0] = 0
            players[1] = 0
            //self.startNewGame()
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private var currentPlayer: Int = 0
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
        }else if deck.count() == 0{
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
    ///Prevents user from adding a new row if there are 3 or more matches
    func dealNewCards(_ force: Bool = false) -> Bool {
        print("Matches: \(self.cardViews.matches())")
        if(self.cardViews.matches() < 3 || force) {
            self.rows += 1
            return true
        }
        return false
    }
    
    func getMatchCount() -> Int {
        return self.cardViews.matches()
    }
    
    //reset the deck and start a new game
    func startNewGame(){
        clear()
        players[0] = 0
        players[1] = 0
        currentPlayer = 0
        countdown = waiting
        deck.reset()
        rows = 4
        for card in cardViews {
            card.setCard(card: deck.dealCard())
        }
        startTimer()
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    func startTimer(){
        guard timer == nil else {return}
        if timer?.isValid ?? false {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerAction),
            userInfo: nil,
            repeats: true)
        timer?.tolerance = 1
    }
    
    //countdown $(waiting) seconds and switch players
    @objc private func timerAction(){
        countdown-=1
        if countdown == 0 {
            if (playing > 1) {
                currentPlayer = (currentPlayer + 1) % 2
            }else{
                currentPlayer = 0
            }
            countdown = waiting
        }
        if(getMatchCount() == 0 && deck.count() > 0){
            dealNewCards(true)
        }
    }
    
    ///We want to make sure that the contrains for the cards are accurate and that we should recalculate each frame for the cards
    private func fixCardContraints(){
        for index in 0..<subviews.count {
            ///print("Grid Index = (Row: \(row), Column: \(column), Quik Maffs: \(row * columns), Index: \(indexi) or \(index)")
            let row    = Int((index / columns))
            let column = index % columns
            let view = getView(row: row, column: column)
            let paddingX = (self.columnWidth - self.viewWidth) / 2
            let positionX = paddingX + (self.columnWidth * CGFloat(column))
            let paddingY = (self.columnHeight - self.viewHeight) / 2
            let positionY = paddingY + (self.columnHeight * CGFloat(row))
            UIView.animate(withDuration: 1.0) {
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
        timerProtocol?.onFinished(scoreCard: scoreCard)
        stopTimer()
    }
    
    private func dealCards(){
        let calculatedSize = columns * rows
        let cardCount = self.cardViews.count
        ///print("CALC: \(calculatedSize) - Count \(cardCount)")
        if cardCount < calculatedSize  {
            self.appendRows()
        }else if cardCount > calculatedSize {
            self.truncateRows()
        }
        self.fixCardContraints()
        if(getMatchCount() == 0 && deck.count() > 0){
            dealNewCards(true)
        }
    }
    
    private func appendRows(){
        let calculatedSize = columns * rows
        for index in cardViews.count..<calculatedSize {
            let row = Int((index / columns))
            let column = index % columns
            if let card = deck.dealCard() {
                let view = SetCardEnhancedView()
                self.cardViews.append(view)
                self.addSubview(view)
                view.setCard(card: card)
                dynamic.addSnap(view: view)
                let paddingX = (self.columnWidth - self.viewWidth)
                let positionX = paddingX / 2 + (self.columnWidth * CGFloat(column))
                let paddingY = (self.columnHeight - self.viewHeight)
                let positionY = paddingY / 2 + (self.columnHeight * CGFloat(row))
                view.layer.position = CGPoint(x:frame.width/2, y:frame.height) //Starting position
                UIView.animate(withDuration: 1, delay: (0.05 * Double(index))){ //Position To animate
                    view.layer.position = CGPoint(x: positionX, y: positionY)
                    view.layer.frame = CGRect(x:  positionX, y: positionY, width: self.viewWidth, height: self.viewHeight)
                }
                //CGRect(x:  positionX, y: positionY, width: self.viewWidth, height:
                
                //view.frame = CGRect(x:  positionX, y: positionY, width: self.viewWidth, height: self.viewHeight)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapSetCardView(_:)))
                view.isOpaque = false
                view.isUserInteractionEnabled = true
                view.addGestureRecognizer(tap)
                
            }
        }
    }
    
    private func truncateRows() {
        let calculatedSize = columns * rows
        let cardCount = self.cardViews.count
        let mod = cardCount % calculatedSize
        ///print("Truncating Rows: calc: colums * rows = \(calculatedSize), cardCount: \(cardCount) MOD \(mod)")
        for _ in 0..<mod {
            if let view = cardViews.popLast() {
                let card = view.card
                self.deck.addCardBack(card: card)
                view.removeFromSuperview()
            }
        }
    }
    
    
    @objc func tapSetCardView(_ sender : UITapGestureRecognizer ) {
        guard sender.view != nil else { return }
        let view = (sender.view as! SetCardView)
        view.isSelected = !view.isSelected
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.6,
            delay: 0,
            options: [.repeat],
            animations: {
                view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            })
        if(cardViews.validate()){
            //We found a set match
            //We should add a score
            self.lastMatchTime = getCurrentMillis()
            players[currentPlayer]? += 5
            let remainingCards = deck.count()
            if(remainingCards >= 3){
                cardViews.forEach { (card) in
                    UIView.transition(
                        with: card,
                        duration: 1.2,
                        options: [.transitionCrossDissolve],
                        animations: {}
                    )
                }
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
        if(!cardViews.hasMatch() && deck.count() == 0){
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
    }
    
    //endregion
    
    private func clear(){
        cardViews.forEach { (card) in
            UIView.animate(withDuration: 1) {
                card.layer.position = CGPoint(x: self.frame.width/2, y: self.frame.height)
            }
            card.removeFromSuperview()
            cardViews.removeFirst()
        }
    }
        
}

extension SetCardGridContainerView {
    
    private struct ViewRatios {
        static let widthRatio: CGFloat = 0.75
        static let heightRatio: CGFloat = 0.75
    }
    
    private var columnHeight: CGFloat {
        return  self.bounds.size.height / CGFloat(rows)
    }
    
    private var columnWidth: CGFloat {
        return  self.bounds.size.width / CGFloat(columns)
    }
    
    private var viewWidth: CGFloat {
        return self.columnWidth * ViewRatios.widthRatio
    }
    
    private var viewHeight: CGFloat {
        return self.columnHeight * ViewRatios.heightRatio
    }
    
}
