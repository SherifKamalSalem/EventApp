//
//  EventsPager.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import UIKit

protocol EventsPagerDataSource: AnyObject {
    func numberOfPages() -> Int
    func viewControllerAtPosition(position: Int) -> UIViewController
    func tabsForPages() -> [String]
    func startEventsPagerAtIndex() -> Int
}


protocol EventsPagerDelegate: AnyObject {
    func willMoveToControllerAtIndex(index: Int)
    func didMoveToControllerAtIndex(index: Int)
}

class EventsPager {
    fileprivate weak var controller: UIViewController?
    fileprivate var view: UIView
    
    fileprivate var tabBarScrollView = UIScrollView()
    fileprivate var pageController: UIPageViewController?
    fileprivate weak var dataSource: EventsPagerDataSource?
    fileprivate weak var delegate: EventsPagerDelegate?
    
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
        let tapLocation = recognizer.location(in: self.tabBarScrollView)
        let tabViewTapped = tabBarScrollView.hitTest(tapLocation, with: nil)
        
        if let tabIndex = tabViewTapped?.tag, tabIndex != currentPageIndex {
            presentViewController(at: tabIndex)
        }
    }
    
    private func getViewController(forPageAt index: Int) -> UIViewController? {
        guard let viewPagerSource = dataSource, index >= 0 && index < viewPagerSource.numberOfPages() else {
            return nil
        }
        
        let pageItemViewController = viewPagerSource.viewControllerAtPosition(position: index)
        pageItemViewController.view.tag = index
        return pageItemViewController
    }
    
    
    private func presentViewController(at index: Int) {
        guard let selectedViewController = getViewController(forPageAt: index) else {
            fatalError("There is no view controller for tab at index: \(index)")
        }
        
        let previousIndex = currentPageIndex
        let direction:UIPageViewController.NavigationDirection = (index > previousIndex ) ? .forward : .reverse
        
        
        delegate?.willMoveToControllerAtIndex(index: index)
        pageController?.setViewControllers([selectedViewController], direction: direction, animated: true, completion: { (isCompleted) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.pageController?.setViewControllers([selectedViewController], direction: direction, animated: false, completion: { (isComplete) in
                    guard isComplete else { return }
                    self.delegate?.didMoveToControllerAtIndex(index: index)
                })
            }
        })
    }
}
