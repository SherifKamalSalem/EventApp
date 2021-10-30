//
//  EventPagerOptions.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import UIKit

public class EventsPagerConfig {
    
    public var tabViewBackgroundDefaultColor: UIColor = Color.tabViewBackground
    public var tabViewHeight:CGFloat = 60

    public init() {}
    
    fileprivate struct Color {
        static let tabViewBackground = UIColor(red: 202 / 255.0, green: 200/255.0, blue: 201/255.0, alpha: 1.0)
    }
}
