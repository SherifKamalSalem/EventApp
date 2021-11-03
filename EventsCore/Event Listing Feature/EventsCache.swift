//
//  EventCache.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/3/21.
//

import Foundation

public protocol EventsCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ events: [Event], completion: @escaping (Result) -> Void)
}
