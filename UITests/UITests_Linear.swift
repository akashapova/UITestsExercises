//
//  UITests.swift
//  UITests
//
//  Created by Альбина Кашапова on 1/29/21.
//

import XCTest

class UITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    //linear with hardcoded data
    
    func testNavigationBarExists() {
        XCTContext.runActivity(named: "Verifying NavigationBar Title") { _ in
            XCTAssert(app.navigationBars["Beginner"].waitForExistence(timeout: 3), "Title of the NavigationBar is not 'Beginner'")
        }
    }
    
    func testWhenViewLoaded_RequiredUIElementsAreEnabled() {
        
        XCTAssertTrue(app.segmentedControls.buttons["Beginner"].isEnabled)
        XCTAssertTrue(app.segmentedControls.buttons["Beginner"].isHittable)
        XCTAssertTrue(app.segmentedControls.buttons["Medium"].isEnabled)
        XCTAssertTrue(app.segmentedControls.buttons["Medium"].isHittable)
        XCTAssertTrue(app.segmentedControls.buttons["Hard"].isEnabled)
        XCTAssertTrue(app.segmentedControls.buttons["Hard"].isHittable)
        XCTAssertTrue(app.textFields["TextField"].isEnabled)
        XCTAssertTrue(app.buttons["PickPhoto"].isEnabled)
        XCTAssertTrue(app.buttons["PickPhoto"].isHittable)
        XCTAssertTrue(app.sliders.element.firstMatch.isEnabled)
        XCTAssertTrue(app.sliders.element.firstMatch.isHittable)
        XCTAssertTrue(app.switches.element.firstMatch.isEnabled)
        XCTAssertTrue(app.switches.element.firstMatch.isHittable)
        XCTAssertTrue(app.buttons["Save"].isEnabled)
        XCTAssertTrue(app.buttons["Save"].isHittable)
        XCTAssertTrue(app.buttons["Cancel"].isEnabled)
        XCTAssertTrue(app.buttons["Cancel"].isHittable)
    }
    
    func testStartingStateOfUIElements() {
        
        XCTAssertTrue(app.segmentedControls.buttons["Beginner"].isSelected)
        XCTAssertEqual(app.switches.firstMatch.value as? String, "1", "Switch is Off")

    }
    
    func testSegmentedControlChangesTitle() {

        app.segmentedControls.buttons["Medium"].tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Medium"].exists)
        
        app.segmentedControls.buttons["Hard"].tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Hard"].exists)
    
    }
    
    func testTypingTextUpdatesLabel() {
        //arrange, find TextField by Accessibility Identifier
        let textField = app.textFields["TextField"]
        //act
        textField.tap()
        textField.typeText("Albina")
        //assert
        XCTAssertEqual(app.staticTexts["WelcomeLabel"].label, "Welcome, Albina", "WelcomeLabel doesnt copy textField")
    }
        
    func testSliderUpdatesProgress() {
        
        //arrange & act
        app.sliders.element.firstMatch.adjust(toNormalizedSliderPosition:
        1)
        guard let progressValue = app.progressIndicators.element.firstMatch.value as? String else {
             XCTFail("The progress indicator cannot be found")
       return
       }
        //assert
          XCTAssertEqual(progressValue, "0%")
        
    }
    
    func testSwitchUpdatesLabel() {
            
        if app.switches.firstMatch.value as? String == "1" {
            app.switches.firstMatch.tap()
            XCTAssertEqual(app.staticTexts["MusicLabel"].label, "Music is OFF")
        } else {
            app.switches.firstMatch.tap()
            XCTAssertEqual(app.staticTexts["MusicLabel"].label, "Music is ON")
        }
    }
    
    func testButtonsShowAlerts() {
    
        app.buttons["Save"].tap()
        XCTAssertTrue(app.alerts["Do you want to save?"].exists)
        XCTAssertTrue(app.alerts["Do you want to save?"].isHittable)
        app.alerts["Do you want to save?"].buttons["OK"].tap()
        XCTAssertTrue(app.buttons["Save"].isHittable)
        
        app.buttons["Cancel"].tap()
        XCTAssertTrue(app.alerts["Cancel"].exists)
        XCTAssertTrue(app.alerts["Cancel"].isHittable)
        app.alerts["Cancel"].buttons["OK"].tap()
        XCTAssertTrue(app.buttons["Cancel"].isHittable)
    }
    
    func testPickingPhotoFromPhotos() {
        
        app.buttons["PickPhoto"].tap()
        
        XCTAssertTrue(app.navigationBars["Photos"].waitForExistence(timeout: 2))
        app.images["Photo, October 09, 2009, 2:09 PM"].tap()
    
        XCTAssertTrue(app.images.element.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["PickPhoto"].isHittable)
    }
    
    func testCancelPickingPhoto() {
        app.buttons["PickPhoto"].tap()
        XCTAssertTrue(app.navigationBars["Photos"].waitForExistence(timeout: 2))
        
        app.navigationBars.buttons["Cancel"].tap()
        
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: app.buttons["PickPhoto"])
        
        XCTWaiter().wait(for: [expectation], timeout: 5)
        XCTAssertTrue(app.buttons["PickPhoto"].isHittable)
    }
    
}
