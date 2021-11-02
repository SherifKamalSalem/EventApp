//
//  EventListingLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/30/21.
//

import Foundation

public typealias RemoteEventListingLoader = RemoteLoader<[Event]>

extension RemoteEventListingLoader: EventsListingLoader {
    public convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: EventListingMapper.map)
    }
}
