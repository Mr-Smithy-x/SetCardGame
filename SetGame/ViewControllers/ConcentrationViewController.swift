//
//  ViewController.swift
//  CardGame
//
//  Created by Charlton Smith on 9/3/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController, OnGameListener {
    
    private var emojiChoices: String = "👻🎃🍬🍭🍫🍪🍏🍗🌭🥩🥖🥯🍅🍇🍋🍝🍥🍰🍶🍙"
    private var emoji = Dictionary<Card, String>()
    private lazy var game: Concentration = Concentration(numberOfCardsToMatch: 2, onCardRefresh: self)
    
    var theme: String = "👻🎃🍬🍭🍫🍪🍏🍗🌭🥩🥖🥯🍅🍇🍋🍝🍥🍰🍶🍙" {
        didSet {
            onReset()
        }
    }
    var themeName: String = "Default"
    
    
    @IBOutlet weak var selectTwoNewGameBtn: UIButton! {
        didSet {
            
            selectTwoNewGameBtn.addTarget(self, action: #selector(resetGame(_:)), for: UIControl.Event.touchDown)
        }
    }
    @IBOutlet weak var selectThreeNewGameBtn: UIButton! {
        didSet {
            selectThreeNewGameBtn.addTarget(self, action: #selector(new3CardGame(_:)), for: UIControl.Event.touchDown)
        }
    }
    @IBOutlet private var cardButtons: [UIButton]! {
        didSet{
            for card in cardButtons {
                card.addTarget(self, action: #selector(touchCard(_:)), for: UIControl.Event.touchDown)
            }
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet{
            updateLabel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game.verifyDeck()
        updateViewFromModel()
        navigationItem.title = "You're playing \(themeName) Game!"
    }

    
    @objc private func touchCard(_ sender: UIButton){
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            if(game.chooseCard(at: cardNumber)){
                self.game.replaceCard()
            }
            updateViewFromModel()
        }else{
            print("chosen card")
        }
    }
    
    @objc private func resetGame(_ sender: UIButton){
        theme = Array(Concentration.themes.values)[Concentration.themes.count.arc4random] // change theme single line
        self.game.reset(numberOfCardsToMatch: 2)
        updateViewFromModel()
    }
    
    @objc private func new3CardGame(_ sender: UIButton){
        theme = Array(Concentration.themes.values)[Concentration.themes.count.arc4random] //change theme
        self.game.reset(numberOfCardsToMatch: 3)
        updateViewFromModel()
    }
    
    func onReset() {
        emojiChoices = theme
        emoji = [:]
        updateViewFromModel()
    }
    
    func onCompleted() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.red,
            .strokeWidth: 5.0
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount) Score \(game.scoreCount)\nCompleted!",attributes: attributes)
        flipCountLabel.attributedText = attributedString
        updateViewFromModel()
    }
    
    
    
    func onRefreshed() {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.red,
            .strokeWidth: 5.0
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount) Score \(game.scoreCount)\nBecareful!! Cards were shuffled!",attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    
    func fire(){
        let delayInSeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.updateViewFromModel()
        }
    }
    
    @objc private func updateViewFromModel() {
        if cardButtons == nil {
            return
        }
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp || card.isMatched {
                    UIView.transition(
                        with: button,
                        duration: 1.2,
                        options: [.transitionFlipFromRight],
                        animations: {
                            button.setTitle(self.emoji(for: card), for: UIControl.State.normal)
                            button.backgroundColor = UIColor.white
                        }
                    )
            } else {
                UIView.transition(
                    with: button,
                    duration: 1.2,
                    options: [.transitionCrossDissolve],
                    animations: {
                        button.setTitle("", for: UIControl.State.normal)
                        button.backgroundColor = UIColor.orange
                       
                    }
                )
            }
        }
    }
    
    private func emoji (for card: Card) ->  String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(
                emojiChoices.startIndex,
                offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }

    func updateLabel(){
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.red,
            .strokeWidth: 5.0
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount) Score \(game.scoreCount)",attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    func onScoreBoardUpdate(flip: Int, score: Int) {
        self.updateLabel()
    }
    
}


