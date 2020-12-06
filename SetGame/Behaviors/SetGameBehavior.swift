//
//  SetGameBehavior.swift
//  SetGame
//
//  Created by Charlton Smith on 11/23/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import UIKit

class SetGameBehavior: UIDynamicBehavior {
    lazy var dynamic: UIDynamicItemBehavior = {
        let laz = UIDynamicItemBehavior()
        laz.allowsRotation = false
        laz.elasticity = 0.75
        return laz
    }()

    override init() {
        super.init()
        addChildBehavior(dynamic)
    }
    
    func addSnap(view: UIView){
        dynamic.addItem(view)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 0,
                                                       options: UIView.AnimationOptions.layoutSubviews) {
            
        } completion: { (position) in
            
        }

    }
}
