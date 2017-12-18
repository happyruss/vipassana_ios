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
    let trackTemplateFactory = TrackTemplateFactory.shared
    
    public init() {
        self.user = User()
        self.user.completedTrackLevel = defaults.integer(forKey: "SavedCompletedLevel")
        var savedCustomMeditationDurationMinutes = defaults.integer(forKey: "SavedCustomMeditationDurationMinutes")
        let minimumTrackDurationMinutes = trackTemplateFactory.minimumTrackDuration / 60
        if (savedCustomMeditationDurationMinutes < minimumTrackDurationMinutes + 1) {
            savedCustomMeditationDurationMinutes = minimumTrackDurationMinutes + 1
            defaults.setValue(savedCustomMeditationDurationMinutes, forKey: "SavedCustomMeditationDurationMinutes")
        }
        self.user.customMeditationDurationMinutes = savedCustomMeditationDurationMinutes
    }
    
    public func playTrackAtLevel(trackLevel: Int, gapDuration: Int) -> (Bool) {
        
        if (self.activeTrack != nil) {
            self.activeTrack!.stop()
            self.activeTrack = nil
            self.activeTrackLevel = 0
        }
        
        if (self.user.isAllowedToAccessLevel(requestedLevel: trackLevel)) {
            self.activeTrackLevel = trackLevel
            let trackTemplate = trackTemplateFactory.trackTemplates[trackLevel]
            self.activeTrack = Track(trackTemplate: trackTemplate, gapDuration: gapDuration)
            self.activeTrack!.playFromBeginning()
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
    
    public func setDefaultDurationMinutes(durationMinutes: Int) {
        defaults.setValue(durationMinutes, forKey: "SavedCustomMeditationDurationMinutes")
        self.user.customMeditationDurationMinutes = durationMinutes
    }
    
}
