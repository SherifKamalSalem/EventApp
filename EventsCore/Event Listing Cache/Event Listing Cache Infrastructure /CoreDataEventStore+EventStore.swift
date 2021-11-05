//
//  CoreDataEventStore+EventStore.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/3/21.
//

import Foundation
import CoreData

extension CoreDataEventStore: EventStore {
    public func insert(_ localEvents: [LocalEventDTO], for type: LocalEventTypeDTO, completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                if let localEventType = try ManagedEventType.first(with: type.name, in: context) {
                    localEventType.events = ManagedEvent.events(from: localEvents, in: context)
                } else {
                    let localEventType = ManagedEventType(context: context)
                    localEventType.name = type.name
                    localEventType.id = type.id
                    localEventType.events = ManagedEvent.events(from: localEvents, in: context)
                }
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func retrieve(for typeName: String, completion: @escaping EventStore.RetrievalCompletion) {
        perform { context in
            do {
                let cache = try ManagedEvent.fetchEvents(with: typeName, in: context).map { $0.local }
                completion(.success(cache))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteCachedEvents(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedEvent.findObject(in: context).map(context.delete).map(context.save)
            })
        }
    }
}
