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
    
    func runMeditation(trackLevel: Int, totalDurationSeconds: Int) {
        let trackTemplate = vipassanaManager.trackTemplateFactory.trackTemplates[trackLevel]
        let gapDuration = totalDurationSeconds - trackTemplate.minimumDuration
        let returnVal = vipassanaManager.playTrackAtLevel(trackLevel: trackLevel, gapDuration: gapDuration)
        if (returnVal) {
            vipassanaManager.activeTrack?.delegate = self
            playPauseLabel.isHidden = false
        }
    }
    
    fileprivate func presentCustomCountdownAlert(_ trackLevel: Int) {
        let alert2 = UIAlertController(title: "Meditate", message: "Enter a meditation length", preferredStyle: UIAlertControllerStyle.alert)
        alert2.addTextField { (textField) in
            textField.placeholder = "\(self.vipassanaManager.user.customMeditationDurationMinutes)"
            textField.keyboardType = .numberPad
        }
        alert2.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { action in
            let value = alert2.textFields?[0].text
            guard value != nil else {
                return
            }
            if let durationMinutes = Int(value!) {
                self.vipassanaManager.setDefaultDurationMinutes(durationMinutes: durationMinutes)
                self.runMeditation(trackLevel: trackLevel, totalDurationSeconds: durationMinutes * 60)
            }
        }))
        self.present(alert2, animated: true, completion: nil)
    }
    
    fileprivate func presentCountdownLengthAlert(_ trackLevel: Int) {
        let alert = UIAlertController(title: "Meditate", message: "Select a meditation length", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "25 Minutes", style: UIAlertActionStyle.default, handler: { action in
            self.runMeditation(trackLevel: trackLevel, totalDurationSeconds: 25 * 60)
        }))
        alert.addAction(UIAlertAction(title: "60 Minutes", style: UIAlertActionStyle.default, handler: { action in
            self.runMeditation(trackLevel: trackLevel, totalDurationSeconds: 60 * 60)
        }))
        alert.addAction(UIAlertAction(title: "\(self.vipassanaManager.user.customMeditationDurationMinutes) Minutes", style: UIAlertActionStyle.destructive, handler: { action in
            self.runMeditation(trackLevel: trackLevel, totalDurationSeconds: self.vipassanaManager.user.customMeditationDurationMinutes * 60)
        }))
        alert.addAction(UIAlertAction(title: "Custom Time", style: UIAlertActionStyle.cancel, handler: { action in
            self.presentCustomCountdownAlert(trackLevel)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapDemoButton(_ sender: Any) {
        let trackLevel = 1
        presentCountdownLengthAlert(trackLevel)
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

