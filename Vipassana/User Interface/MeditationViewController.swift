//
//  MeditationViewController.swift
//  Vipassana
//
//  Created by Mr Russell on 1/21/18.
//  Copyright © 2018 Russell Eric Dobda. All rights reserved.
//

import UIKit

class MeditationViewController: UIViewController, TrackDelegate {
    
    let vipassanaManager = VipassanaManager.shared
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var meditationNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    private var isInMeditation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playPauseButton.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func runMeditation(trackLevel: Int, totalDurationSeconds: Int) {
        let trackTemplate = vipassanaManager.trackTemplateFactory.trackTemplates[trackLevel]
        let gapDuration = totalDurationSeconds - trackTemplate.minimumDuration
        meditationNameLabel.text = trackTemplate.name
        vipassanaManager.playTrackAtLevel(trackLevel: trackLevel, gapDuration: gapDuration)
        vipassanaManager.activeTrack?.delegate = self
        playPauseButton.isHidden = false
        isInMeditation = true
    }
    
    @IBAction func didTapPlayPause(_ sender: Any) {
        vipassanaManager.pauseOrResume()
    }
    
    func goBackToMainScreen() {
        self.vipassanaManager.stop()
        self.dismiss(animated: true) {
            self.vipassanaManager.activeTrack?.delegate = nil
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        if (isInMeditation) {
            let alert = UIAlertController(title: "Meditation Underway", message: "Would you like to stop the current session?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                self.goBackToMainScreen()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            goBackToMainScreen()
        }
    }

    
    func trackTimeRemainingUpdated(timeRemaining: Int) {
        vipassanaManager.incrementTotalSecondsInMeditation()
        countdownLabel.text = String(format: "%d", arguments: [(timeRemaining / 60)]) + ":" + String(format: "%02d", arguments: [((timeRemaining % 3600) % 60)])
    }
    
    func trackEnded() {
        vipassanaManager.userCompletedTrack()
        playPauseButton.isHidden = true
        isInMeditation = false
    }
}
