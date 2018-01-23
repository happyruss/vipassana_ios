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
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var introDoneImageView: UIImageView!
    @IBOutlet weak var dots2ImageView: UIImageView!
    @IBOutlet weak var dots3ImageView: UIImageView!
    @IBOutlet weak var dots4ImageView: UIImageView!
    @IBOutlet weak var dots5ImageView: UIImageView!
    @IBOutlet weak var dots6ImageView: UIImageView!
    @IBOutlet weak var dots7ImageView: UIImageView!
    @IBOutlet weak var dots8ImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.clipsToBounds = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let medHours = vipassanaManager.user.totalSecondsInMeditation / 3600
        totalMeditationTimeLabel.text = medHours == 1 ? "\(medHours) hour spent meditating" : "\(medHours) hours spent meditating"
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
        introDoneImageView.image = enabledLevel > 1 ? #imageLiteral(resourceName: "dots") : #imageLiteral(resourceName: "dots copy")
        anapanaButton.isEnabled = enabledLevel > 2
        dots2ImageView.image = enabledLevel > 2 ? #imageLiteral(resourceName: "dots") : #imageLiteral(resourceName: "dots copy")
        focusedAnapanaButton.isEnabled = enabledLevel > 3
        dots3ImageView.image = enabledLevel > 3 ? #imageLiteral(resourceName: "dots") : #imageLiteral(resourceName: "dots copy")
        topToBottomVipassanaButton.isEnabled = enabledLevel > 4
        dots4ImageView.image = enabledLevel > 4 ? #imageLiteral(resourceName: "dots") : #imageLiteral(resourceName: "dots copy")
        scanningVipassanaButton.isEnabled = enabledLevel > 5
        dots5ImageView.image = enabledLevel > 5 ? #imageLiteral(resourceName: "dots") : #imageLiteral(resourceName: "dots copy")
        symmetricalVipassanaButton.isEnabled = enabledLevel > 6
        dots6ImageView.image = enabledLevel > 6 ? #imageLiteral(resourceName: "dots") : #imageLiteral(resourceName: "dots copy")
        sweepingVipassanaButton.isEnabled = enabledLevel > 7
        dots7ImageView.image = enabledLevel > 7 ? #imageLiteral(resourceName: "dots") : #imageLiteral(resourceName: "dots copy")
        inTheMomentVipassanaButton.isEnabled = enabledLevel > 8
        dots8ImageView.image = enabledLevel > 8 ? #imageLiteral(resourceName: "dots") : #imageLiteral(resourceName: "dots copy")
        mettaButton.isEnabled = enabledLevel > 9
        
        var contentOffset:CGPoint
        switch enabledLevel {
        case 0:
            contentOffset = introButton.frame.origin
            break;
        case 1:
            contentOffset = introDoneImageView.frame.origin
            break;
        case 2:
            contentOffset = dots2ImageView.frame.origin
            break;
        case 3:
            contentOffset = dots3ImageView.frame.origin
            break;
        case 4:
            contentOffset = dots4ImageView.frame.origin
            break;
        case 5:
            contentOffset = dots5ImageView.frame.origin
            break;
        case 6:
            contentOffset = dots6ImageView.frame.origin
            break;
        case 7:
            contentOffset = dots7ImageView.frame.origin
            break;
        case 8:
            contentOffset = dots8ImageView.frame.origin
            break;
        case 9, 10:
            contentOffset = mettaButton.frame.origin
            break;
        default:
            contentOffset = introButton.frame.origin
            break;
        }
        let bottomOffset = CGPoint(x:0, y:self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
        if (contentOffset.y > bottomOffset.y) {
            contentOffset = bottomOffset
        }
        scrollView.setContentOffset(contentOffset, animated: true)
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

