//
//  CardModel.swift
//  Match App
//
//  Created by Taha Afzal on 8/5/20.
//  Copyright © 2020 Taha Afzal. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        var cardsArray = [Card]()
        var generatedRandomNumbers = [Int]()
        
        // creating 8 pairs of cards, so a total of 16 cards
        while cardsArray.count < 16 {
            
            let randomNumber = Int.random(in: 1 ... 13)
            
            if !generatedRandomNumbers.contains(randomNumber) {
                
                // add the newly generated random number to the array to keep track of which cards have already been added to the cardsArray
                generatedRandomNumbers.append(randomNumber)
                
                // creating 2 cards with the same image.
                let card1 = Card(imageName: "card\(randomNumber)")
                let card2 = Card(imageName: "card\(randomNumber)")

                cardsArray.append(card1)
                cardsArray.append(card2)

            }
        
        }
        
        // shuffle the pairs of cards in the cardsArray to avoid the cards from a pair to be next to each other
        cardsArray.shuffle()
        
        return cardsArray
        
    }
}
