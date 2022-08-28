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
        
        // Reduce
        
        let reduced = MainViewState.reducer(mainViewStateBefore, MainViewStateAction.showOverlay)
        
        // Test
        
        XCTAssertTrue(reduced.isPresentingOverlay)
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
    static let mainStateDefault: MainViewState = .init(isPresentingOverlay: false)
    static let mainStatePresentingOverlay: MainViewState = .init(isPresentingOverlay: true)
}
