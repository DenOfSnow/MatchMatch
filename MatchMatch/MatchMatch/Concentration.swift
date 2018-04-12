//
//  Concentration.swift
//  MatchMatch
//
//  Created by Benjamin Kim on 4/11/18.
//  Copyright © 2018 Benjamin Kim. All rights reserved.
//

import Foundation

//It's the game logic:
//  1. Holds all the cards
//  2. Knows which card (by it's index) is currently the one and only face up card
//  3. What to do when a card is chosen; func called by VC when user taps the card button
//  4. init - set up a new game (list of Cards) given the # of pairs

struct Concentration { // Better as struct: don't pass Concentration games around. It just sits in our VC.
    
    // Outsider like VC can get my cards to display it, but I'm the only one responsible for setting it's properties like isMatched, isFaceUp. Makes it like a 'let' for outsiders.
    
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            // Look at all the cards to see if you find only 1 that's face-up, and return it; else return nil
            // card.indicies is a sequence of generic type 'countable range'
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            //            return faceUpCardIndicies.count = 1 ? faceUpCardIndicies.first : nil
            //            var foundFaceUpIndex: Int?
            //            for index in cards.indices {
            //                if cards[index].isFaceUp {
            //                    if foundFaceUpIndex == nil {
            //                        foundFaceUpIndex = index
            //                    } else {
            //                        return nil
            //                    }
            //                }
            //            }
            //
            //            return foundFaceUpIndex
        }
        
        set {
            // Turn all cards face-down, except the card at index of newValue
            for index in cards.indices {
                cards[index].isFaceUp = (index ==  newValue)
                print(cards[index])
                //MARK: Note clever use of brackets to contain a value
            }
        }
    }
    private(set) var cards = [Card]()
    private var numberOfPairsOfCards: Int = -1
    
    
    mutating func reset() {
        cards = reset(self.numberOfPairsOfCards)
    }
    
    private func reset(_ numberOfPairsOfCards: Int) -> [Card] {
        var shuffledCards = [Card]()
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            shuffledCards += [card, card]
        }
        // TODO: shuffle the cards
        shuffledCards = shuffle(shuffledCards)
        return shuffledCards
    }
    
    private func shuffle(_ cards: [Card]) -> [Card] {
        var temp = cards
        var result = [Card]()
        var index = temp.count - 1
        while index >= 0 {
            let randomCard = temp.remove(at: Int(arc4random_uniform(UInt32(index))))
            result.append(randomCard)
            index -= 1
        }
        return result
    }
    // Fundamental API which VC calls
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in cards") //protects from negative numbers for ex.
        
        if !cards[index].isMatched { // Ignore a tapped card that's already been matched a.k.a out of the game
            
            // THREE POSSIBILE SCENARIOS:
            // 1. 1 card is face up --> see if their IDs are equal
            // 2. No cards are face up --> flip this tapped card up
            // 3. 2 Cards are faced up (matching or not matching) --> Flip both cards face down
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index { // 1) We HAVE only 1 face-up card. And tapped card isn't the same oneAndOnlyFaceUpCard which the user just tapped a few seconds ago.
                
                // Check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true // matched: kicked out of game
                    cards[index].isMatched = true      // matched: kicked out of game
                }
                cards[index].isFaceUp = true
            } else {
                // 2 & 3) Either no card or 2 cards face-up
                indexOfOneAndOnlyFaceUpCard = index // calls setter
            }
            
        }
        // Don't do anything when the tapped card has been matched is already taken out of the game (can't see in UI)
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards)): you must have atleast one pair of cards to make a game") // Protects our API against improper use
        for _ in 1...numberOfPairsOfCards { // _ since didn't use the specific element we iterated over, just needed a total # of iterations
            let card = Card() // concentration game doesn't care about making unique ids for cards, just wants cards w/ unique ids --> move to Card
            cards += [card, card] // same as cards.append(card) two times
            //*** array and Card types passed as values: 3 Card obj: 1 in 46 and 2 in 47
        }
        self.numberOfPairsOfCards = numberOfPairsOfCards
        reset()
        //    TODO: Shuffle the cards
    }
    
}

// Looks at all the elements in the Collection calling this computed var. Returns the element if it's the one and only element in the Collection; else return nil.
extension Collection { // Collection is a generic type
    var oneAndOnly: Element? {
        //count & first are Collection methods, so I can use them in the implementation of a Collection var
        // I think self.count and self.first would also work
        return count == 1 ? first : nil
        
    }
}
