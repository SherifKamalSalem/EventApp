//
//  EventViewController.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import UIKit

public final class EventViewController: UITableViewController {
    private var refreshController: EventsRefreshViewController?
    var tableModel = [EventCellController]() {
        didSet { tableView.reloadData() }
    }

    convenience init(refreshController: EventsRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).tableView(tableView, cellForRowAt: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> EventCellController {
        return tableModel[indexPath.row]
    }
}
