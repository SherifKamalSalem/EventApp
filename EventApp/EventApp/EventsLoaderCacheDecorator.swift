//
//  EventsLoaderCacheDecorator.swift
//  EventApp
//
//  Created by Sherif Kamal on 11/3/21.
//

import Foundation
import EventsCore

public final class EventsLoaderCacheDecorator: EventsListingLoader {
    private let decoratee: EventsListingLoader
    private let cache: EventsCache
    private let eventType: EventType
    
    public init(decoratee: EventsListingLoader, cache: EventsCache, eventType: EventType) {
        self.decoratee = decoratee
        self.cache = cache
        self.eventType = eventType
    }
    
    public func load(completion: @escaping (EventsListingLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            guard let self = self else { return }
            completion(result.map { events in
                self.cache.saveIgnoringResult(events, for: self.eventType)
                return events
            })
        }
    }
}

private extension EventsCache {
    func saveIgnoringResult(_ events: [Event], for type: EventType) {
        save(events, for: type) { _ in }
    }
}
