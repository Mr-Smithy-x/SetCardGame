//
//  SetGameTimerProtocol.swift
//  SetGame
//
//  Created by Charlton Smith on 10/27/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation

protocol SetGameTimerProtocol {
    func onTicked(player: Int, current_timer: Int, score: Int)
    func onFinished(scoreCard: String)
}
