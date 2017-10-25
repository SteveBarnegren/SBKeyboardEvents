//
//  ViewController.swift
//  SBKeyboardEvents
//
//  Created by Steve Barnegren on 06/20/2016.
//  Copyright (c) 2016 Steve Barnegren. All rights reserved.
//

import UIKit
import SBKeyboardEvents

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style text field
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // Add a tap gesture recognizer to dismiss the keyboard when tap away
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapAway))
        view.addGestureRecognizer(tapRecognizer)
        
        // Register for keyboard events
        SBKeyboardEvents.addListener(self)
    }
    
    @objc func tapAway() {
        
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
}

extension ViewController: KeyboardEventListener {

    func animateForKeyboardHeight(_ height: CGFloat) {
        
        let margin = CGFloat(8.0)
        textFieldBottomConstraint.constant = height + margin
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}
