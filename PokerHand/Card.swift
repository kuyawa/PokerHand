//
//  Card.swift
//  PokerHand
//
//  Created by Mac Mini on 1/31/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

enum Rank: Int { case none, one, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace }
enum Suit: Int { case none, spades, hearts, clubs, diamonds }

let RankName   = ["None", "Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King", "Ace"]
let SuitName   = ["None", "Spades", "Hearts", "Clubs", "Diamonds"]
let RankLetter = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
let FaceLetter = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E"]
let SuitLetter = ["x", "s", "h", "c", "d"]

typealias Cards = [Card]

class Card {
    var rank: Rank
    var suit: Suit
    var value: Int { return rank.rawValue }
    var faceText: String { return FaceLetter[rank.rawValue] }
    var rankText: String { return RankLetter[rank.rawValue] }
    var suitText: String { return SuitLetter[suit.rawValue] }
    
    var description: String {
        return RankLetter[rank.rawValue] + SuitLetter[suit.rawValue]
    }
    
    var imageName: String { return suitText + faceText.lowercased() }
    
    // Card(.ace, .hearts)
    init(_ rank: Rank, _ suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
}


// End
