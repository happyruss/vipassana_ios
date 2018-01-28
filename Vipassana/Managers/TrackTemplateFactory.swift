//
//  VipassanaManager.swift
//  Vipassana
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import Foundation

class TrackTemplateFactory {
    
    public static var shared = TrackTemplateFactory()

    let appName = "Vipassana"
    let requireMeditationsBeDoneInOrder = true
    let appUrl = "http://www.guidedmeditationtreks.com/vipassana"
    
    var trackTemplates = [TrackTemplate]()
    var minimumTrackDuration = 0
    
    public init() {

        trackTemplates.append(TrackTemplate(shortName: "Timer", name: "Timer", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "IntroBell", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "ClosingBell", ofType: "m4a")!)))
        
        trackTemplates.append(TrackTemplate(shortName: "Introduction", name: "Introduction", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "Introduction", ofType: "m4a")!), part2Url: nil))

        trackTemplates.append(TrackTemplate(shortName: "Shamatha", name: "Shamatha", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "01_Shamatha", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "01_Shamatha2", ofType: "m4a")!)))

        trackTemplates.append(TrackTemplate(shortName: "Anapana", name: "Anapana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "02_Anapana", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "02_Anapana2", ofType: "m4a")!)))

        trackTemplates.append(TrackTemplate(shortName: "Focused Anapana", name: "Focused Anapana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "03_FocusedAnapana", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "03_FocusedAnapana2", ofType: "m4a")!)))

        trackTemplates.append(TrackTemplate(shortName: "Vipassana", name: "Top To Bottom Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "04_TopToBottom", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "04_TopToBottom2", ofType: "m4a")!)))

        trackTemplates.append(TrackTemplate(shortName: "Scanning Vipassana", name: "Part By Part Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "05_TopToBottomBottomToTop", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "05_TopToBottomBottomToTop2", ofType: "m4a")!)))

        trackTemplates.append(TrackTemplate(shortName: "Symmetrical Vipassana", name: "Symmetrical Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "06_Symmetrical", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "06_Symmetrical2", ofType: "m4a")!)))

        trackTemplates.append(TrackTemplate(shortName: "Sweeping Vipassana", name: "Sweeping Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "07_Sweeping", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "07_Sweeping2", ofType: "m4a")!)))

        trackTemplates.append(TrackTemplate(shortName: "Piercing Vipassana", name: "In the Moment Vipassana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "08_InTheMoment", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "08_InTheMoment2", ofType: "m4a")!)))

        trackTemplates.append(TrackTemplate(shortName: "Metta", name: "Metta", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "MetaPana", ofType: "m4a")!), part2Url: nil))

        trackTemplates.forEach { (trackTemplate) in
            if(trackTemplate.minimumDuration > minimumTrackDuration) {
                minimumTrackDuration = trackTemplate.minimumDuration
            }
        }
    }
    
}

