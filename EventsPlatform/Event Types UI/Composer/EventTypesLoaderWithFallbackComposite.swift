//
//  EventTypesLoaderWithFallbackComposite.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/5/21.
//

import EventsCore

public class EventTypesLoaderWithFallbackComposite: EventTypesLoader {
    private let primary: EventTypesLoader
    private let fallback: EventTypesLoader

    public init(primary: EventTypesLoader, fallback: EventTypesLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(completion: @escaping (EventTypesLoader.Result) -> Void) {
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
