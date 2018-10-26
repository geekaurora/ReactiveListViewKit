//
//  TestFeedList.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 10/25/18.
//  Copyright © 2018 Cheng Zhang. All rights reserved.
//

import XCTest

class FeedListUITest: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGameStyleSwitch() {
//        // given
//        let slideButton = app.segmentedControls.buttons["Slide"]
//        let typeButton = app.segmentedControls.buttons["Type"]
//        let slideLabel = app.staticTexts["Get as close as you can to: "]
//        let typeLabel = app.staticTexts["Guess where the slider is: "]
//
//        // then
//        if slideButton.isSelected {
//            XCTAssertTrue(slideLabel.exists)
//            XCTAssertFalse(typeLabel.exists)
//
//            typeButton.tap()
//            XCTAssertTrue(typeLabel.exists)
//            XCTAssertFalse(slideLabel.exists)
//        } else if typeButton.isSelected {
//            XCTAssertTrue(typeLabel.exists)
//            XCTAssertFalse(slideLabel.exists)
//
//            slideButton.tap()
//            XCTAssertTrue(slideLabel.exists)
//            XCTAssertFalse(typeLabel.exists)
//        }
    }
    
}

