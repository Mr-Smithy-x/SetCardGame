//
//  SetCardCollectionViewCell.swift
//  SetGame
//
//  Created by Charlton Smith on 10/4/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation
import UIKit

class SetCardCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var card: SetCardView!
    
    func setCard(card: SetCard?){
        if let c = card{
            self.card.setCard(card: c)
        }
    }
    
}
