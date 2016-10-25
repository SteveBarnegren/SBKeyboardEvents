import UIKit
import XCTest
@testable import SBKeyboardEvents

class TestListener: KeyboardEventListener {
    
    init() {
        SBKeyboardEvents.addListener(self)
    }
}

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeallocatedListenersAreAddedAndRemoved() {
    
        XCTAssert(SBKeyboardEvents.sharedInstance.listeners.count == 0, "There should be no listeners yet")
        
        var testListener: TestListener? = TestListener()
    
        XCTAssert(SBKeyboardEvents.sharedInstance.listeners.count == 1, "Expected 1 listener")

        testListener = nil
        
        XCTAssert(SBKeyboardEvents.sharedInstance.listeners.count == 0, "Expected 0 listeners")

    }
    
    
}
