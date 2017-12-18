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
    var activeTrack: Track?
    var activeTrackLevel = 0
    let defaults = UserDefaults()

    public init() {        
        self.user = User()
        self.user.completedTrackLevel = defaults.integer(forKey: "SavedCompletedLevel")
        if let savedCustomMeditationLengths = defaults.array(forKey: "SavedCustomMeditationLengths") {
            self.user.customMeditationLengths = savedCustomMeditationLengths as! [Int]
        }
    }
    
    public func playTrackAtLevel(trackLevel: Int, gapDuration: Int) -> (Bool) {
        
        if (activeTrack != nil) {
            activeTrack!.stop()
            activeTrack = nil
            activeTrackLevel = 0
        }
        
        if (self.user.isAllowedToAccessLevel(requestedLevel: trackLevel)) {
            self.activeTrackLevel = trackLevel
            switch trackLevel {
            case 0:
                activeTrack = Track(name: "Introduction", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "Introduction", ofType: "wav")!), part2Url: nil, gapDuration: gapDuration)
                break
            case 1:
                activeTrack = Track(name: "Shamatha", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "01_Shamatha", ofType: "wav")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "01_Shamatha2", ofType: "wav")!), gapDuration: gapDuration)
                break
            case 2:
                activeTrack = Track(name: "Anapana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "02_Anapana", ofType: "wav")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "02_Anapana2", ofType: "wav")!), gapDuration: gapDuration)
                break
            case 3:
                activeTrack = Track(name: "Focused Anapana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "03_FocusedAnapana", ofType: "wav")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "03_FocusedAnapana2", ofType: "wav")!), gapDuration: gapDuration)
                break
            case 4:
                activeTrack = Track(name: "Top To Bottom Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "04_TopToBottom", ofType: "wav")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "04_TopToBottom2", ofType: "wav")!), gapDuration: gapDuration)
                break
            case 5:
                activeTrack  = Track(name: "Top To Bottom Bottom To Top Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "05_TopToBottomBottomToTop", ofType: "wav")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "05_TopToBottomBottomToTop2", ofType: "wav")!), gapDuration: gapDuration)
                break
            case 6:
                activeTrack = Track(name: "Symmetrical Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "06_Symmetrical", ofType: "wav")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "06_Symmetrical2", ofType: "wav")!), gapDuration: gapDuration)
                break
            case 7:
                activeTrack = Track(name: "Sweeping Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "07_Sweeping", ofType: "wav")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "07_Sweeping2", ofType: "wav")!), gapDuration: gapDuration)
                break
            case 8:
                activeTrack = Track(name: "Sweeping Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "08_InTheMoment", ofType: "wav")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "08_InTheMoment2", ofType: "wav")!), gapDuration: gapDuration)
                break
            case 9:
                activeTrack = Track(name: "Introduction", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "MetaPana", ofType: "wav")!), part2Url: nil, gapDuration: gapDuration)
                break
            default:
                return false
            }
            activeTrack!.playFromBeginning()
            return true
        } else {
            return false
        }
    }
    
    public func pauseOrResume() {
        guard activeTrack != nil else {
            return
        }
        activeTrack!.pauseOrResume()
    }
    
    public func stop() {
        guard activeTrack != nil else {
            return
        }
        activeTrack!.stop()
        activeTrack = nil
    }
    
    public func userCompletedTrack() {
        if (activeTrackLevel > self.user.completedTrackLevel) {
            self.user.completedTrackLevel = activeTrackLevel
            defaults.set(activeTrackLevel, forKey: "SavedCompletedLevel")
        }
    }
    
}
