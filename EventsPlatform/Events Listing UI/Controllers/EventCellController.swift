//
//  EventCellController.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import UIKit
import EventsCore

final class EventCellController: NSObject {
    private let viewModel: EventViewModelPresentable
    private var cell: EventCell?

    public init(viewModel: EventViewModelPresentable) {
        self.viewModel = viewModel
    }
}

extension EventCellController {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell
        cell?.dateLabel.text = viewModel.startDate
        cell?.descriptionLabel.text = viewModel.description
        cell?.nameLabel.text = viewModel.name
        return cell ?? UITableViewCell()
    }
}
