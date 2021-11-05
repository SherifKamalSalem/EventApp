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
    private let selection: () -> Void
    private let loadedImage: () -> Data

//    public init(viewModel: EventViewModelPresentable, loadedImage: @escaping () -> Data, selection: @escaping () -> Void) {
//        self.viewModel = viewModel
//        self.selection = selection
//        self.loadedImage = loadedImage
//    }
}

extension EventCellController {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell
        cell?.dateLabel.text = viewModel.startDate
        cell?.descriptionLabel.text = viewModel.description
        cell?.nameLabel.text = viewModel.name
        cell?.eventImage.image = UIImage(data: loadedImage())
        return cell ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
    }
}
