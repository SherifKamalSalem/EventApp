//
//  EventsUIComposer.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/31/21.
//

import Foundation
import EventsCore

public final class EventsUIComposer {
    public static func feedComposedWith(eventsLoader: EventsListingLoader) -> EventViewController {
        let loadEventsAdapter = EventsLoaderPresentationAdapter(eventsLoader: eventsLoader)
        let refreshController = EventsRefreshViewController(loadEvents: loadEventsAdapter.loadEvents)
        let feedController = EventViewController(refreshController: refreshController)
        let presenter = EventsListingPresenter(loadingView: WeakRefVirtualProxy(refreshController), eventsView: EventsViewAdapter(controller: feedController))
        loadEventsAdapter.presenter = presenter
        return feedController
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: EventsLoadingView where T: EventsLoadingView {
    func display(_ viewModel: EventsLoadingViewModelPresentable) {
        object?.display(viewModel)
    }
}

private final class EventsViewAdapter: EventsView {
    private weak var controller: EventViewController?
    
    init(controller: EventViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: EventsViewModelPresentable) {
        controller?.tableModel = viewModel.events.map { model in
            EventCellController(viewModel: EventViewModelPresentable(event: model))
        }
    }
}


private final class EventsLoaderPresentationAdapter {
    private let eventsLoader: EventsListingLoader
    var presenter: EventsListingPresenter?
    
    init(eventsLoader: EventsListingLoader) {
        self.eventsLoader = eventsLoader
    }
    
    func loadEvents() {
        presenter?.didStartLoadingEvents()
        
        eventsLoader.load { [weak self] result in
            switch result {
            case let .success(events):
                self?.presenter?.didFinishLoadingEvents(with: events)
            case .failure:
                self?.presenter?.didFinishLoadingEvents(with: [])
            }
        }
    }
}
