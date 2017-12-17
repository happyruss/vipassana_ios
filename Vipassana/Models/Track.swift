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
    
    //General Properties
    var name: String;
    var part1Length: Int
    var part1Url: URL
    var part2Length: Int?
    var part2Url: URL?
    
    var part1Asset: AVAsset
    var part2Asset: AVAsset?
    
    //Tracks accessibility
    var isEnabled: Bool
    
    let part1Item: AVPlayerItem
    let part2Item: AVPlayerItem?

    let playerPart1: AVPlayer
    let playerPart2: AVPlayer?
    
    init(name: String, part1Length: Int, part1Url: URL, part2Length: Int?, part2Url: URL?) {
        self.name = name
        self.part1Length = part1Length
        self.part1Url = part1Url
        self.part2Length = part2Length
        self.part2Url = part2Url

        self.isEnabled = false
        
        //initialize the audio files
        part1Asset = AVAsset(url: part1Url)
        if (part2Url != nil) {
            part2Asset = AVAsset(url: part2Url!)
        }

        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        
        part1Item = AVPlayerItem(asset: part1Asset,
                                  automaticallyLoadedAssetKeys: assetKeys)
        
        if (part2Asset != nil) {
            part2Item = AVPlayerItem(asset: part2Asset!,
                                     automaticallyLoadedAssetKeys: assetKeys)
        }

//        part1Item.addObserver(self,
//                               forKeyPath: #keyPath(AVPlayerItem.status),
//                               options: [.old, .new],
//                               context: &playerItemContext)
//        part2Item.addObserver(self,
//                              forKeyPath: #keyPath(AVPlayerItem.status),
//                              options: [.old, .new],
//                              context: &playerItemContext)
        
        playerPart1 = AVPlayer(playerItem: part1Item)
        if (part2Item != nil) {
            playerPart2 = AVPlayer(playerItem: part2Item!)
        }
    }
    
}
