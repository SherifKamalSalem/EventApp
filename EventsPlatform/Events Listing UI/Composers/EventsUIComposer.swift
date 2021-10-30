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
        let refreshController = EventsRefreshViewController(eventsLoader: eventsLoader)
        let feedController = EventViewController(refreshController: refreshController)
        refreshController.onRefresh = { [weak feedController] feed in
            feedController?.tableModel = feed.map { model in
                EventCellController(viewModel: EventViewModelPresentable(event: model))
            }
        }
        return feedController
    }
}
