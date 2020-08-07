//
//  SoundManager.swift
//  Match App
//
//  Created by Taha Afzal on 8/6/20.
//  Copyright © 2020 Taha Afzal. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer: AVAudioPlayer?
    
    enum Sound {
        case shuffle
        case flip
        case correct
        case wrong
    }
    
    func playSound(effect: Sound) {
        
        var soundFileName = ""
        
        switch effect {
            case .shuffle:
                soundFileName = "shuffle"
            case .flip:
                soundFileName = "cardflip"
            case .correct:
                soundFileName = "dingcorrect"
            case .wrong:
                soundFileName = "dingwrong"
        }
        
        // get the path to the sound resources
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        // check that it is not nil
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            print("Couldn't create an audio player")
            return
        }
        
        audioPlayer?.play() 
    }
}
