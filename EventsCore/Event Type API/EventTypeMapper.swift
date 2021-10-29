//
//  EventTypeMapper.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/29/21.
//

import Foundation

public class EventTypeMapper {
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteEventTypesLoader.Result {
        guard response.statusCode == OK_200,
              let eventTypes = try? JSONDecoder().decode([EventTypeDTO].self, from: data) else {
            return .failure(RemoteEventTypesLoader.Error.invalidData)
        }
        
        return .success(eventTypes.map { $0.type })
    }
    
    private struct EventTypeDTO: Decodable {
        let id: String
        let name: String
        
        var type: EventType {
            return EventType(id: id, name: name)
        }
    }
}
