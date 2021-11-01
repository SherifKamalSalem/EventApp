//
//  EventTypesPresenter.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/31/21.
//

import Foundation

public final class EventTypesPresenter {
    private let loadingView: EventsLoadingView
    private let eventTypesView: EventTypesView
    
    public init(loadingView: EventsLoadingView, eventTypesView: EventTypesView) {
        self.loadingView = loadingView
        self.eventTypesView = eventTypesView
    }
    
    public func didStartLoadingEventTypes() {
        loadingView.display(EventsLoadingViewModelPresentable(isLoading: true))
    }
    
    public func didFinishLoadingEventTypes(with eventTypes: [EventType]) {
        eventTypesView.display(EventTypesViewModelPresentable(eventTypes: eventTypes))
        loadingView.display(.init(isLoading: false))
    }
    
    
}
