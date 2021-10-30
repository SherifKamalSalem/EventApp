//
//  EventsPager.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import UIKit

public class EventsPager {
    fileprivate weak var controller: UIViewController?
    fileprivate var view: UIView
    
    fileprivate var tabBarScrollView = UIScrollView()
    fileprivate var pageController: UIPageViewController?
    
    fileprivate var options = EventsPagerConfig()
    fileprivate var currentPageIndex = 0
    
    public init(viewController: UIViewController) {
        self.controller = viewController
        self.view = viewController.view
    }
    
    fileprivate func setupTabBarScrollView() {
        setupTabBarConstraints()
        if #available(iOS 11.0, *) {
            let safeArea = view.safeAreaLayoutGuide
            tabBarScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        } else {
            let marginGuide = view.layoutMarginsGuide
            tabBarScrollView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        }
        tabBarScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabBarScrollViewTapped(_:))))
    }
    
    fileprivate func setupTabBarConstraints() {
        tabBarScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarScrollView)
        
        tabBarScrollView.backgroundColor = options.tabViewBackgroundDefaultColor
        tabBarScrollView.isScrollEnabled = true
        tabBarScrollView.showsVerticalScrollIndicator = false
        tabBarScrollView.showsHorizontalScrollIndicator = false
        
        tabBarScrollView.heightAnchor.constraint(equalToConstant: options.tabViewHeight).isActive = true
        tabBarScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBarScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabBarScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    // MARK:- Actions
    @objc func tabBarScrollViewTapped(_ recognizer: UITapGestureRecognizer) {
        
    }
}
