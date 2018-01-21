//
//  ViewController.swift
//  Vipassana
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let vipassanaManager = VipassanaManager.shared
    
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
    @IBOutlet weak var totalMeditationTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        totalMeditationTimeLabel.text = "\(vipassanaManager.user.totalSecondsInMeditation / 3600) hours spent meditating"
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
        shamathaButton.isEnabled = enabledLevel > 1
        anapanaButton.isEnabled = enabledLevel > 2
        focusedAnapanaButton.isEnabled = enabledLevel > 3
        topToBottomVipassanaButton.isEnabled = enabledLevel > 4
        scanningVipassanaButton.isEnabled = enabledLevel > 5
        symmetricalVipassanaButton.isEnabled = enabledLevel > 6
        sweepingVipassanaButton.isEnabled = enabledLevel > 7
        inTheMomentVipassanaButton.isEnabled = enabledLevel > 8
        mettaButton.isEnabled = enabledLevel > 9
    }
    
    func runMeditation(trackLevel: Int, totalDurationSeconds: Int) {
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeditationViewController") as! MeditationViewController
        self.present(mvc, animated: true) {
        }
        mvc.runMeditation(trackLevel: trackLevel, totalDurationSeconds: totalDurationSeconds)

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
    
    @IBAction func didTapMeditationButton(_ sender: UIButton) {
        let trackLevel = sender.tag
        presentCountdownLengthAlert(trackLevel)
    }
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "http://www.guidedmeditationtreks.com/vipassana")!)
    }

}

