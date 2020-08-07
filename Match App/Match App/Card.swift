//
//  Card.swift
//  Match App
//
//  Created by Taha Afzal on 8/5/20.
//  Copyright © 2020 Taha Afzal. All rights reserved.
//

import Foundation

class Card {
    
    var imageName: String
    var isTurned: Bool
    var isMatched: Bool
    
    init(imageName: String) {
        
        self.imageName = imageName
        self.isTurned = false
        self.isMatched = false
        
    }
    
}
