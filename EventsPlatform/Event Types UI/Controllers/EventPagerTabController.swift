//
//  EventPagerTabController.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/1/21.
//

import UIKit
import EventsCore

public class EventPagerTabController: NSObject {
    private let dataSource: EventsPagerDataSource
    private let model: EventTypesViewModelPresentable
    
    public init(model: EventTypesViewModelPresentable, dataSource: EventsPagerDataSource) {
        self.dataSource = dataSource
        self.model = model
    }
}

extension EventPagerTabController: EventsPagerDataSource {
    public func numberOfPages() -> Int {
        return dataSource.numberOfPages()
    }
    
    public func viewControllerAtPosition(position: Int) -> UIViewController {
        return dataSource.viewControllerAtPosition(position: position)
    }
    
    public func tabsForPages() -> [String] {
        return dataSource.tabsForPages()
    }
    
    public func startEventsPagerAtIndex() -> Int {
        return dataSource.startEventsPagerAtIndex()
    }
}
