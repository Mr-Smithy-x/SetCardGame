//
//  Array+SetCardView.swift
//  SetGame
//
//  Created by Charlton Smith on 10/4/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation

//Array of SetCardView Extension
extension Array where Element == SetCardView {
    
    func findMatching(show: Bool = true) -> Bool {
        var should_break = false
        for i in 0...self.count - 1 {
            for j in 0...self.count - 1  {
                for k in 0...self.count - 1 {
                    if i == j || j == k || i == k {
                        continue
                    }
                    if(CardMatchHelper.isSet(cardOne: self[i].card, cardTwo: self[j].card, cardThree: self[k].card)) {
                        if(show){
                            self[i].cheat = true
                            self[j].cheat = true
                            self[k].cheat = true
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
            let indexes = self.filter { (view) -> Bool in
                return view.selected
            }.map { (view) -> Int in
                return (self.firstIndex(of: view) ?? -1)
            }
            var i = 0;
            indexes.forEach { (index) in
                if(i < cards.count){
                    self[index].setCard(card: cards[i])
                    self[index].selected = false
                    self[index].cheat = false
                    i+=1
                }else{
                    self[index].isVisible = false
                    self[index].selected = false
                    self[index].cheat = false
                }
            }
        }
    }
    
    /**
     * Check if theres 3 cards selected
     */
    func has3selected() -> Bool {
        return self.filter({ (view) -> Bool in
            return view.selected
            }).count >= 3
    }
    
    /**
     * Set the slections to false to not highlight the changes.
     */
    func reset(){
        let selectedViews = self.filter { (view) -> Bool in
            return view.selected
        };
        selectedViews.forEach({ (view) in
            view.selected = false
        })
        self.forEach({ (view) in
            view.cheat = false
        })
    }
    
    /**
     * wipe remaining matches by setting them invisible if they have been matched
     */
    func wipeMatches() {
        self.filter { (view) -> Bool in
            return view.selected
        }.forEach { (view) in
            view.isVisible = false
            view.selected = false
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
            return view.selected
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
