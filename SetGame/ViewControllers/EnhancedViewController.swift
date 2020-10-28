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
    func onFinished(scoreCard: String) {
        currentPlayer.text = scoreCard
    }
    
    
    @IBOutlet weak var currentPlayer: UILabel!
    
    func onTicked(player: Int, current_timer: Int) {
        currentPlayer.text = "Current Player: \(player + 1)\n\(current_timer) seconds left"
    }
    
    
    @IBOutlet weak var iSetGameGridView: SetCardGridContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
           
        iSetGameGridView.addGestureRecognizer(rotationGesture)
        iSetGameGridView.addGestureRecognizer(swipeDownGesture)
        iSetGameGridView.clipsToBounds = true
        iSetGameGridView.setProtocol(self)
        iSetGameGridView.startNewGame()
    }
    
    
    @objc func handleSwipe(_ sender : UISwipeGestureRecognizer ) {
        switch(sender.direction) {
            case .down:
                iSetGameGridView.dealNewCards()
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
