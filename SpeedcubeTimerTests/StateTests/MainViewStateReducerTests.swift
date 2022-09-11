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
    
    func testTabSelectionChanged() {
        
        // Input
        
        let beforeState = MainViewState(isPresentingOverlay: false,
                                        overlayText: .empty,
                                        tabSelection: 1)
        let afterState = MainViewState(isPresentingOverlay: false,
                                       overlayText: .empty,
                                       tabSelection: 2)
        
        // Reduced
        
        let reduced = MainViewState.reducer(beforeState, MainViewStateAction.selectionChanged(2))
        
        // Test
        
        XCTAssertEqual(reduced, afterState)
    }
    
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
        XCTAssertEqual(reduced.overlayText, .empty)
    }
    
    func testNonHandledAction() {
        
        // Input
        
        let beforeState = MainViewState(isPresentingOverlay: false,
                                        overlayText: .empty,
                                        tabSelection: 1)
        
        // Reduced
        
        let reduced = MainViewState.reducer(beforeState, TestAction.notHandledAction)
        
        // Test
        
        XCTAssertEqual(beforeState, reduced)
    }
}

private enum Configuration {
    static let mainStateDefault: MainViewState = .init(isPresentingOverlay: false, overlayText: .empty, tabSelection: 1)
    static let mainStatePresentingOverlay: MainViewState = .init(isPresentingOverlay: true, overlayText: .empty, tabSelection: 1)
    static let overlayText: String = "Great"
}
