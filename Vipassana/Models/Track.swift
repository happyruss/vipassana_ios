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
    func trackEnded()
}

class Track {
    
    fileprivate var remainingTime = 0
    fileprivate var isPaused = false
    fileprivate var timer = Timer()
    
    fileprivate let trackTemplate: TrackTemplate
    
    fileprivate let part1Item: AVPlayerItem
    fileprivate let playerPart1: AVPlayer
    fileprivate let gapDuration: Int
    fileprivate let totalDuration: Int

    fileprivate let part2Item: AVPlayerItem?
    fileprivate let playerPart2: AVPlayer?
    
    weak var delegate: TrackDelegate?
    
    init(trackTemplate: TrackTemplate, gapDuration: Int?) {
        self.trackTemplate = trackTemplate
        
        //initialize the audio files
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]

        self.part1Item = AVPlayerItem(asset: trackTemplate.part1Asset,
                                 automaticallyLoadedAssetKeys: assetKeys)
        self.playerPart1 = AVPlayer(playerItem: part1Item)

        if (self.trackTemplate.part2Url != nil) {
            self.part2Item = AVPlayerItem(asset: trackTemplate.part2Asset!,
                                     automaticallyLoadedAssetKeys: assetKeys)
            self.playerPart2 = AVPlayer(playerItem: part2Item!)
            self.gapDuration = gapDuration!
            self.totalDuration = self.gapDuration + self.trackTemplate.part1Duration + self.trackTemplate.part2Duration!
        } else {
            self.part2Item = nil;
            self.playerPart2 = nil;
            self.gapDuration = 0
            self.totalDuration = self.trackTemplate.part1Duration
        }
        self.remainingTime = self.totalDuration;
    }
    
    @objc func update() {
        self.remainingTime = self.remainingTime - 1
        delegate?.trackTimeRemainingUpdated(timeRemaining: self.remainingTime)
        
        guard self.remainingTime > 0 else {
            delegate?.trackEnded()
            return
        }

        if (self.totalDuration - self.remainingTime < self.trackTemplate.part1Duration) {
            if (self.playerPart1.rate != 0 && self.playerPart1.error == nil) {
            } else {
                self.playerPart1.play()
            }
        }
        
        guard self.remainingTime > 0 else {
            return
        }
        guard self.trackTemplate.part2Duration != nil else {
            return
        }
        guard self.remainingTime < (self.trackTemplate.part2Duration! + 1) else {
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
