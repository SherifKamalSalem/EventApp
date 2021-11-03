//
//  EventTypesStore.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/3/21.
//

import Foundation

public protocol EventTypesStore {
    typealias InsertionCompletion = (Result<Void, Error>) -> Void
    typealias RetrievalCompletion = (Result<[LocalEventTypeDTO], Error>) -> Void
    typealias DeletionCompletion = (Result<Void, Error>) -> Void
    
    func insert(_ eventTypes: [LocalEventDTO], completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
    func deleteCachedEventTypes(completion: @escaping DeletionCompletion)
}
