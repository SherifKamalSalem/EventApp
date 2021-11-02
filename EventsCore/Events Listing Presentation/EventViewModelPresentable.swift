//
//  EventViewModelPresentable.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/31/21.
//

import Foundation

public struct EventViewModelPresentable {
    private let event: Event
    
    public init(event: Event) {
        self.event = event
    }
    
    public var name: String {
        return event.name
    }
    
    public var description: String {
        return event.description ?? ""
    }
    
    public var startDate: String {
        return event.startDate
    }
    
    public var cover: String {
        return event.cover
    }
}

public protocol EventView {
    func display(_ viewModel: EventViewModelPresentable)
}
