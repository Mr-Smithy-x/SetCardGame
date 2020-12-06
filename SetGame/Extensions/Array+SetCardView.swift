//
//  Array+SetCardView.swift
//  SetGame
//
//  Created by Charlton Smith on 10/4/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation
import UIKit

//Array of SetCardView Extension
extension Array where Element == SetCardView {
    
    //We only want visible matches
    func matches() -> Int {
        let matchesArray = self.filter({ (view) -> Bool in
            return view.isVisible
        });
        var matches = 0
        if matchesArray.count == 0 {
            return 0
        }
        for i in 0...matchesArray.count - 1 {
            for j in 0...matchesArray.count - 1  {
                for k in 0...matchesArray.count - 1 {
                    if i == j || j == k || i == k {
                        continue
                    }
                    if(CardMatchHelper.isSet(cardOne: matchesArray[i].card, cardTwo: matchesArray[j].card, cardThree: matchesArray[k].card)) {
                        matches += 1
                    }
                }
            }
        }
        print("MATCHES \(matches), REAL MATCHES \(matches / 3)")
        return matches / 3; //to calculate the real count
    }
    
    
    func findMatching(show: Bool = true) -> Bool {
        var should_break = false
        if self.count == 0 {
            return false
        }
        for i in 0...self.count - 1 {
            for j in 0...self.count - 1  {
                for k in 0...self.count - 1 {
                    if i == j || j == k || i == k {
                        continue
                    }
                    if(CardMatchHelper.isSet(cardOne: self[i].card, cardTwo: self[j].card, cardThree: self[k].card)) {
                        if(show){
                            self[i].isCheating = true
                            self[j].isCheating = true
                            self[k].isCheating = true
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [.transitionFlipFromLeft],
                                animations: {
                                    [self[i], self[j], self[k]].forEach({ (card) in
                                        card.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
                                    })
                                })
                        }
                        should_break = true
                        if(should_break){
                            break;
                        }
                    }
                    if(should_break){
                        break;
                    }
                }
                if(should_break){
                    break;
                }
            }
        }
        return should_break;
    }
    
    /**
     * if the card count is more than 0 then we should deal the cards.
     */
    mutating func replace(cards: [SetCard]) {
        if(cards.count > 0){
            let views = self.filter { (view) -> Bool in
                return view.isSelected
            }
            scaleup(views: views, cards: cards)
        }
    }
    
    
    
    mutating func scaleup(views: [SetCardView], cards: [SetCard]) {
        var map: [SetCardView: CGPoint] = [:]
        views.forEach({ (card) in
            map[card] = card.layer.position
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 3,
                delay: 0,
                options: [.transitionCurlUp],
                animations: {
                    let point = CGPoint(
                        x: (card.superview?.layer.position.x ?? 0) + (card.superview?.bounds.midX ?? 0),
                        y: (card.superview?.layer.position.y ?? 0) + (card.superview?.bounds.height ?? 0)
                    )
                    print("POINT TO GO: \(point)")
                    card.layer.position = point
            }) { (position) in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1,
                    delay: 0,
                    options: [.layoutSubviews],
                    animations: {
                        if let index = views.firstIndex(of: card) {
                            card.setCard(card: cards[index])
                            card.isSelected = false
                            card.isCheating = false
                        }
                    }) { (position) in
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 3,
                            delay: 0,
                            options: [.transitionCurlDown],
                            animations: {
                                card.layer.position = map[card]!
                        })
                    }
                }
        })
    }
    
    mutating private func completeReplacement(cards: [SetCard]){
        let indexes = filter { (view) -> Bool in
            return view.isSelected
        }.map { (view) -> Int in
            return (self.firstIndex(of: view) ?? -1)
        }
        var i = 0;
        indexes.forEach { (index) in
            if(i < cards.count){
                self[index].setCard(card: cards[i])
                self[index].isSelected = false
                self[index].isCheating = false
                i+=1
            }else{
                self[index].isVisible = false
                self[index].isSelected = false
                self[index].isCheating = false
            }
        }
    }
    
    /**
     * Check if theres 3 cards selected
     */
    func has3selected() -> Bool {
        return self.filter({ (view) -> Bool in
            return view.isSelected
            }).count >= 3
    }
    
    /**
     * Set the slections to false to not highlight the changes.
     */
    func reset(){
        let selectedViews = self.filter { (view) -> Bool in
            return view.isSelected
        };
        selectedViews.forEach({ (view) in
            view.isSelected = false
        })
        self.forEach({ (view) in
            view.isCheating = false
        })
    }
    
    /**
     * wipe remaining matches by setting them invisible if they have been matched
     */
    func wipeMatches() {
        self.filter { (view) -> Bool in
            return view.isSelected
        }.forEach { (view) in
            view.isVisible = false
            view.isSelected = false
        }
    }
    
    /**
     * Check if there are matches but dont show the matches
     */
    func hasMatch() -> Bool {
        return self.filter({ (view) -> Bool in
            return view.isVisible
        }).findMatching(show: false)
    }
    
    /**
     * Check if there are matches and show them
     */
    func peek() -> Bool {
        return self.filter({ (view) -> Bool in
            return view.isVisible
            }).findMatching()
    }
    
    
    
    /**
     * This method checks if selections are eligible to matching
     * if there is 3 selections then match check whether there is a match.
     * if there is a not a match, reset the selections.
     */
    func validate() -> Bool {
        let selectedViews = self.filter { (view) -> Bool in
            return view.isSelected
        }
        //doesnt qualify for a match yet
        if(selectedViews.count < 3) {
            return false;
        }
        let isSet = CardMatchHelper.isSet(cardOne: selectedViews[0].card, cardTwo: selectedViews[1].card, cardThree: selectedViews[2].card)
        return isSet
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }

    
}
