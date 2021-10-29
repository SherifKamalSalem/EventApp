//
//  Event.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/30/21.
//

import Foundation

public struct Event: Equatable {
    let id: String
    let longitude, latitude, endDate, startDate: String
    let welcomeDescription: String
    let cover: String
    let name: String
    
    init(id: String, longitude: String,
         latitude: String, endDate: String,
         startDate: String, welcomeDescription: String,
         cover: String, name: String
    ) {
        self.id = id
        self.longitude = longitude
        self.latitude = latitude
        self.endDate = endDate
        self.startDate = startDate
        self.welcomeDescription = welcomeDescription
        self.cover = cover
        self.name = name
    }
}
