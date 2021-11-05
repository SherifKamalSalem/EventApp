//
//  EventsRefreshViewController.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/31/21.
//

import UIKit
import EventsCore

final class EventsRefreshViewController: NSObject, EventsLoadingView {
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
        
    private let loadEvents: () -> Void
    
    init(loadEvents: @escaping () -> Void) {
        self.loadEvents = loadEvents
    }
    
    @objc func refresh() {
        loadEvents()
    }
    
    func display(_ viewModel: EventsLoadingViewModelPresentable) {
        DispatchQueue.main.async { [weak self] in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
    }
}
