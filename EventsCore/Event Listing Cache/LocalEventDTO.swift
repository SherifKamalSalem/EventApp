//
//  LocalEventDTO.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/2/21.
//

import Foundation

public struct LocalEventDTO: Equatable, Hashable {
    let id: String
    let name: String
    let longitude, latitude, startDate: String
    let eventDescription: String?
    let cover: String
    
    public init(id: String, name: String,
                longitude: String,latitude: String,
                startDate: String, eventDescription: String?,
                cover: String
    ) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.startDate = startDate
        self.eventDescription = eventDescription
        self.cover = cover
    }
}
