//
//  PlayingCard.swift
//  SetGame
//
//  Created by Charlton Smith on 9/23/20.
//  Copyright © 2020 Charlton Smith. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    
    var description: String {
        return "\(rank)\(suit)"
    }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        
        var description: String {
            return self.rawValue
        }
        
        case clubs = "♣️"
        case diamonds = "♦️"
        case hearts = "❤️"
        case spades = "♠️"
        
        static var all = [Suit.clubs, .diamonds, .hearts, .spades]
    }
    
    enum Rank: CustomStringConvertible {
        var description: String {
            switch self {
                case .ace: return "A"
                case .numeric(let value): return String(value)
                case .face(let faceKind): return faceKind
            }
        }
        
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let value): return value
            case .face(let faceKind) where faceKind == "J": return 11
            case .face(let faceKind) where faceKind == "Q": return 12
            case .face(let faceKind) where faceKind == "K": return 13
            default: return 0
            }
        }
            
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for value in 2...10 {
                allRanks.append(.numeric(value))
            }
            allRanks += [.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
    }
}
