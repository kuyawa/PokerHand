//
//  Combinatorics.swift
//  PokerHand
//
//  Created by Mac Mini on 2/1/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

class Combinatorics {

    // Couldn't find a nice library so just harcoded 21 swaps for comb(7,5)
    func combine(_ sample: Cards) -> [Cards] {
        var results = [Cards]()

        let places = [
            [0,1,2,3,4],
            [0,1,2,3,5],
            [0,1,2,3,6],
            [0,1,2,4,5],
            [0,1,2,4,6],
            [0,1,2,5,6],
            [0,1,3,4,5],
            [0,1,3,4,6],
            [0,1,3,5,6],
            [0,1,4,5,6],
            [0,2,3,4,5],
            [0,2,3,4,6],
            [0,2,3,5,6],
            [0,2,4,5,6],
            [0,3,4,5,6],
            [1,2,3,4,5],
            [1,2,3,4,6],
            [1,2,3,5,6],
            [1,2,4,5,6],
            [1,3,4,5,6],
            [2,3,4,5,6]
        ]
        
        for item in places {
            results.append([sample[item[0]], sample[item[1]], sample[item[2]], sample[item[3]], sample[item[4]]])
        }
        
        return results
    }
}

// End
