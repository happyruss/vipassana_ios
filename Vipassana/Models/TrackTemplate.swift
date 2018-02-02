//
//  Track.swift
//  Vipassana
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import Foundation
import AVKit

class TrackTemplate {
    
    let shortName: String;
    let name: String;
    fileprivate let part1Url: URL
    let part1Duration: Int
    let part1Asset: AVAsset
    
    fileprivate let part2Url: URL?
    let part2Duration: Int?
    let part2Asset: AVAsset?

    let minimumDuration: Int
    
    let isMultiPart: Bool
    
    init(shortName: String, name: String, part1Url: URL, part2Url: URL?) {
        self.shortName = shortName
        self.name = name
        self.part1Url = part1Url
                
        self.part1Asset = AVAsset(url: part1Url)
        self.part1Duration = Int(CMTimeGetSeconds(self.part1Asset.duration));
        
        if (part2Url != nil) {
            self.part2Url = part2Url
            self.part2Asset = AVAsset(url: part2Url!)
            self.part2Duration = Int(CMTimeGetSeconds(self.part2Asset!.duration));
            self.minimumDuration = self.part1Duration + self.part2Duration!
            self.isMultiPart = true
        } else {
            self.part2Duration = nil
            self.part2Url = nil
            self.part2Asset = nil;
            self.minimumDuration = self.part1Duration
            self.isMultiPart = false
        }
    }
    
}

