//
//  Track.swift
//  Vipassana
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import Foundation
import AVKit

class Track {
    
    let name: String;
    var currentPosition = 0
    var isPaused = false
    
    let part1Duration: Int
    let part1Url: URL
    let part1Asset: AVAsset
    let part1Item: AVPlayerItem
    let playerPart1: AVPlayer
    let gapDuration: Int
    let totalDuration: Int

    let part2Duration: Int?
    let part2Url: URL?
    let part2Asset: AVAsset?
    let part2Item: AVPlayerItem?
    let playerPart2: AVPlayer?
    
    init(name: String, part1Url: URL, part2Url: URL?, gapDuration: Int?) {
        self.name = name
        self.part1Url = part1Url
        
        //initialize the audio files
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]

        self.part1Asset = AVAsset(url: part1Url)
        self.part1Item = AVPlayerItem(asset: part1Asset,
                                 automaticallyLoadedAssetKeys: assetKeys)
        self.part1Duration = Int(self.part1Item.duration.seconds)
        //        part1Item.addObserver(self,
        //                               forKeyPath: #keyPath(AVPlayerItem.status),
        //                               options: [.old, .new],
        //                               context: &playerItemContext)
        self.playerPart1 = AVPlayer(playerItem: part1Item)

        if (part2Url != nil) {
            self.part2Url = part2Url
            self.part2Asset = AVAsset(url: part2Url!)
            self.part2Duration = Int(part2Asset!.duration.seconds)
            self.part2Item = AVPlayerItem(asset: part2Asset!,
                                     automaticallyLoadedAssetKeys: assetKeys)
            //        part2Item.addObserver(self,
            //                              forKeyPath: #keyPath(AVPlayerItem.status),
            //                              options: [.old, .new],
            //                              context: &playerItemContext)
            self.playerPart2 = AVPlayer(playerItem: part2Item!)
            self.gapDuration = gapDuration!
            self.totalDuration = self.gapDuration + self.part1Duration + self.part2Duration!
        } else {
            self.part2Duration = nil
            self.part2Url = nil
            self.part2Asset = nil;
            self.part2Item = nil;
            self.playerPart2 = nil;
            self.gapDuration = 0
            self.totalDuration = self.part1Duration
        }
    }
    
    public func playFromBeginning() {
        self.isPaused = false
    }
    
    func pause() {
        self.isPaused = true
    }
    
    func resume() {
        self.isPaused = false
    }

    public func stop() {
        currentPosition = 0;
        self.isPaused = false
    }
    
    public func pauseOrResume() {
        if (self.isPaused) {
            self.resume()
        } else {
            self.pause()
        }
    }
    
}
