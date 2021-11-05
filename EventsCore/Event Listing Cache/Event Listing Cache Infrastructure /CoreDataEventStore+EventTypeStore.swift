//
//  CoreDataEventStore+EventTypeStore.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/5/21.
//

import Foundation

extension CoreDataEventStore: EventTypeStore {
    public func insert(_ localEventTypes: [LocalEventTypeDTO], completion: @escaping InsertionCompletion) {
        perform { context in
            for eventType in localEventTypes {
                do {
                    if try ManagedEventType.first(with: eventType.name, in: context) == nil {
                        let localEventType = ManagedEventType(context: context)
                        localEventType.name = eventType.name
                        localEventType.id = eventType.id
                    }
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func retrieve(completion: @escaping EventTypeStore.RetrievalCompletion) {
        perform { context in
            do {
                let cache = try ManagedEventType.findObjects(in: context).map { $0.local }
                completion(.success(cache))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteCachedEventTypes(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedEventType.findObject(in: context).map(context.delete).map(context.save)
            })
        }
    }
}
