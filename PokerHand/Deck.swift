//
//  Deck.swift
//  PokerHand
//
//  Created by Mac Mini on 1/31/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

enum DeckStyle: String {
    case blue = "back_blue"
    case red  = "back_red"
}

class Deck {

    var cards = Cards()
    
    // For debugging
    var description: String {
        return cards.map{ $0.description }.joined(separator: " ")
    }
    
    init() {}
    
    func newPack() {
        cards = [
            Card(.ace,   .spades),
            Card(.two,   .spades),
            Card(.three, .spades),
            Card(.four,  .spades),
            Card(.five,  .spades),
            Card(.six,   .spades),
            Card(.seven, .spades),
            Card(.eight, .spades),
            Card(.nine,  .spades),
            Card(.ten,   .spades),
            Card(.jack,  .spades),
            Card(.queen, .spades),
            Card(.king,  .spades),
            
            Card(.ace,   .hearts),
            Card(.two,   .hearts),
            Card(.three, .hearts),
            Card(.four,  .hearts),
            Card(.five,  .hearts),
            Card(.six,   .hearts),
            Card(.seven, .hearts),
            Card(.eight, .hearts),
            Card(.nine,  .hearts),
            Card(.ten,   .hearts),
            Card(.jack,  .hearts),
            Card(.queen, .hearts),
            Card(.king,  .hearts),
            
            Card(.ace,   .clubs),
            Card(.two,   .clubs),
            Card(.three, .clubs),
            Card(.four,  .clubs),
            Card(.five,  .clubs),
            Card(.six,   .clubs),
            Card(.seven, .clubs),
            Card(.eight, .clubs),
            Card(.nine,  .clubs),
            Card(.ten,   .clubs),
            Card(.jack,  .clubs),
            Card(.queen, .clubs),
            Card(.king,  .clubs),
            
            Card(.ace,   .diamonds),
            Card(.two,   .diamonds),
            Card(.three, .diamonds),
            Card(.four,  .diamonds),
            Card(.five,  .diamonds),
            Card(.six,   .diamonds),
            Card(.seven, .diamonds),
            Card(.eight, .diamonds),
            Card(.nine,  .diamonds),
            Card(.ten,   .diamonds),
            Card(.jack,  .diamonds),
            Card(.queen, .diamonds),
            Card(.king,  .diamonds)
        ]
    }
    
    func shuffle() {
        newPack()
        
        // Loop, shuffle to random pos from index on
        for (index, _) in cards.enumerated() {
            let pos = Int(arc4random_uniform(UInt32(cards.count - index))) + index
            
            // swap cards
            let temp = cards[index]
            cards[index] = cards[pos]
            cards[pos] = temp
        }
        
        //print(description) // Show me the deck of cards
    }
    
    func draw() -> Card {
        let card = cards.popLast()
        return card!
    }
}


// End
