//
//  EventTypesCache.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/5/21.
//

import Foundation

public protocol EventTypesCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ eventTypes: [EventType], completion: @escaping (Result) -> Void)
}
