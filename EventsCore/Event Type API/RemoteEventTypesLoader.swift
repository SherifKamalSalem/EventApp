//
//  RemoteEventTypesLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/29/21.
//

import Foundation

public final class RemoteEventTypesLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<[EventType], Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200, let eventTypes = try? JSONDecoder().decode([EventTypeDTO].self, from: data) {
                    completion(.success(eventTypes.map { $0.type }))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct EventTypeDTO: Decodable {
    let id: String
    let name: String
    
    var type: EventType {
        return EventType(id: id, name: name)
    }
}
