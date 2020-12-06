//
//  Int+Extension.swift
//  CardGame
//
//  Created by Charlton Smith on 10/26/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation


extension Int {
    
    var arc4random: Int {
        if(self > 0){
            return Int(arc4random_uniform(UInt32(self)))
        } else if(self < 0){
            return -Int(arc4random_uniform(UInt32(-self)))
        }else{
            return 0
        }
    }
    
}
