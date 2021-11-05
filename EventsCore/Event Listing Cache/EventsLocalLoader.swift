//
//  EventsLocalLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/4/21.
//

import Foundation

public final class EventsLocalLoader: EventsCache {
    private let store: EventStore
    
    public init(store: EventStore) {
        self.store = store
    }
    
    public func save(_ events: [Event], for type: EventType, completion: @escaping (EventsCache.Result) -> Void) {
        store.deleteCachedEvents { [weak self] deletionResult in
            guard let self = self else { return }
            switch deletionResult {
            case .success:
                self.cache(events, for: type, with: completion)
            
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ events: [Event], for type: EventType, with completion: @escaping (EventsCache.Result) -> Void) {
        store.insert( events.toLocal(), for: type.toLocal()) { [weak self] insertionResult in
            guard self != nil else { return }
            
            completion(insertionResult)
        }
    }
}

extension EventsLocalLoader {
    public typealias LoadResult = EventsListingLoader.Result

    public func load(for typeName: String, completion: @escaping (LoadResult) -> Void) {
        store.retrieve(for: typeName) { [weak self] result in
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

private extension Array where Element == LocalEventDTO {
    func toModels() -> [Event] {
        return map { Event(id: $0.id, name: $0.name, longitude: $0.longitude, latitude: $0.latitude, startDate: $0.startDate, endDate: "", description: $0.eventDescription ?? "", cover: $0.cover) }
    }
}

private extension Array where Element == Event {
    func toLocal() -> [LocalEventDTO] {
        return map { LocalEventDTO(id: $0.id, name: $0.name, longitude: $0.longitude, latitude: $0.latitude, startDate: $0.startDate, eventDescription: $0.description, cover: $0.cover) }
    }
}

private extension EventType {
    func toLocal() -> LocalEventTypeDTO {
        return LocalEventTypeDTO(id: id, name: name)
    }
}
