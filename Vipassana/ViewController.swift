//
//  ViewController.swift
//  Vipassana
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TrackDelegate {

    let vipassanaManager = VipassanaManager.shared
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var playPauseLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapDemoButton(_ sender: Any) {
        var returnVal = vipassanaManager.playTrackAtLevel(trackLevel: 1, gapDuration: 30)
        if (returnVal) {
            vipassanaManager.activeTrack?.delegate = self
            playPauseLabel.isHidden = false
        }
    }

    @IBAction func didTapPlayPause(_ sender: Any) {
        vipassanaManager.pauseOrResume()
    }
    
    func trackTimeRemainingUpdated(timeRemaining: Int) {
//        countdownLabel.text = String(timeRemaining)
        countdownLabel.text = "\(timeRemaining / 3600) : \((timeRemaining % 3600) / 60) : \((timeRemaining % 3600) % 60)"
    }

    func trackEnded() {
        vipassanaManager.userCompletedTrack()
        playPauseLabel.isHidden = true
    }
}

