//
//  OnGameListener.swift
//  CardGame
//
//  Created by Charlton Smith on 10/26/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation

protocol OnGameListener {
    func onReset()
    func onRefreshed()
    func onCompleted()
    func onScoreBoardUpdate(flip: Int, score: Int)
}
