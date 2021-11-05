//
//  LocaltypeDTO.swift
//  EventsCore
//
//  Created by Sherif Kamal on 11/3/21.
//

import Foundation

public struct LocalEventTypeDTO: Equatable, Hashable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

