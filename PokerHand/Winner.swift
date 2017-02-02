//
//  Winner.swift
//  PokerHand
//
//  Created by Mac Mini on 2/1/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

enum WinnerType: Int {
    case player1, player2, draw
}

enum WinningHand: Int {
    case rankHigh, onePair, twoPair, threeOfKind, straight, flush, fullHouse, poker, straightFlush, royalFlush
}


struct Results {
    var best1   = [Card]()
    var best2   = [Card]()
    var cards   = [Card]() // winning cards
    var winner  = WinnerType.draw
    var score   = WinningHand.royalFlush
    var points  = "9edcba" // royal flush
    var high1   = Rank.none
    var high2   = Rank.none
    var kick    = Rank.none
    var suit    = Suit.none
    var message = ""
    
    var description: String {
        let cards1 = best1.map{ $0.description }.joined(separator: " ")
        let cards2 = best2.map{ $0.description }.joined(separator: " ")
        
        return "-Winner: \(winner.rawValue)\n"
        + " Player1: \(cards1) \(winner == .player1 ? "*" : "")\n"
        + " Player2: \(cards2) \(winner == .player2 ? "*" : "")\n"
        + " Score: \(score.rawValue)\n"
        + " Points: \(points)\n"
        + " Kick: \(kick.rawValue)\n"
        + " Text: \(message)"
    }
    
    func hasWinningCard(_ card: Card) -> Bool {
        return cards.contains{ each in
            return card.description == each.description
        }
    }

}

class Winner {
    
    func calculate(common: Cards, player1: Cards, player2: Cards) -> Results {
        var winner = WinnerType.draw
        
        let bestCards1 = getBestHand(common + player1)
        let bestCards2 = getBestHand(common + player2)
        
        let points1 = getHandScore(bestCards1)
        let points2 = getHandScore(bestCards2)

        print("-")
        print("Points1: \(points1)")
        print("Points2: \(points2)")
        
        // Assume first player won just to have some values
        var cards  = bestCards1
        var points = points1
        var kicker = getKicker(points1, points2)

        if points1 == points2 { winner = .draw }
        if points1 >  points2 { winner = .player1 }
        if points1 <  points2 {
            winner = .player2
            cards  = bestCards2
            points = points2
            kicker = getKicker(points2, points1)
        }
        
        let (high1, high2)  = getHighRanks(points)
        let suit  = cards.first?.suit ?? Suit.none
        let score = getScoreFromPoints(points)
        
        var results     = Results()
        results.winner  = winner
        results.cards   = cards
        results.points  = points
        results.score   = score
        results.best1   = bestCards1
        results.best2   = bestCards2
        results.high1   = high1
        results.high2   = high2
        results.kick    = kicker
        results.suit    = suit
        results.message = parseMessage(results)
        
        return results
    }
    
    // From seven cards, pick best five
    func getBestHand(_ cards: Cards) -> Cards {
        var best = Cards()
        var max  = ""
        
        // Combinations of 5 from 7
        let all = Combinatorics().combine(cards)
        //all.map{ print($0.map{ $0.description }.joined(separator: " ")) }
        
        for hand in all {
            let value = getHandScore(hand)
            if value > max {
                max  = value
                best = hand
            }
        }
        
        return best
    }
    
    // Royal flush     9edcba same suit
    // Straight flush  8edcba diff suit
    // Poker           7eeeed four aces
    // Full house      6eeedd three aces two kings
    // :
    // Worst hand      075432 seven high
    //
    // First char is used to compare best from 0:faceHigh, 1:onePair, 2:twoPair ... 9:royalFlush
    func getHandScore(_ cards: Cards) -> String {
        let suit  = cards[0].suitText // save for flush
        let ranks = getHandRanks(cards)
        let score = ranks.joined()
        
        let isFlush = checkFlush(cards)
        let isStraight = checkStraight(ranks)
        let fourKind = checkKind(4, ranks)
        let threeKind = checkKind(3, ranks)
        let twoPair = checkTwoPair(ranks)
        let onePair = checkKind(2, ranks)
        let rest = getUniques(ranks)
        
        if ranks[0] == "E" && isStraight && isFlush { return "9" + score }
        else if isStraight && isFlush { return "8" + score }
        else if !fourKind.isEmpty { return "7" + fourKind + rest }
        else if !threeKind.isEmpty && !onePair.isEmpty { return "6" + threeKind + onePair }
        else if isFlush { return "5" + score + suit }
        else if isStraight { return "4" + score }
        else if !threeKind.isEmpty { return "3" + threeKind + rest }
        else if !twoPair.isEmpty { return "2" + twoPair + rest }
        else if !onePair.isEmpty { return "1" + onePair + rest }
        
        return "0" + score
    }
    
    func getHandRanks(_ hand: Cards) -> [String] {
        var ranks: [String] = [String]()
        
        for item in hand {
            ranks.append(item.faceText);
        }
        
        ranks = ranks.sorted().reversed()
        
        if ranks.joined() == "E5432" {
            ranks = ["5", "4", "3", "2", "1"] // Move ace to end of low straight
        }

        return ranks
    }
    
    func getHandSuits(_ hand: Cards) -> [String] {
        let suits = hand.map{ $0.suitText }
        
        return suits
    }
    
    func getScoreFromPoints(_ score: String) -> WinningHand {
        guard let char = score.characters.first,
              let max  = Int(String(char))
        else { return .rankHigh }
        
        guard let score = WinningHand(rawValue: max) else { return .rankHigh }
        
        return score
    }
    
    // Return True if all the cards have the same suit
    func checkFlush(_ hand: Cards) -> Bool {
        let suits = hand.map{ $0.suitText }
        
        return Set(suits).count == 1
    }
    
    // Return True if the ordered ranks form a 5-card straight
    func checkStraight(_ ranks: [String]) -> Bool {
        let hex1 = Int(ranks.max()!.lowercased(), radix: 16)!
        let hex2 = Int(ranks.min()!.lowercased(), radix: 16)!
        
        return (hex1 - hex2 == 4) && (Set(ranks).count == 5)
    }
    
    // Return the first rank that this hand has exactly n-of-a-kind of.
    // Return null if there is no n-of-a-kind in the hand.
    func checkKind(_ n: Int, _ ranks: [String]) -> String {
        for item in ranks {
            if countRanks(item, ranks) == n {
                return String(repeating: item, count: n)
            }
        }
        
        return ""
    }
    
    // If there are two pair here, return the two ranks of the two pairs, else null
    func checkTwoPair(_ ranks: [String]) -> String {
        let hiPair = checkKind(2, ranks)
        let loPair = checkKind(2, ranks.reversed())
        
        if !hiPair.isEmpty && loPair != hiPair {
            return hiPair + loPair
        }
        
        return ""
    }

    // None of a kind
    func getUniques(_ ranks: [String]) -> String {
        var unique = ""
        
        for item in ranks {
            let dupes = ranks.filter{ $0 == item }
            if dupes.count == 1 {
                unique += item
            }
        }
        
        return unique
    }

    /*
    // Highest rank in kind
    func getHighRank(_ points: String) -> Rank {
        
        let ranks = points.characters.map{ String($0) }
        let high = ranks[1]
        let face = FaceLetter.index(of: high)
        let rank = Rank(rawValue: face!)
        
        return rank!
    }
    */
    
    func getHighRanks(_ points: String) -> (Rank, Rank) {
        
        let ranks = points.characters.map{ String($0) }
        let high1 = ranks[1]
        var high2 = ranks[3] // second pair
        if ranks[0] == "6" { high2 = ranks[4] } /* full house? */
        let face1 = FaceLetter.index(of: high1)
        let face2 = FaceLetter.index(of: high2)
        let rank1 = Rank(rawValue: face1!)
        let rank2 = Rank(rawValue: face2!)

        return (rank1!, rank2!)
    }
    
    // Highest rank not in kind
    func getKicker(_ points1: String, _ points2: String) -> Rank {
        var kick = ""
        let ranks1 = points1.characters.map{ String($0) }
        let ranks2 = points2.characters.map{ String($0) }

        // Same score, check kicker
        if ranks1[0] != ranks2[0] { return .none }
        
        let top = ranks1[0]

        switch top {
        case "9": break
        case "8": break
        case "7": if ranks1[1] == ranks2[1] { kick = ranks1[5] }
        case "6": break
        case "5": // highest card in flush
            if ranks1[1] > ranks2[1] { kick = ranks1[1] }
            else if ranks1[2] > ranks2[2] { kick = ranks1[2] }
            else if ranks1[3] > ranks2[3] { kick = ranks1[3] }
            else if ranks1[4] > ranks2[4] { kick = ranks1[4] }
            else { kick = ranks1[5] }
        case "4": break
        case "3": // same trips?
            if ranks1[1] == ranks2[1] {
                if ranks1[4] > ranks2[4] {
                    kick = ranks1[4]
                } else {
                    kick = ranks1[5]
                }
            }
        case "2":
            // same two pair?
            kick = ranks1[5]
        case "1":
            // same pair?
            if ranks1[1] == ranks2[1] {
                if  ranks1[3] > ranks2[3] { kick = ranks1[3] }
                else if ranks1[4] > ranks2[4] { kick = ranks1[4] }
                else { kick = ranks1[5] }
            }
        case "0":
            // Same high?
            if ranks1[1] == ranks2[1] {
                if ranks1[2] > ranks2[2] { kick = ranks1[2] }
                else if ranks1[3] > ranks2[3] { kick = ranks1[3] }
                else if ranks1[4] > ranks2[4] { kick = ranks1[4] }
                else { kick = ranks1[5] }
            }
        default: kick = "0"
        }

        let index  = FaceLetter.index(of: kick) ?? 0
        let kicker = Rank(rawValue: index)

        return kicker!
    }
    
    // Rank counter for kinds
    func countRanks(_ rank: String, _ ranks: [String]) -> Int {
        var n = 0
        
        for item in ranks {
            if item == rank {
                n += 1
            }
        }
        
        return n
    }

    func parseMessage(_ results: Results) -> String {
        let texts = [
            "{0}-high",
            "Pair of {0}s",
            "Two Pairs of {0}s and {1}s",
            "Three of a kind in {0}s",
            "Straight to the {0}",
            "Flush of {0}",
            "Full house of {0}s and {1}s",
            "Poker of {0}s",
            "Straight flush to the {0}",
            "Royal Flush. Perfect hand!"
        ]
        
        var text  = texts[results.score.rawValue]
        var text1 = RankName[results.high1.rawValue]
        let text2 = RankName[results.high2.rawValue]
        
        let score = results.score.rawValue
        
        // Flush? show suit instead of rank
        if score == 5 { text1 = SuitName[results.suit.rawValue] }
        
        text = text.replacingOccurrences(of: "{0}", with: text1)
        text = text.replacingOccurrences(of: "{1}", with: text2)
        
        let isDraw = results.winner.rawValue == WinnerType.draw.rawValue
        let lowScore = (results.score == WinningHand.rankHigh || results.score == WinningHand.onePair)
        let hasKicker = results.kick != .none
        
        if !isDraw && lowScore && hasKicker {
            text += " with {2}-kicker".replacingOccurrences(of: "{2}", with: RankName[results.kick.rawValue]);
        }
        
        text += " - "
        
        if(results.winner == .player2){ text += "You won!" }
        else if(results.winner == .player1) { text += "Your opponent won" }
        else { text += "It's a draw" }

        return text
    }
    
    
}


// End
