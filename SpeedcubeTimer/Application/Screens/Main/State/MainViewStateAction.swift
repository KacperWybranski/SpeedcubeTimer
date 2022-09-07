//
//  MainViewStateAction.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 28/08/2022.
//

import Foundation

enum MainViewStateAction: Action {
    case selectionChanged(_ selection: Int)
    case showOverlay(text: String)
    case hideOverlay
}
