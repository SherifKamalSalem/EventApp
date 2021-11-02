//
//  EventStore.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/2/21.
//

import Foundation

public protocol EventStore {
    typealias InsertionCompletion = (Error?) -> Void
    
    func insert(_ events: [LocalEventDTO], completion: @escaping InsertionCompletion)
}
