//
//  UITests_POM.swift
//  UITests
//
//  Created by Альбина Кашапова on 1/30/21.
//

import XCTest

class UITests_POM: XCTestCase {
    
    private var app: XCUIApplication!
    enum WelcomeScreen: String {
        case textField = "TextField"
        case segmentedControlBeginner = "Beginner"
        case segmentedControlMedium = "Medium"
        case segmentedControlHard = "Hard"
        case welcomeLabel = "WelcomeLabel"
        case musicLabel = "MusicLabel"
        case pickPhoto = "PickPhoto"
        case save = "Save"
        case cancel = "Cancel"
        case switcher
        case slider
        case progressBar
        case image
        
    var element: XCUIElement {
    switch self {
        case .segmentedControlBeginner, .segmentedControlMedium, .segmentedControlHard:
            return XCUIApplication().segmentedControls.buttons[self.rawValue]
        case .textField:
            return XCUIApplication().textFields[self.rawValue]
        case .welcomeLabel, .musicLabel:
            return XCUIApplication().staticTexts[self.rawValue]
        case .pickPhoto, .save, .cancel:
            return XCUIApplication().buttons[self.rawValue]
        case .switcher:
            return XCUIApplication().switches.firstMatch
        case .slider:
            return XCUIApplication().sliders.firstMatch
        case .progressBar:
            return XCUIApplication().progressIndicators.firstMatch
        case .image:
            return XCUIApplication().images.firstMatch
        }
      }
    }

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
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testNavigationBarExists() {
        
        XCTContext.runActivity(named: "Verifying NavigationBar Title Exists") { _ in
            XCTAssert(WelcomeScreen.segmentedControlBeginner.element.waitForExistence(timeout: 3))
        }
    }
    
    func testWhenViewLoaded_RequiredUIElementsAreEnabled() {
        
        XCTContext.runActivity(named: "Verifying Required UIElements are Enabled and Hittable") { _ in
            XCTAssertTrue(WelcomeScreen.segmentedControlBeginner.element.isEnabled)
            XCTAssertTrue(WelcomeScreen.segmentedControlBeginner.element.isHittable)
            XCTAssertTrue(WelcomeScreen.segmentedControlMedium.element.isEnabled)
            XCTAssertTrue(WelcomeScreen.segmentedControlMedium.element.isHittable)
            XCTAssertTrue(WelcomeScreen.segmentedControlHard.element.isEnabled)
            XCTAssertTrue(WelcomeScreen.segmentedControlHard.element.isHittable)
            XCTAssertTrue(WelcomeScreen.textField.element.isEnabled)
            XCTAssertTrue(WelcomeScreen.pickPhoto.element.isEnabled)
            XCTAssertTrue(WelcomeScreen.pickPhoto.element.isHittable)
            XCTAssertTrue(WelcomeScreen.slider.element.isEnabled)
            XCTAssertTrue(WelcomeScreen.slider.element.isHittable)
            XCTAssertTrue(WelcomeScreen.switcher.element.isEnabled)
            XCTAssertTrue(WelcomeScreen.switcher.element.isHittable)
            XCTAssertTrue(WelcomeScreen.save.element.isEnabled)
            XCTAssertTrue(WelcomeScreen.save.element.isHittable)
            XCTAssertTrue(WelcomeScreen.cancel.element.isEnabled)
            XCTAssertTrue(WelcomeScreen.cancel.element.isHittable)
        }
    }
    
    
    func testInitialStateOfUIElements() {
        
        XCTContext.runActivity(named: "SegmentedControl is set to Beginner") { _ in
            XCTAssertTrue(WelcomeScreen.segmentedControlBeginner.element.isSelected)
        }
        
        XCTContext.runActivity(named: "Verifying Switch is On") { _ in
            XCTAssertEqual(WelcomeScreen.switcher.element.value as? String, "1", "Switch is Off")
        }
    }
    
    func testSegmentedControlChangesTitle() {
        
        XCTContext.runActivity(named: "SegmentedControl Medium Button Updates Navigation Title") { _ in
        WelcomeScreen.segmentedControlMedium.element.tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Medium"].exists)
        }
        
        XCTContext.runActivity(named: "SegmentedControl Hard Button Updates Navigation Title") { _ in
        WelcomeScreen.segmentedControlHard.element.tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Hard"].exists)
        }
        
    }
    
    func testTypingTextUpdatesLabel() {
        
        //arrange
        WelcomeScreen.textField.element.tap()
        
        let text = type(of: self)
        let bundle = Bundle(for: text.self)
        if let path = bundle.path(forResource: "testdata", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                //act
                XCTContext.runActivity(named: "Typing Name from testdata in textField") { _ in
                WelcomeScreen.textField.element.typeText("\(myStrings[0])")
                }
                
                //assert
                XCTContext.runActivity(named: "Verifying Welcome Label Updates") { _ in
                XCTAssertEqual(WelcomeScreen.welcomeLabel.element.label, "Welcome, \(myStrings[0])", "WelcomeLabel doesn't copy textField")
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
    
    func testSliderUpdatesProgress() {
        
        XCTContext.runActivity(named: "Adjusting slider to 100%") { _ in
        WelcomeScreen.slider.element.adjust(toNormalizedSliderPosition:
                                                1)
        }
        
        XCTContext.runActivity(named: "Verifying ProgressBar Updates to 0%") { _ in
        guard let progressValue = WelcomeScreen.progressBar.element.value as? String else {
            XCTFail("Progress indicator cannot be found")
            return
        }
        
        XCTAssertEqual(progressValue, "0%")
        }
    }
    
    func testSwitchUpdatesLabel() {
        
        if WelcomeScreen.switcher.element.value as? String == "1" {
            WelcomeScreen.switcher.element.tap()
            XCTAssertEqual(app.staticTexts["MusicLabel"].label, "Music is OFF")
        } else {
            WelcomeScreen.switcher.element.tap()
            XCTAssertEqual(app.staticTexts["MusicLabel"].label, "Music is ON")
        }
    }
    
    func testButtonsShowAlerts() {
        
        XCTContext.runActivity(named: "Save Button shows Alert") { _ in
        WelcomeScreen.save.element.tap()
        XCTAssertTrue(app.alerts["Do you want to save?"].exists)
        XCTAssertTrue(app.alerts["Do you want to save?"].isHittable)
        app.alerts["Do you want to save?"].buttons["OK"].tap()
        XCTAssertTrue(WelcomeScreen.save.element.isHittable)
        }
        
        XCTContext.runActivity(named: "Cancel Button shows Alert") { _ in
        WelcomeScreen.cancel.element.tap()
        XCTAssertTrue(app.alerts["Cancel"].exists)
        XCTAssertTrue(app.alerts["Cancel"].isHittable)
        app.alerts["Cancel"].buttons["OK"].tap()
        XCTAssertTrue(WelcomeScreen.cancel.element.isHittable)
        }
    }
    
    func testPickingPhotoFromPhotos() {
        
        WelcomeScreen.pickPhoto.element.tap()
        
        XCTAssertTrue(app.navigationBars["Photos"].waitForExistence(timeout: 2))
        app.images["Photo, October 09, 2009, 2:09 PM"].tap()
        XCTAssertTrue(WelcomeScreen.image.element.waitForExistence(timeout: 5))
        XCTAssertTrue(WelcomeScreen.pickPhoto.element.isHittable)
    }
    
    func testCancelPickingPhoto() {
        WelcomeScreen.pickPhoto.element.tap()
        
        XCTAssertTrue(app.navigationBars["Photos"].waitForExistence(timeout: 2))
        
        app.navigationBars.buttons["Cancel"].tap()
        
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: WelcomeScreen.pickPhoto.element)
        
        XCTWaiter().wait(for: [expectation], timeout: 5)
        XCTAssertTrue(WelcomeScreen.pickPhoto.element.isHittable)
    }
    
}




