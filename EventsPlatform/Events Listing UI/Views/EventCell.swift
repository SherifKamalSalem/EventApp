//
//  EventCell.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import UIKit

public final class EventCell: UITableViewCell {
    @IBOutlet private(set) public var nameLabel: UILabel!
    @IBOutlet private(set) public var descriptionLabel: UILabel!
    @IBOutlet private(set) public var dateLabel: UILabel!
    @IBOutlet private(set) public var eventImage: UIImageView!
}
