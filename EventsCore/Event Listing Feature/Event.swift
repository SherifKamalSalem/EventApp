//
//  Event.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/30/21.
//

import Foundation

public struct Event: Equatable, Hashable {
    public let id: String
    public let name: String
    public let longitude, latitude, endDate, startDate: String
    public let description: String
    public let cover: String
    
    public init(id: String, name: String,
                longitude: String,latitude: String,
                startDate: String, endDate: String,
                description: String, cover: String
    ) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.cover = cover
    }
}
