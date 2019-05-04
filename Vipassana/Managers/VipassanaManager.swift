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
    fileprivate var activeTrackLevel = 0
    fileprivate let defaults = UserDefaults()

    let trackTemplateFactory = TrackTemplateFactory.shared
    
    public init() {
        self.user = User()
        self.user.completedTrackLevel = defaults.integer(forKey: "SavedCompletedLevel")
        self.user.totalSecondsInMeditation = defaults.integer(forKey: "TotalSecondsInMeditation")
        var savedCustomMeditationDurationMinutes = defaults.integer(forKey: "SavedCustomMeditationDurationMinutes")
        let minimumTrackDurationMinutes = trackTemplateFactory.minimumTrackDuration / 60
        if (savedCustomMeditationDurationMinutes < minimumTrackDurationMinutes + 1) {
            savedCustomMeditationDurationMinutes = minimumTrackDurationMinutes + 1
            defaults.setValue(savedCustomMeditationDurationMinutes, forKey: "SavedCustomMeditationDurationMinutes")
        }
        self.user.customMeditationDurationMinutes = savedCustomMeditationDurationMinutes
    }
    
    public func playTrackAtLevel(trackLevel: Int, gapDuration: Int) {
        if (self.activeTrack != nil) {
            self.activeTrack!.stop()
            self.activeTrack = nil
            self.activeTrackLevel = 0
        }
        self.activeTrackLevel = trackLevel
        let trackTemplate = trackTemplateFactory.trackTemplates[trackLevel]
        self.activeTrack = Track(trackTemplate: trackTemplate, gapDuration: gapDuration)
        self.activeTrack!.playFromBeginning()
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
    
    private func setTrackCompletetion() {
        if (activeTrackLevel > self.user.completedTrackLevel) {
            self.user.completedTrackLevel = activeTrackLevel
            defaults.set(activeTrackLevel, forKey: "SavedCompletedLevel")
        }
    }

    public func userStartedTrack() {
        self.setTrackCompletetion()
    }

    public func userCompletedTrack() {
        self.setTrackCompletetion()
    }
    
    public func setDefaultDurationMinutes(durationMinutes: Int) {
        defaults.setValue(durationMinutes, forKey: "SavedCustomMeditationDurationMinutes")
        self.user.customMeditationDurationMinutes = durationMinutes
    }
    
    public func incrementTotalSecondsInMeditation() {
        self.user.totalSecondsInMeditation = self.user.totalSecondsInMeditation + 1
        defaults.setValue(self.user.totalSecondsInMeditation, forKey: "TotalSecondsInMeditation")
    }
    
}
