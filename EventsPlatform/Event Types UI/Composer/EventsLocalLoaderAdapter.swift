//
//  Adapter.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/4/21.
//

import Foundation
import EventsCore

class EventsLocalLoaderAdapter: EventsListingLoader {
    private let loader: EventsLocalLoader
    private let typeName: String
    
    init(loader: EventsLocalLoader, typeName: String) {
        self.loader = loader
        self.typeName = typeName
    }
    
    func load(completion: @escaping (EventsListingLoader.Result) -> Void) {
        loader.load(for: typeName, completion: completion)
    }
}

