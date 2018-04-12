//
//  Card.swift
//  MatchMatch
//
//  Created by Benjamin Kim on 4/11/18.
//  Copyright © 2018 Benjamin Kim. All rights reserved.
//

import Foundation
//It's the model of a unique Card w/o emoji displayed in UI
//  1. Am I face up
//  2. Am I matched up and therfore kicked out of the game
//  3. My unique ID
//  4. TYPE ONLY, NOT OBJ - make an ID & hold onto next ID# to be given to next init()
//  5. init() a Card - call unique ID func from TYPE to use in making obj

struct Card: Hashable {
    
    var hashValue: Int {return identifier} // delegate var. req. for Hashable protocol
    
    static func ==(lhs: Card, rhs: Card) -> Bool { // delegate method re. for Equatable protocol
        return lhs.identifier == rhs.identifier
    }
    
    // Didn't put associated emoji since model needs to be UI independent
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int // ideally want to make this 'private' and make custom Equatable protocol
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1 // can access static vars in static func w/o referring to Card.identifierFactory
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
