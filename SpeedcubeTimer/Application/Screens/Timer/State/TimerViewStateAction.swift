//
//  TimerViewStateAction.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/04/2022.
//

import Foundation

enum TimerViewStateAction: Action {
    case touchBegan
    case touchEnded
    case updateTime(_ time: Double)
}

