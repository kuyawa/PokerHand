//
//  ViewController.swift
//  PokerHand
//
//  Created by Mac Mini on 1/31/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Action { case deal, flop, turn, river, final }
    
    var action    = Action.deal
    var player1   = Player("John Dillinger")
    var player2   = Player("Jesse James")
    var table     = Cards()
    var deck      = Deck()
    var blank     = "empty_green"
    
    @IBOutlet weak var player1_card1: UIImageView!
    @IBOutlet weak var player1_card2: UIImageView!
    
    @IBOutlet weak var player2_card1: UIImageView!
    @IBOutlet weak var player2_card2: UIImageView!
    
    @IBOutlet weak var table_card1: UIImageView!
    @IBOutlet weak var table_card2: UIImageView!
    @IBOutlet weak var table_card3: UIImageView!
    @IBOutlet weak var table_card4: UIImageView!
    @IBOutlet weak var table_card5: UIImageView!
    
    @IBOutlet weak var textMessage: UIButton!
    
    @IBAction func onPlay(_ sender: AnyObject) { playGame() }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rads = CGFloat.pi / 180.0
        player1_card1.transform = CGAffineTransform(rotationAngle:  9.0 * rads)
        player1_card2.transform = CGAffineTransform(rotationAngle: -9.0 * rads)
        player2_card1.transform = CGAffineTransform(rotationAngle: -9.0 * rads)
        player2_card2.transform = CGAffineTransform(rotationAngle:  9.0 * rads)
        
        playGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //---- START --------------------------------------------------
    
    func resetGame() {
        clearTable()
        player1.clearHand()
        player2.clearHand()
        table = Cards()
        litAllCards()
    }
    
    func clearTable() {
        setCardImage(player1_card1, name: blank)
        setCardImage(player1_card2, name: blank)

        setCardImage(player2_card1, name: blank)
        setCardImage(player2_card2, name: blank)

        setCardImage(table_card1, name: blank)
        setCardImage(table_card2, name: blank)
        setCardImage(table_card3, name: blank)
        setCardImage(table_card4, name: blank)
        setCardImage(table_card5, name: blank)
    }

    func playGame() {
        switch action {
        case .deal  : drawHands()
        case .flop  : drawFlop()
        case .turn  : drawTurn()
        case .river : drawRiver()
        case .final : drawFinal()
        }
    }
    
    func drawHands() {
        resetGame()
        deck.shuffle()
        
        // Draw cards from deck
        let card1 = deck.draw()
        let card2 = deck.draw()
        let card3 = deck.draw()
        let card4 = deck.draw()
        
        // Assign cards to players
        player1.hand = (card1, card2)
        player2.hand = (card3, card4)
        
        // Show cards, player1 face down
        setCardImage(player1_card1, name: DeckStyle.blue.rawValue)
        setCardImage(player1_card2, name: DeckStyle.blue.rawValue)
        
        setCardImage(player2_card1, name: player2.card1.imageName)
        setCardImage(player2_card2, name: player2.card2.imageName)
        
        // Next action
        setMessage("Tap to deal the flop")
        action = .flop
    }
    
    func drawFlop() {
        let card1 = deck.draw()
        let card2 = deck.draw()
        let card3 = deck.draw()

        table.append(card1)
        table.append(card2)
        table.append(card3)
        
        // show cards on table
        setCardImage(table_card1, name: card1.imageName)
        setCardImage(table_card2, name: card2.imageName)
        setCardImage(table_card3, name: card3.imageName)
        
        setMessage("Tap to deal the turn")
        action = .turn
    }
    
    func drawTurn() {
        let card = deck.draw()
        table.append(card)
        
        // show card on table
        setCardImage(table_card4, name: card.imageName)
        
        setMessage("Tap to deal the river")
        action = .river
    }
    
    func drawRiver() {
        let card = deck.draw()
        table.append(card)
        
        // show card on t able
        setCardImage(table_card5, name: card.imageName)
        
        setMessage("Tap for the final showdown")
        action = .final
    }
    
    func drawFinal() {
        // open cards, calculate winner, dim loser, show messages
        setCardImage(player1_card1, name: player1.card1.imageName)
        setCardImage(player1_card2, name: player1.card2.imageName)

        // Calculate winner
        let results = Winner().calculate(common: table, player1: player1.cards, player2: player2.cards)
        //print(results.description)

        // Highlight winning cards, dim rest
        dimAllCards()
        
        if results.hasWinningCard(table[0]) { litCard(table_card1) }
        if results.hasWinningCard(table[1]) { litCard(table_card2) }
        if results.hasWinningCard(table[2]) { litCard(table_card3) }
        if results.hasWinningCard(table[3]) { litCard(table_card4) }
        if results.hasWinningCard(table[4]) { litCard(table_card5) }
        
        if results.hasWinningCard(player1.cards[0]) { litCard(player1_card1) }
        if results.hasWinningCard(player1.cards[1]) { litCard(player1_card2) }
        if results.hasWinningCard(player2.cards[0]) { litCard(player2_card1) }
        if results.hasWinningCard(player2.cards[1]) { litCard(player2_card2) }

        setMessage(results.message)
        action = .deal
    }
    
    
    // UI Utils
    func setCardImage(_ image: UIImageView, name: String) {
        image.image = UIImage(named: name)
    }
    
    func setMessage(_ text: String) {
        textMessage.setTitle(text, for: .normal)
    }
    
    func dimCard(_ card: UIImageView) {
        card.alpha = 0.5
    }
    
    func litCard(_ card: UIImageView) {
        card.alpha = 1.0
    }
    
    func dimAllCards() {
        dimCard(table_card1)
        dimCard(table_card2)
        dimCard(table_card3)
        dimCard(table_card4)
        dimCard(table_card5)
        dimCard(player1_card1)
        dimCard(player1_card2)
        dimCard(player2_card1)
        dimCard(player2_card2)
    }

    func litAllCards() {
        litCard(table_card1)
        litCard(table_card2)
        litCard(table_card3)
        litCard(table_card4)
        litCard(table_card5)
        litCard(player1_card1)
        litCard(player1_card2)
        litCard(player2_card1)
        litCard(player2_card2)
    }
    
}


// End
