//
//  ViewController.swift
//  SetGame
//
//  Created by Charlton Smith on 9/21/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var cardDeck: SetCardDeck = SetCardDeck()
    var reuseIdentifier: String = "card"
    
    var startTime: Int64 = 0
    var lastMatchTime: Int64 = 0
    var endTime: Int64 = 0
    
    
    var score: Int = 0 {
        didSet {
            scoreCard.text = "Score: \(score)"
        }
    }
   
    @IBOutlet weak var dealCardBtn: UIButton!
    @IBOutlet var scoreCard: UILabel!
    @IBOutlet var views: [SetCardEnhancedView]! {
        didSet {
            views.forEach { (view) in
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapSetCardView(_:)))
                
                view.isUserInteractionEnabled = true
                view.addGestureRecognizer(tap)
            }
        }
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }

    
    @IBAction func onDealCard(_ sender: UIView) {
        dealInitial()
    }
    
    /**
     * Reset Deck & Initialize a new deck
     */
    func dealInitial(){
        cardDeck.reset()
        views.forEach { (view) in
            if let c = cardDeck.dealCard() {
                view.setCard(card: c)
            }
            view.isCheating = false
            view.isSelected = false
        }
        startTime = self.getCurrentMillis()
        lastMatchTime = 0
        endTime = 0
        score = 0
    }
    
    /**
     * Extra Credit for cheating system.
     */
    @IBAction func onPeek(_ sender: UIView) {
        if(views.peek()){
            score -= 10
        }else{
            gameOver()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dealInitial()
        
    }

    /**
     * let player know its a game over
     */
    func gameOver(){
        endTime = self.getCurrentMillis()
        let in_seconds = (endTime - startTime) / 1000
        let minutes = (in_seconds / 60)
        let seconds = (in_seconds % 60)
        scoreCard.text = """
        Final Score: \(score) in \(minutes)m \(seconds)s
        """
    }
    
    @objc func tapSetCardView(_ sender : UITapGestureRecognizer ) {
        guard sender.view != nil else { return }
        let view = (sender.view as! SetCardView)
        print("selected: \(view.isSelected)")
        view.isSelected = !view.isSelected
        print("changed_to: \(view.isSelected)")
        if(views.validate()){
            //We found a set match
            //We should add a score
            self.lastMatchTime = getCurrentMillis()
            score += 5
            let remainingCards = cardDeck.count()
            if(remainingCards >= 3){
                views.replace(cards: [cardDeck.dealCard()!, cardDeck.dealCard()!, cardDeck.dealCard()!])
            }else if(remainingCards > 0){
                var remaining: [SetCard] = [SetCard]()
                for _ in 0...cardDeck.count() {
                    if let c = cardDeck.dealCard(){
                        remaining.append(c)
                    }
                }
                views.replace(cards: remaining)
            }else if(views.count > 0){
                //TODO: Handle Remaining Game
                views.wipeMatches()
            }
            views.reset()
            
        }else if(views.has3selected()){
            views.reset()
            if(views.hasMatch()){
                score -= 5
            }
        }
        if(!views.hasMatch()){
            gameOver()
        }
        
    }
}
