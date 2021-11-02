//
//  EventTypesUIComposer.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/1/21.
//

import UIKit
import EventsCore

public final class EventTypesUIComposer {
    public static func eventTypesComposedWith(eventTypesLoader: EventTypesLoader, completion: @escaping (UIViewController) -> Void) {
        let loadEventsAdapter = EventTypesLoaderPresentationAdapter(eventTypesLoader: eventTypesLoader)
        loadEventsAdapter.loadEventTypes() { eventTypes in
            loadEventsAdapter.tabs = eventTypes.map { $0.name }
            let pagerTabController = EventPagerTabController(
                model: EventTypesViewModelPresentable(eventTypes: eventTypes),
                dataSource: loadEventsAdapter)
            DispatchQueue.main.async {
                let controller = makeMainViewController(controller: pagerTabController)
                completion(controller)
            }
        }
    }
    
    private static func makeMainViewController(controller: EventPagerTabController) -> MainViewController {
        let bundle = Bundle(for: MainViewController.self)
        let storyboard = UIStoryboard(name: "EventTypes", bundle: bundle)
        let mainController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainController.eventPagerTabController = controller
        return mainController
    }
}

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
