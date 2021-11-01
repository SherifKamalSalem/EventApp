//
//  EventPagerTabController.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/1/21.
//

import UIKit

public class EventPagerTabController: NSObject {
    private let viewControllerAtPosition: ((Int) -> UIViewController)
    private let tabs: [String]
    
    public init(tabs: [String], viewControllerAtPosition: @escaping (Int) -> UIViewController) {
        self.viewControllerAtPosition = viewControllerAtPosition
        self.tabs = tabs
    }
}

extension EventPagerTabController: EventsPagerDataSource {
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        return viewControllerAtPosition(position)
    }
    
    func tabsForPages() -> [String] {
        return tabs
    }
    
    func startEventsPagerAtIndex() -> Int {
        return 0
    }
}
