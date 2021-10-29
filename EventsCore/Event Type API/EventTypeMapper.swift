//
//  EventTypeMapper.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/29/21.
//

import Foundation

public class EventTypeMapper {
    static var OK_200: Int { return 200 }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [EventType] {
        guard response.statusCode == OK_200,
              let eventTypes = try? JSONDecoder().decode([EventTypeDTO].self, from: data) else {
            throw Error.invalidData
        }
        
        return eventTypes.map { $0.type }
    }
    
    private struct EventTypeDTO: Decodable {
        let id: String
        let name: String
        
        var type: EventType {
            return EventType(id: id, name: name)
        }
    }
}
