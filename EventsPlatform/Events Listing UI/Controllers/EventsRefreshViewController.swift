//
//  EventsRefreshViewController.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/31/21.
//

import UIKit
import EventsCore

final class EventsRefreshViewController: NSObject {
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let eventsLoader: EventsListingLoader
    
    init(eventsLoader: EventsListingLoader) {
        self.eventsLoader = eventsLoader
    }
    
    var onRefresh: (([Event]) -> Void)?
    
    @objc func refresh() {
        view.beginRefreshing()
        eventsLoader.load { [weak self] result in
            if let events = try? result.get() {
                self?.onRefresh?(events)
            }
            self?.view.endRefreshing()
        }
    }
}
