//
//  CDResult+CoreDataProperties.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/09/2022.
//
//

import Foundation
import CoreData


extension CDResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDResult> {
        return NSFetchRequest<CDResult>(entityName: "CDResult")
    }

    @NSManaged public var scramble: String?
    @NSManaged public var time: Double
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var session: CDSession?

}

extension CDResult : Identifiable {

}
