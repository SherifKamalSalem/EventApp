//
//  RemoteEventTypesLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/29/21.
//

import Foundation

public typealias RemoteEventTypesLoader = RemoteLoader<[EventType]>

extension RemoteEventTypesLoader: EventTypesLoader {
    public convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: EventTypeMapper.map)
    }
}
