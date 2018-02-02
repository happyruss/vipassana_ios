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
    let trackTemplateFactory = TrackTemplateFactory.shared
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var totalMeditationTimeLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.clipsToBounds = true

        self.titleLabel.text = trackTemplateFactory.appName
        let trackCount = trackTemplateFactory.trackTemplates.count
        
        for i in 1...trackCount - 1 {
            let trackTemplate = trackTemplateFactory.trackTemplates[i]
            let button = VipassanaButton()
            button.tag = i
            button.setTitle(trackTemplate.shortName, for: .normal)
            button.addTarget(self, action: #selector(self.didTapMeditationButton(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            if (i < trackCount - 1) {
                let dots = UIImageView()
                dots.contentMode = .scaleAspectFit
                dots.tag = i + 100
                dots.image = #imageLiteral(resourceName: "dots")
                dots.sizeToFit()
                stackView.addArrangedSubview(dots)
            }
            button.sizeToFit()
            
            if i == 1 {
                let firstDots = view.viewWithTag(101) as UIView?
                
                let heightOfAButton = button.frame.size.height
                let heightOfDots = firstDots?.frame.size.height ?? 0
                
                let heightOfAnItem = heightOfAButton + heightOfDots + 20
                let stackViewHeight = heightOfAnItem * CGFloat(trackTemplateFactory.trackTemplates.count)
                
                for constraint in stackView.constraints {
                    if constraint.identifier == "stackViewHeightConstraint" {
                        constraint.constant = stackViewHeight
                    }
                }
                
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
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
        let alwaysEnable = !trackTemplateFactory.requireMeditationsBeDoneInOrder
        let totalTrackCount = trackTemplateFactory.trackTemplates.count
        
        timerButton.isEnabled = true

        var contentOffset = CGPoint(x:0, y:0)

        for i in 1...totalTrackCount - 1 {
            let isNotLastTrack = i < totalTrackCount - 1
            let button = view.viewWithTag(i) as! UIButton
            button.isEnabled = alwaysEnable || enabledLevel > i - 1
            if isNotLastTrack {
                let dots = view.viewWithTag(i + 100) as! UIImageView
                dots.image = alwaysEnable || enabledLevel > i - 1 ? #imageLiteral(resourceName: "dots") : #imageLiteral(resourceName: "dots copy")
                if enabledLevel == i + 1 {
                    contentOffset = dots.frame.origin
                }
            } else if enabledLevel == totalTrackCount {
                contentOffset = button.frame.origin
            }
        }

        if (alwaysEnable) {
            contentOffset = CGPoint(x:0, y:0)
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
    
    @objc func didTapMeditationButton(_ sender: UIButton) {
        let trackLevel = sender.tag
        presentCountdownLengthAlert(trackLevel)
    }
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: trackTemplateFactory.appUrl)!)
    }

}

