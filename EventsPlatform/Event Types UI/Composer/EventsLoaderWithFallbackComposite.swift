//
//  EventsLoaderWithFallbackComposite.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/4/21.
//

import EventsCore

public class EventsLoaderWithFallbackComposite: EventsListingLoader {
    private let primary: EventsListingLoader
    private let fallback: EventsListingLoader

    public init(primary: EventsListingLoader, fallback: EventsListingLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(completion: @escaping (EventsListingLoader.Result) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}
