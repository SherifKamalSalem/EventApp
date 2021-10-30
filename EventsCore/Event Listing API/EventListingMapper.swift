//
//  EventListingMapper.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/30/21.
//

import Foundation

public class EventListingMapper {
    static var OK_200: Int { return 200 }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Event] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard response.statusCode == OK_200,
              let eventTypes = try? decoder.decode([EventDTO].self, from: data) else {
            throw Error.invalidData
        }
        
        return eventTypes.map { $0.event }
    }
    
    private struct EventDTO: Decodable {
        let id: String
        let longitude, latitude, endDate, startDate: String
        let welcomeDescription: String
        let cover: String
        let name: String
        
        var event: Event {
            return Event(id: id, longitude: longitude, latitude: latitude, endDate: endDate, startDate: startDate, welcomeDescription: welcomeDescription, cover: cover, name: name)
        }
    }
}
