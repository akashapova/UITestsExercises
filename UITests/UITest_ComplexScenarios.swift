//
//  UITest_ComplexScenarios.swift
//  UITests
//
//  Created by Альбина Кашапова on 1/30/21.
//

import XCTest

class UITest_ComplexScenarios: XCTestCase {
    
    private var app: XCUIApplication!
    
    enum Difficulty: String {
        case beginner = "Beginner"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    enum Music {
        case on
        case off
    }
    
    func setDifficulty(_ difficulity: Difficulty) {
        XCUIApplication().segmentedControls.buttons[difficulity.rawValue].tap()
    }
    
    func setMusic(_ music: Music) {
        let switchValue = XCUIApplication().switches.firstMatch.value as? String
        if (music == .on && switchValue == "0") || (music == .off && switchValue == "1") {
            XCUIApplication().switches.firstMatch.tap()
        }
    }
    
    func configureSettings(difficulty: Difficulty, music: Music) {
        
        XCTContext.runActivity(named: "Configure with \(difficulty), \(music)") { _ in
            setDifficulty(difficulty)
            setMusic(music)
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
    
    func testStateWithDifficultyMediumAndMusicOff() {
        
        configureSettings(difficulty: .medium, music: .off)
        
        XCTContext.runActivity(named: "Verifying NavigationBar Title") { _ in
            XCTAssertTrue(app.navigationBars["Medium"].waitForExistence(timeout: 1))
        }
        XCTContext.runActivity(named: "Verifying Switch State") { _ in
            XCTAssertEqual(app.switches.firstMatch.value as? String, "0", "Switch is On")
        }
    }
    
    func testStateWithDifficultyHardAndMusicOn() {
        
        configureSettings(difficulty: .hard, music: .on)
        
        XCTContext.runActivity(named: "Verifying NavigationBar Title") { _ in
            XCTAssertTrue(app.navigationBars["Hard"].waitForExistence(timeout: 1))
        }
        XCTContext.runActivity(named: "Verifying Switch State") { _ in
            XCTAssertEqual(app.switches.firstMatch.value as? String, "1", "Switch is Off")
            
        }
    }
}
