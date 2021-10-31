//
//  EventListingLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/31/21.
//

import Foundation

public protocol EventsListingLoader {
    typealias Result = Swift.Result<[Event], Error>
    func load(completion: @escaping (Result) -> Void)
}
