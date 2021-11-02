//
//  EventPagerOptions.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import UIKit

public class EventsPagerConfig {
    
    public var isTabHighlightAvailable:Bool = true
    public var isTabIndicatorAvailable:Bool = true
    public var isTabBarShadowAvailable:Bool = true
    
    public var tabViewBackgroundDefaultColor: UIColor = Color.tabViewBackground
    public var tabViewHeight:CGFloat = 60

    public var eventsPagerTransitionStyle: UIPageViewController.TransitionStyle = .scroll
    public var tabViewBackgroundHighlightColor:UIColor = Color.tabViewHighlight
    
    public var tabViewTextDefaultColor:UIColor = Color.textDefault
    public var tabViewTextHighlightColor:UIColor = Color.textHighlight
    
    public var tabViewPaddingLeft:CGFloat = 10.0
    public var tabViewPaddingRight:CGFloat = 10.0
    public var tabViewTextFont:UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    public var tabViewImageSize:CGSize = CGSize(width: 20, height: 20)
    public var tabViewImageMarginTop:CGFloat = 10
    public var tabViewImageMarginBottom:CGFloat = 5
    
    public var shadowColor: UIColor = UIColor.black
    public var shadowOpacity: Float = 0.3
    public var shadowOffset: CGSize = CGSize(width: 0, height: 3)
    public var shadowRadius: CGFloat = 3
    
    // Tab Indicator
    public var tabIndicatorViewHeight:CGFloat = 3
    public var tabIndicatorViewBackgroundColor:UIColor = Color.tabIndicator
    
    // ViewPager
    public var viewPagerTransitionStyle:UIPageViewController.TransitionStyle = .scroll
    
    public init() {}
    
    fileprivate struct Color {
        static let tabViewBackground = UIColor(red: 202 / 255.0, green: 200/255.0, blue: 201/255.0, alpha: 1.0)
        static let tabViewHighlight = tabViewBackground.withAlphaComponent(0.8)

        static let textDefault = UIColor.black
        static let textHighlight = UIColor.white
        
        static let tabIndicator =  UIColor.darkGray
    }
}
