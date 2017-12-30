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
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var introButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var shamathaButton: UIButton!
    @IBOutlet weak var anapanaButton: UIButton!
    @IBOutlet weak var focusedAnapanaButton: UIButton!
    @IBOutlet weak var topToBottomVipassanaButton: UIButton!
    @IBOutlet weak var sweepingVipassanaButton: UIButton!
    @IBOutlet weak var symmetricalVipassanaButton: UIButton!
    @IBOutlet weak var scanningVipassanaButton: UIButton!
    @IBOutlet weak var inTheMomentVipassanaButton: UIButton!
    @IBOutlet weak var mettaButton: UIButton!
    
    private var isInMeditation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playPauseButton.isHidden = true
        self.secureButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func secureButtons() {
        let enabledLevel = vipassanaManager.user.completedTrackLevel + 1
        introButton.isEnabled = true
        timerButton.isEnabled = true
        shamathaButton.isEnabled = enabledLevel >= 1
        anapanaButton.isEnabled = enabledLevel >= 2
        focusedAnapanaButton.isEnabled = enabledLevel >= 3
        topToBottomVipassanaButton.isEnabled = enabledLevel >= 4
        scanningVipassanaButton.isEnabled = enabledLevel >= 5
        symmetricalVipassanaButton.isEnabled = enabledLevel >= 6
        sweepingVipassanaButton.isEnabled = enabledLevel >= 7
        inTheMomentVipassanaButton.isEnabled = enabledLevel >= 8
        mettaButton.isEnabled = enabledLevel >= 9
    }
    
    func runMeditation(trackLevel: Int, totalDurationSeconds: Int) {
        let trackTemplate = vipassanaManager.trackTemplateFactory.trackTemplates[trackLevel]
        let gapDuration = totalDurationSeconds - trackTemplate.minimumDuration
        vipassanaManager.playTrackAtLevel(trackLevel: trackLevel, gapDuration: gapDuration)
        vipassanaManager.activeTrack?.delegate = self
        playPauseButton.isHidden = false
        isInMeditation = true
    }
    
    fileprivate func presentInvalidCustomCountdownAlert(trackLevel: Int, minDurationMinutes: Int) {
        let alert = UIAlertController(title: "Meditate", message: "Length for this meditation must be at least \(minDurationMinutes) minutes.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.presentCustomCountdownAlert(trackLevel: trackLevel, minDurationMinutes: minDurationMinutes)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            self.presentCustomCountdownAlert(trackLevel: trackLevel, minDurationMinutes: minDurationMinutes)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func presentCustomCountdownAlert(trackLevel: Int, minDurationMinutes: Int) {
        let alert2 = UIAlertController(title: "Meditate", message: "Enter a meditation length", preferredStyle: UIAlertControllerStyle.alert)
        alert2.addTextField { (textField) in
            textField.placeholder = "\(self.vipassanaManager.user.customMeditationDurationMinutes)"
            textField.keyboardType = .numberPad
        }
        alert2.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { action in
            let value = alert2.textFields?[0].text
            guard value != nil else {
                self.presentInvalidCustomCountdownAlert(trackLevel: trackLevel, minDurationMinutes: minDurationMinutes)
                return
            }
            if let durationMinutes = Int(value!) {
                if (minDurationMinutes > durationMinutes) {
                    self.presentInvalidCustomCountdownAlert(trackLevel: trackLevel, minDurationMinutes: minDurationMinutes)
                } else {
                    self.vipassanaManager.setDefaultDurationMinutes(durationMinutes: durationMinutes)
                    self.runMeditation(trackLevel: trackLevel, totalDurationSeconds: durationMinutes * 60)
                }
            } else {
                self.presentInvalidCustomCountdownAlert(trackLevel: trackLevel, minDurationMinutes: minDurationMinutes)
            }
        }))
        self.present(alert2, animated: true, completion: nil)
    }
    
    fileprivate func presentCountdownLengthAlert(_ trackLevel: Int) {
        let trackTemplate = vipassanaManager.trackTemplateFactory.trackTemplates[trackLevel]
        let minDurationSeconds = trackTemplate.minimumDuration
        let minDurationMinutes = minDurationSeconds / 60 + 2

        if !trackTemplate.isMultiPart {
            self.runMeditation(trackLevel: trackLevel, totalDurationSeconds: minDurationSeconds)
        } else {
            
            let alert = UIAlertController(title: "Meditate", message: "Select a meditation length", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "\(minDurationMinutes) Minutes", style: UIAlertActionStyle.default, handler: { action in
                self.runMeditation(trackLevel: trackLevel, totalDurationSeconds: minDurationMinutes * 60)
            }))
            alert.addAction(UIAlertAction(title: "60 Minutes", style: UIAlertActionStyle.default, handler: { action in
                self.runMeditation(trackLevel: trackLevel, totalDurationSeconds: 60 * 60)
            }))
            
            if (self.vipassanaManager.user.customMeditationDurationMinutes > minDurationMinutes) {
                alert.addAction(UIAlertAction(title: "\(self.vipassanaManager.user.customMeditationDurationMinutes) Minutes", style: UIAlertActionStyle.destructive, handler: { action in
                    self.runMeditation(trackLevel: trackLevel, totalDurationSeconds: self.vipassanaManager.user.customMeditationDurationMinutes * 60)
                }))
            }
            alert.addAction(UIAlertAction(title: "Custom Time", style: UIAlertActionStyle.cancel, handler: { action in
                self.presentCustomCountdownAlert(trackLevel: trackLevel, minDurationMinutes: minDurationMinutes)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func presentAlerts(_ trackLevel: Int) {
        if (isInMeditation) {
            let alert = UIAlertController(title: "Meditation Underway", message: "Would you like to stop the current session?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                self.presentCountdownLengthAlert(trackLevel)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            presentCountdownLengthAlert(trackLevel)
        }
    }
    
    @IBAction func didTapMeditationButton(_ sender: UIButton) {
        let trackLevel = sender.tag
        presentAlerts(trackLevel)
    }

    @IBAction func didTapPlayPause(_ sender: Any) {
        vipassanaManager.pauseOrResume()
    }
    
    func trackTimeRemainingUpdated(timeRemaining: Int) {
        countdownLabel.text = String(format: "%02d", arguments: [(timeRemaining / 60)]) + ":" + String(format: "%02d", arguments: [((timeRemaining % 3600) % 60)])
    }

    func trackEnded() {
        vipassanaManager.userCompletedTrack()
        playPauseButton.isHidden = true
        isInMeditation = false
        secureButtons()
    }
}

