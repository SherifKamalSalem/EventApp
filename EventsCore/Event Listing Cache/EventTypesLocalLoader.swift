//
//  EventTypesLocalLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/5/21.
//

import Foundation

public final class EventTypesLocalLoader: EventTypesCache {
    private let store: EventTypeStore
    
    public init(store: EventTypeStore) {
        self.store = store
    }
    
    public func save(_ eventTypes: [EventType], completion: @escaping (EventsCache.Result) -> Void) {
        store.deleteCachedEventTypes { [weak self] deletionResult in
            guard let self = self else { return }
            switch deletionResult {
            case .success:
                self.cache(eventTypes, with: completion)
            
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ eventTypes: [EventType], with completion: @escaping (EventTypesCache.Result) -> Void) {
        store.insert( eventTypes.toLocal()) { [weak self] insertionResult in
            guard self != nil else { return }
            
            completion(insertionResult)
        }
    }
}

extension EventTypesLocalLoader: EventTypesLoader {
    public typealias LoadResult = EventTypesLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve() { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(events):
                completion(.success(events.toModels()))
            }
        }
    }
}

private extension Array where Element == LocalEventTypeDTO {
    func toModels() -> [EventType] {
        return map { EventType(id: $0.id, name: $0.name) }
    }
}

private extension Array where Element == EventType {
    func toLocal() -> [LocalEventTypeDTO] {
        return map { LocalEventTypeDTO(id: $0.id, name: $0.name) }
    }
}

private extension EventType {
    func toLocal() -> LocalEventTypeDTO {
        return LocalEventTypeDTO(id: id, name: name)
    }
}
