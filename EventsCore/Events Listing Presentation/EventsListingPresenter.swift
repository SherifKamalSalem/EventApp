//
//  EventsListingPresenter.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import Foundation

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
