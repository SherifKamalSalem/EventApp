//
//  RemoteEventTypesLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/29/21.
//

import Foundation

public final class RemoteEventTypesLoader: EventTypesLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
        
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (EventTypesLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(EventTypeMapper.map(data, response))
            case .failure:
                completion(.failure(RemoteEventTypesLoader.Error.connectivity))
            }
        }
    }
}
