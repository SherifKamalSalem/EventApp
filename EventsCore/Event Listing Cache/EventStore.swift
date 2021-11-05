//
//  EventStore.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/2/21.
//

import Foundation

public protocol EventStore {
    typealias InsertionCompletion = (Result<Void, Error>) -> Void
    typealias RetrievalCompletion = (Result<[LocalEventDTO], Error>) -> Void
    typealias DeletionCompletion = (Result<Void, Error>) -> Void
    
    func insert(_ events: [LocalEventDTO], for type: LocalEventTypeDTO, completion: @escaping InsertionCompletion)
    func retrieve(for typeName: String, completion: @escaping RetrievalCompletion)
    func deleteCachedEvents(completion: @escaping DeletionCompletion)
}
