//
//  EnhancedViewController.swift
//  SetGame
//
//  Created by Charlton Smith on 10/27/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation
import UIKit

class EnhancedViewController: UIViewController, SetGameTimerProtocol {
    
    var players: Int = 0
    var waiting: Int {
        if players > 1 {
            return 30
        }
        else {
            return 1
        }
    }
    
    func onFinished(scoreCard: String) {
        currentPlayer.text = scoreCard
    }
    
    
    @IBOutlet weak var currentPlayer: UILabel!
    
    func onTicked(player: Int, current_timer: Int, score: Int) {
        var text: String = ""
        if players > 1 {
            text = "Current Player: \(player + 1) - Score: \(score)\n\(current_timer) seconds left"
        }else{
            text = "Score: \(score)"
        }
        currentPlayer.text = text
    }
    
    
    @IBOutlet weak var iSetGameGridView: SetCardGridContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
           
        iSetGameGridView.playing = players
        iSetGameGridView.waiting = waiting
        iSetGameGridView.addGestureRecognizer(rotationGesture)
        iSetGameGridView.addGestureRecognizer(swipeDownGesture)
        iSetGameGridView.clipsToBounds = true
        iSetGameGridView.setProtocol(self)
        iSetGameGridView.startNewGame()
    }
    
    
    @objc func handleSwipe(_ sender : UISwipeGestureRecognizer ) {
        switch(sender.direction) {
            case .down:
                if(!iSetGameGridView.dealNewCards()){
                    let alert = UIAlertController(title: "Hmmm", message: "There are \(iSetGameGridView.getMatchCount()) match(es) in this set. Do you want to deal more cards?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                        let dealed = self.iSetGameGridView.dealNewCards(true)
                        print("Added More Cards: \(dealed)")
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                    self.present(alert, animated: true)
                }
                break
            default: break
        }
    }
    
    
    @objc func handleRotation(_ sender : UIRotationGestureRecognizer ) {
        iSetGameGridView.reshuffle()
    }
    
    @IBAction func onNewGameClicked(_ sender: Any) {
        iSetGameGridView.startNewGame()
    }
    
    @IBAction func onPeakClicked(_ sender: Any) {
        iSetGameGridView.peek()
    
    }
}
