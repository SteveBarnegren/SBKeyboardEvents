//
//  SBKeyboardEventsTests.swift
//  SBKeyboardEventsTests
//
//  Created by Steve Barnegren on 24/10/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import SBKeyboardEvents

class TestListener: KeyboardEventListener {
}

class SBKeyboardEventsTests: XCTestCase {
    
    func testAddingListenerAddsListener() {
        
        SBKeyboardEvents.removeAllListeners()
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 0)
        
        let listener = TestListener()
        SBKeyboardEvents.addListener(listener)
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 1)
    }
    
    func testDeallocatedListenersAreAddedAndRemoved() {
        
        SBKeyboardEvents.removeAllListeners()
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 0)
        
        var testListener: TestListener? = TestListener()
        SBKeyboardEvents.addListener(testListener!)
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 1)
        
        testListener = nil
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 0)
    }
    
    func testRemoveListenerRemovesListener() {
        
        SBKeyboardEvents.removeAllListeners()
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 0)
        
        let testListener = TestListener()
        SBKeyboardEvents.addListener(testListener)
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 1)
        
        SBKeyboardEvents.removeListener(testListener)
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 0)
    }
    
    func testRemoveListenerREmovesCorrectListener() {
        
        SBKeyboardEvents.removeAllListeners()
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 0)
        
        let firstListener = TestListener()
        SBKeyboardEvents.addListener(firstListener)
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 1)
        
        let secondListener = TestListener()
        SBKeyboardEvents.addListener(secondListener)
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 2)
        
        // Remove the first listener
        SBKeyboardEvents.removeListener(firstListener)
        
        // There should still be one listener
        XCTAssertEqual(SBKeyboardEvents.sharedInstance.listeners.count, 1)
    }
    
}
