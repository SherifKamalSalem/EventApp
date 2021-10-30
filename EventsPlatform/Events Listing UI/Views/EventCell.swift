//
//  EventCell.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import UIKit

final class EventCell: UITableViewCell {
    @IBOutlet private(set) var nameLabel: UILabel!
    @IBOutlet private(set) var descriptionLabel: UILabel!
    @IBOutlet private(set) var dateLabel: UILabel!
    @IBOutlet private(set) var eventImage: UIImageView!
}
