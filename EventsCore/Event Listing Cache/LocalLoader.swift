//
//  LocalLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/4/21.
//

import Foundation

public protocol EventsListingLocalLoader {
    typealias Result = Swift.Result<[Event], Error>
    func load(for eventType: String, completion: @escaping (Result) -> Void)
}
