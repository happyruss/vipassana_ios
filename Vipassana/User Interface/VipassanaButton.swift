//
//  VipassanaButton.swift
//  Vipassana
//
//  Created by Mr Russell on 1/21/18.
//  Copyright © 2018 Russell Eric Dobda. All rights reserved.
//

import UIKit

class VipassanaButton: UIButton {
    
    let minimalTitleSpinnerSpacing: CGFloat = 10
    let contentInsets = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
    
    var titleFont: UIFont = UIFont(name:UIFont.fontNames(forFamilyName: "Coffee Service")[0], size: 24)! {
        didSet {
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateTitleLabel()
        }
    }
    
    @IBInspectable
    var titleColor: UIColor {
        didSet {
        }
    }
    
    var underlineStyle: NSUnderlineStyle = NSUnderlineStyle.styleNone {
        didSet {
        }
    }
    
    var cornerRadius: CGFloat = 25 {
        didSet {
            updateCornerRadius()
        }
    }
    
    var shadowEnabled: Bool = false {
        didSet {
            updateShadow()
        }
    }
    
    var titleLabelHidden: Bool = false {
        didSet {
            updateTitleLabel()
        }
    }
    
    var kernValue: CGFloat = 1.3 {
        didSet {
            updateTitleLabel()
        }
    }
    
    init() {
        titleColor = UIColor.white
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 142.0/255.0, green: 125.0/255.0, blue: 97.0/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        titleColor = UIColor.white
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.updateCornerRadius()
        self.updateTitleLabel()
        self.updateShadow()
    }
        
    public func updateTitleText(text:String) {
        setTitle(text, for: .normal)
        updateTitleLabel()
    }
    
    private func updateShadow() {
        if shadowEnabled {
            self.layer.shadowOffset = CGSize(width:0.0, height:1.0)
            self.layer.shadowOpacity = 0.35
            self.layer.shadowRadius = 1.0
            self.layer.shadowColor = UIColor.black.cgColor
        }else{
            self.layer.shadowOffset = CGSize(width:0.0, height:0.0)
            self.layer.shadowOpacity = 0
            self.layer.shadowRadius = 0.0
            self.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = cornerRadius
    }
    
    private func updateTitleLabel() {
        let currentTitle:String = self.title(for: .normal) ?? ""
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        contentEdgeInsets = contentInsets
        titleLabel?.font = titleFont
        titleLabel?.baselineAdjustment = .none
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let foregroundColor: UIColor
        if (isEnabled) {
            backgroundColor = backgroundColor?.withAlphaComponent(1)
            foregroundColor = UIColor.white.withAlphaComponent(1)
            self.isOpaque = true
        } else {
            backgroundColor = backgroundColor?.withAlphaComponent(0.5)
            foregroundColor = UIColor.white.withAlphaComponent(0.5)
            self.isOpaque = false
        }

        let title = NSAttributedString(string: currentTitle, attributes: [
            NSAttributedStringKey.kern: kernValue,
            NSAttributedStringKey.foregroundColor: foregroundColor,
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.underlineStyle: underlineStyle.rawValue
            ])
        
        self.updateCornerRadius()
        self.updateShadow()
        
        UIView.setAnimationsEnabled(false)
        setAttributedTitle(title, for: .normal)
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
}
