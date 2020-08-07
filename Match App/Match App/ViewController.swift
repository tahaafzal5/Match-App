//
//  ViewController.swift
//  Match App
//
//  Created by Taha Afzal on 8/4/20.
//  Copyright © 2020 Taha Afzal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    let cardModel = CardModel()
    var cardsArray = [Card]()
    
    var timer: Timer?
    var timerDurationMilliseconds = 30.0 * 1000.0
    
    var firstFlippedCardIndex: IndexPath?
    var secondFlippedCardIndex: IndexPath = []
    
    var sound = SoundManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cardsArray = cardModel.getCards()
        
        // setting the view controller as the data source and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // initialize the timer that updates every millisecond and hence the timeInterval: 0.001
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sound.playSound(effect: .shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        
        // decrement the counter
        timerDurationMilliseconds -= 1
        
        // update the label in seconds and to 2 decimal places
        let seconds = timerDurationMilliseconds/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f seconds", seconds)
        
        // stop the timer if it reaches zero
        if timerDurationMilliseconds == 0 {
            
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // TODO: check if the user has cleared all the pairs or not
            checkIfGameFinished()
            
        }
        
    }
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // return the number of cells we want to display in total
        return cardsArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a cell and cast it from a UICollectionViewCell to a CardCollectionViewCell
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
  
        // return the cell
        return cardCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // configure the state of the cell based on the properties of the Card it represents
        let cardCell = cell as? CardCollectionViewCell
        
        cardCell?.setFrontImageView(to: cardsArray[indexPath.row])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // if timer is over, do not let the user to interact
        if timerDurationMilliseconds <= 0 {
            return
        }
        
        // get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isTurned == false && cell?.card?.isMatched == false {
            
            cell?.flipUp()
            
            sound.playSound(effect: .flip)
            
            // check if this was the first flipped card or the second and perform actions accordingly
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                secondFlippedCardIndex = indexPath
                checkMatch(for: firstFlippedCardIndex, and: secondFlippedCardIndex)
            }
        }
        
    }
    
    // MARK: - Game logic methods
    
    func checkMatch(for firstFlippedCardIndex: IndexPath?, and secondFlippedCardIndex: IndexPath) {
        
        // get the 2 card objects for the 2 indices
        let card1 = cardsArray[firstFlippedCardIndex!.row]
        let card2 = cardsArray[secondFlippedCardIndex.row]
        
        // get the 2 collection view cells
        let cell1 = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cell2 = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // compare the 2 cards to see if they match and remove the 2 card if they do match
        if card1.imageName == card2.imageName {
            
            sound.playSound(effect: .correct)
            
            card1.isMatched = true
            card2.isMatched = true
            
            cell1?.removeCard()
            cell2?.removeCard()
            
            // check if the user has cleared all the pairs or not
            checkIfGameFinished()
            
        }
        else {
            
            sound.playSound(effect: .wrong)
            
            card1.isTurned = false
            card2.isTurned = false
            
            cell1?.flipDown()
            cell2?.flipDown()
            
        }
        
        // reset the firstFlippedCard
        self.firstFlippedCardIndex = nil
        
    }
    
    func checkIfGameFinished() {
        
        var hasWon = true
        
        for card in cardsArray {

            if card.isMatched == false {
                hasWon = false
                break
            }
            
        }
        
        if hasWon == true {
            showAlert(title: "Won!", message: "Congrats! You have won the game.")
        }
        else if timerDurationMilliseconds <= 0 {
            showAlert(title: "Time's up!", message: "Sorry the time is up. Better luck next time.")
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
