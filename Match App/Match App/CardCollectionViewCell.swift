//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Taha Afzal on 8/5/20.
//  Copyright © 2020 Taha Afzal. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func setFrontImageView(to card: Card) {
        
        // keep track of the card that this cell represents
        self.card = card
        
        // set the frontImageView to a card
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        // reset the cell's isFlipped to false. This ensures that any new cells coming into view are not flipped up when the cells are recycled by the CollectionView
        if card.isTurned == true {
            flipUp(speed: 0.0)
        }
        else {
            flipDown(speed: 0.0, delay: 0.0)
        }
        
    }
    
    func flipUp(speed: TimeInterval = 0.3) {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        card?.isTurned = true
        
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        
        // delay the flipDown by 0.5 seconds if the 2 cards don't match
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options:  [.showHideTransitionViews, .transitionFlipFromRight], completion: nil)
        }
        
        card?.isTurned = false
    
    }
    
    func removeCard() {
        
        // make the image view disappear
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    } 
}
