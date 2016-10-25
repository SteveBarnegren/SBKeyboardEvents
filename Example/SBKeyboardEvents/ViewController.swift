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
        
        SBKeyboardEvents.addListener(self)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapAway))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func tapAway() {
        
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
}

extension ViewController: KeyboardEventListener{

    func animateForKeyboardHeight(_ height: CGFloat) {
        
        let margin = CGFloat(8.0)
        textFieldBottomConstraint.constant = height + margin
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}
