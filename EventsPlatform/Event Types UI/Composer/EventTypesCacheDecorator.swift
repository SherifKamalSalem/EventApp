//
//  EventTypesCacheDecorator.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/5/21.
//

import EventsCore

public final class EventTypesLoaderCacheDecorator: EventTypesLoader {
    private let decoratee: EventTypesLoader
    private let cache: EventTypesCache

    public init(decoratee: EventTypesLoader, cache: EventTypesCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (EventTypesLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            guard let self = self else { return }
            completion(result.map { eventTypes in
                self.cache.saveIgnoringResult(eventTypes)
                return eventTypes
            })
        }
    }
}

private extension EventTypesCache {
    func saveIgnoringResult(_ events: [EventType]) {
        save(events) { _ in }
    }
}
