//
//  CDSession+CoreDataProperties.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/09/2022.
//
//

import Foundation
import CoreData


extension CDSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSession> {
        return NSFetchRequest<CDSession>(entityName: "CDSession")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var index: Int16
    @NSManaged public var results: NSSet?
    @NSManaged public var cube: Cube
    
}

// MARK: Generated accessors for results
extension CDSession {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: CDResult)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: CDResult)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}

extension CDSession : Identifiable {

}
