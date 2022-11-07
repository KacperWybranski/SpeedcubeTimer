//
//  SettingsManager.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 05/11/2022.
//

import Foundation

protocol UserSettingsProtocol {
    var isPreinspectionOn: Bool { get }
    
    func setIsPreinspectionOn(_ shouldBeTurnedOn: Bool)
}

final class UserSettings: UserSettingsProtocol {
    private(set) var isPreinspectionOn: Bool = false
    
    func setIsPreinspectionOn(_ shouldBeTurnedOn: Bool) {
        isPreinspectionOn = shouldBeTurnedOn
    }
}
