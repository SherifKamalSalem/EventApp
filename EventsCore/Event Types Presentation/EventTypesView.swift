//
//  EventTypesView.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/31/21.
//

import Foundation

public struct EventTypesViewModelPresentable {
    public let eventTypes: [EventType]
}

public protocol EventTypesView {
    func display(_ viewModel: EventTypesViewModelPresentable)
}
