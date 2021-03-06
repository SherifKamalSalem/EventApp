//
//  EventTypesLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/28/21.
//

import Foundation

public protocol EventTypesLoader {
    typealias Result = Swift.Result<[EventType], Error>
    func load(completion: @escaping (Result) -> Void)
}
