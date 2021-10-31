//
//  Event.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/30/21.
//

import Foundation

public struct Event: Equatable, Hashable {
    let id: String
    let name: String
    let longitude, latitude, endDate, startDate: String
    let description: String
    let cover: String
    
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
