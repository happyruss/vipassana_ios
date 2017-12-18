//
//  Track.swift
//  Vipassana
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import Foundation
import AVKit

protocol TrackDelegate: class {
    func trackTimeRemainingUpdated(timeRemaining: Int)
}

class Track {
    
    let name: String;
    var remainingTime = 0
    var isPaused = false
    var timer = Timer()
    
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
    
    weak var delegate: TrackDelegate?
    
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
        self.part1Duration = Int(CMTimeGetSeconds(self.part1Asset.duration));
        self.playerPart1 = AVPlayer(playerItem: part1Item)

        if (part2Url != nil) {
            self.part2Url = part2Url
            self.part2Asset = AVAsset(url: part2Url!)
            self.part2Duration = Int(CMTimeGetSeconds(self.part2Asset!.duration));
            self.part2Item = AVPlayerItem(asset: part2Asset!,
                                     automaticallyLoadedAssetKeys: assetKeys)
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
        self.remainingTime = self.totalDuration;
    }
    
    @objc func update() {
        self.remainingTime = self.remainingTime - 1
        delegate?.trackTimeRemainingUpdated(timeRemaining: self.remainingTime)

        if (self.totalDuration - self.remainingTime < self.part1Duration) {
            if (self.playerPart1.rate != 0 && self.playerPart1.error == nil) {
            } else {
                self.playerPart1.play()
            }
        }
        
        guard self.remainingTime > 0 else {
            return
        }
        guard self.part2Duration != nil else {
            return
        }
        guard self.remainingTime < (self.part2Duration! + 3) else {
            return
        }
        
        if (self.playerPart2!.rate != 0 && self.playerPart2!.error == nil) {
        } else {
            self.playerPart2?.play()
        }
    }
    
    public func playFromBeginning() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        self.isPaused = false
        self.playerPart1.play()
    }
    
    func pause() {
        timer.invalidate()
        self.isPaused = true
        if (self.playerPart1.rate != 0 && self.playerPart1.error == nil) {
            self.playerPart1.pause()
        }
        if (self.playerPart2?.rate != 0 && self.playerPart2?.error == nil) {
            self.playerPart2!.pause()
        }
    }
    
    func resume() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        self.isPaused = false
    }

    public func stop() {
        self.remainingTime = self.totalDuration;
        self.isPaused = false
        timer.invalidate()
    }
    
    public func pauseOrResume() {
        if (self.isPaused) {
            self.resume()
        } else {
            self.pause()
        }
    }
    
}
