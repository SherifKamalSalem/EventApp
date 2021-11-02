//
//  MainViewController.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/31/21.
//

import UIKit
import EventsCore

public class MainViewController: UIViewController {
    
    private var pager: EventsPager?
    var eventPagerTabController: EventPagerTabController?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupPager()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setupPager() {
        pager = EventsPager(viewController: self)
        pager?.setOptions(options: EventsPagerConfig())
        if let eventPagerTabController = eventPagerTabController {
            pager?.setDataSource(dataSource: eventPagerTabController)
        }
        pager?.build()
    }
}
