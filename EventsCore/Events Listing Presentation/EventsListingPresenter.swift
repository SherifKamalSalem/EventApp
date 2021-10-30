//
//  EventsListingPresenter.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
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
        return event.description
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

public struct EventsViewModelPresentable {
    public let events: [Event]
}

public protocol EventsView {
    func display(_ viewModel: EventsViewModelPresentable)
}

public struct EventsLoadingViewModelPresentable {
    public let isLoading: Bool
}

public protocol EventsLoadingView {
    func display(_ viewModel: EventsLoadingViewModelPresentable)
}

public final class EventsListingPresenter {
    private let loadingView: EventsLoadingView
    private let eventsView: EventsView
    
    public init(loadingView: EventsLoadingView, eventsView: EventsView) {
        self.loadingView = loadingView
        self.eventsView = eventsView
    }
    
    public func didStartLoadingEvents() {
        loadingView.display(EventsLoadingViewModelPresentable(isLoading: true))
    }
    
    public func didFinishLoadingEvents(with events: [Event]) {
        eventsView.display(EventsViewModelPresentable(events: events))
        loadingView.display(.init(isLoading: false))
    }
}
