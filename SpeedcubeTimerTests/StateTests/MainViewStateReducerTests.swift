//
//  MainViewStateReducerTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 28/08/2022.
//

import Foundation
import XCTest

class MainViewStateReducerTests: XCTestCase {
    
    override func setUpWithError() throws { }
    
    override func tearDownWithError() throws { }
    
    func testShowOverlayOnNewPb() {
        
        // Input
        
        let mainViewStateBefore = Configuration.mainStateDefault
        let overlayText = Configuration.overlayText
        
        // Reduce
        
        let reduced = MainViewState.reducer(mainViewStateBefore, MainViewStateAction.showOverlay(text: overlayText))
        
        // Test
        
        XCTAssertTrue(reduced.isPresentingOverlay)
        XCTAssertEqual(reduced.overlayText, overlayText)
    }
    
    func testHideOverlayAfterAnimationEnd() {
        
        // Input
        
        let mainViewStateBefore = Configuration.mainStatePresentingOverlay
        
        // Reduce
        
        let reduced = MainViewState.reducer(mainViewStateBefore, MainViewStateAction.hideOverlay)
        
        // Test
        
        XCTAssertFalse(reduced.isPresentingOverlay)
    }
}

private enum Configuration {
    static let mainStateDefault: MainViewState = .init(isPresentingOverlay: false, overlayText: .empty)
    static let mainStatePresentingOverlay: MainViewState = .init(isPresentingOverlay: true, overlayText: .empty)
    static let overlayText: String = "Great"
}
