//
//  EventTypesUIComposer.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/1/21.
//

import UIKit
import EventsCore

private final class EventTypesLoaderPresentationAdapter {
    private let eventTypesLoader: EventTypesLoader
    fileprivate var tabs = [String]()
    
    init(eventTypesLoader: EventTypesLoader) {
        self.eventTypesLoader = eventTypesLoader
    }
    
    func loadEventTypes(completion: @escaping (_ tabs: [EventType]) -> Void) {
        eventTypesLoader.load {[weak self] result in
            guard self != nil else { return }
            let eventTypes = (try? result.get()) ?? []
            completion(eventTypes)
        }
    }
}

extension EventTypesLoaderPresentationAdapter: EventsPagerDataSource {
    public func numberOfPages() -> Int {
        return tabs.count
    }
    
    public func viewControllerAtPosition(position: Int) -> UIViewController {
        let tabName = tabs[position].lowercased()
        let client = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        let eventsLoader = RemoteEventListingLoader(url: URL(string: "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/events?event_type=\(tabName)&page=1")!, client: client)
        return EventsUIComposer.eventsComposedWith(eventsLoader: eventsLoader)
    }
    
    public func tabsForPages() -> [String] {
        return tabs
    }
    
    public func startEventsPagerAtIndex() -> Int {
        0
    }
}
