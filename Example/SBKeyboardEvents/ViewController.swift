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
        
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
}

extension ViewController: SBKeyboardEventsListener{
    
    func keyboardWillAppear() {
        print("ViewController: Keyboard Will Appear")
    }
    
    func keyboardDidAppear(){
        print("ViewController: Keyboard Did Appear")
    }
    
    func keyboardWillHide(){
        print("ViewController: Keyboard will hide")
    }
    
    func keyboardDidHide() {
        print("ViewController: Keyboard did hide")
    }
    
    func keyboardWillChangeFrame(frame: CGRect) {
        print("ViewController: Keyboard will change frame")
        print("Frame: \(frame)")
        
//        let margin: CGFloat = 8.0
//        textFieldBottomConstraint.constant = UIScreen.mainScreen().bounds.size.height - frame.origin.y + margin;
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
        
    }
    
    func animateForKeyboardHeight(height: CGFloat) {
        
        let margin: CGFloat = 8.0
        textFieldBottomConstraint.constant = height + margin
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}
