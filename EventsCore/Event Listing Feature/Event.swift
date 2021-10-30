//
//  Event.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/30/21.
//

import Foundation

public struct Event: Equatable {
    let id: String
    let name: String
    let longitude, latitude, endDate, startDate: String
    let welcomeDescription: String
    let cover: String
    
    public init(id: String, name: String,
                longitude: String,latitude: String,
                startDate: String, endDate: String,
                welcomeDescription: String, cover: String
    ) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.startDate = startDate
        self.endDate = endDate
        self.welcomeDescription = welcomeDescription
        self.cover = cover
    }
}
