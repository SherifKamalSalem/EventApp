//
//  RemoteEventTypesLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/29/21.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteEventTypesLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}
