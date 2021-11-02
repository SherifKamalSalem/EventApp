//
//  ManagedEvent.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/2/21.
//
//
import CoreData

@objc(ManagedFeedImage)
internal class ManagedEvent: NSManagedObject {
    @NSManaged internal var id: String
    @NSManaged internal var eventDescription: String?
    @NSManaged internal var name: String
    @NSManaged internal var longitude: String
    @NSManaged internal var latitude: String
    @NSManaged internal var startDate: String
    @NSManaged internal var cover: String
}

extension ManagedEvent {
    
    internal static func events(from localEvents: [LocalEventDTO], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localEvents.map { local in
            let managed = ManagedEvent(context: context)
            managed.id = local.id
            managed.eventDescription = local.eventDescription
            managed.name = local.name
            managed.cover = local.cover
            managed.longitude = local.longitude
            managed.latitude = local.latitude
            managed.startDate = local.startDate
            return managed
        })
    }
    
    internal static func find(in context: NSManagedObjectContext) throws -> [ManagedEvent] {
        let request = NSFetchRequest<ManagedEvent>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    internal var local: LocalEventDTO {
        return LocalEventDTO(id: id, name: name, longitude: longitude, latitude: latitude, startDate: startDate, eventDescription: eventDescription, cover: cover)
    }
}

