//
//  EventType.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/28/21.
//

import Foundation

public struct EventType: Equatable, Hashable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
