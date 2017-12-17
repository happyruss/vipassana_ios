//
//  VipassanaManager.swift
//  Vipassana
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import Foundation

class VipassanaManager {
    
    public static var shared = VipassanaManager()
    let user: User
    
//    let introTrack: Track
//    let track1: Track
//    let track2: Track
//    let track3: Track
//    let track4: Track
//    let track5: Track
//    let track6: Track
//    let track7: Track
//    let track8: Track
//    let track9: Track

    public init() {
        let defaults = UserDefaults()
        
        //init the user
        self.user = User()
        self.user.completedTrack(trackNumber: defaults.integer(forKey: "SavedCompletedLevel"))
        if let savedCustomMeditationLengths = defaults.array(forKey: "SavedCustomMeditationLengths") {
            self.user.customMeditationLengths = savedCustomMeditationLengths as! [Int]
        }
        
        //init the tracks
//        track1 = Track(name: "Introduction", part1Length: 180, part1Url: )
        
    }
    
    
}
