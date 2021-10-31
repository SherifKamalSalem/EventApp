//
//  EventsView.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/31/21.
//

import Foundation

public struct EventsViewModelPresentable {
    public let events: [Event]
}

public protocol EventsView {
    func display(_ viewModel: EventsViewModelPresentable)
}
