//
//  Player.swift
//  PokerHand
//
//  Created by Mac Mini on 2/1/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

class Player {
    var name = "Player"
    var hand = (Card(.none, .none), Card(.none, .none))
    var handValue = ""
    
    var card1: Card { return hand.0 }
    var card2: Card { return hand.1 }
    var cards: Cards { return [card1, card2] }
    
    init(_ name: String) {
        self.name = name
    }
    
    func bestHand() -> String {
        // TODO:
        return ""
    }
    
    func clearHand() {
        hand = (Card(.none, .none), Card(.none, .none))
        handValue = ""
    }
}
