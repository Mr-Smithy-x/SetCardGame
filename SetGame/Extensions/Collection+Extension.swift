//
//  CollectionExtension.swift
//  CardGame
//
//  Created by Charlton Smith on 10/26/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation


extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
