//
//  ManagedEventType.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/3/21.
//

import Foundation
import CoreData

@objc(ManagedEventType)
class ManagedEventType: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var events: NSSet
}

extension ManagedEventType {
    static func find(in context: NSManagedObjectContext) throws -> ManagedEventType? {
        let request = NSFetchRequest<ManagedEventType>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func first(with typeName: String, in context: NSManagedObjectContext) throws -> ManagedEventType? {
        let request = NSFetchRequest<ManagedEventType>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedEventType.name), typeName])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
