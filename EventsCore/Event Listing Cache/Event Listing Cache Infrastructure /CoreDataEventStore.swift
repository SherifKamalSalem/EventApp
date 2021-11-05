//
//  CoreDataEventStore.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/2/21.
//

import CoreData

public final class CoreDataEventStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    public init(storeURL: URL, bundle: Bundle = Bundle(for: CoreDataEventStore.self)) throws {
        container = try NSPersistentContainer.load(modelName: "EventStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func insert(_ localEvents: [LocalEventDTO], completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                _ = ManagedEvent.events(from: localEvents, in: context)
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func retrieve(with typeName: String, completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                let cache = try ManagedEvent.fetchEvents(with: typeName, in: context).map { $0.local }
                completion(.success(cache))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
