//
//  EventsPager.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 10/30/21.
//

import UIKit

public protocol EventsPagerDataSource: AnyObject {
    func numberOfPages() -> Int
    func viewControllerAtPosition(position: Int) -> UIViewController
    func tabsForPages() -> [String]
    func startEventsPagerAtIndex() -> Int
}


public protocol EventsPagerDelegate: AnyObject {
    func willMoveToControllerAtIndex(index: Int)
    func didMoveToControllerAtIndex(index: Int)
}

class EventsPager: NSObject {
    fileprivate weak var controller: UIViewController?
    fileprivate var view: UIView
    
    fileprivate var tabBarScrollView = UIScrollView()
    fileprivate var pageController: UIPageViewController?
    fileprivate weak var dataSource: EventsPagerDataSource?
    fileprivate weak var delegate: EventsPagerDelegate?
    
    fileprivate var tabIndicator = UIView()
    fileprivate var tabIndicatorLeadingConstraint: NSLayoutConstraint?
    fileprivate var tabIndicatorWidthConstraint: NSLayoutConstraint?
    
    fileprivate var options = EventsPagerConfig()
    fileprivate var currentPageIndex = 0
    fileprivate var tabsViewList = [EventsPagerTabView]()
    fileprivate var tabsList = [String]()
    
    public init(viewController: UIViewController) {
        self.controller = viewController
        self.view = viewController.view
    }
    
    public func setOptions(options: EventsPagerConfig) {
        self.options = options
    }
    
    public func setDataSource(dataSource: EventsPagerDataSource) {
        self.dataSource = dataSource
    }
    
    public func setDelegate(delegate: EventsPagerDelegate?) {
        self.delegate = delegate
    }
    
    public func build() {
        setupTabBarScrollView()
        setupPageViewController()
        setupTabAndIndicator()
    }
    
    fileprivate func setupTabAndIndicator() {
        guard let tabs = dataSource?.tabsForPages() else { return }
        self.tabsList = tabs
        setupTabsForNormalAndEqualDistribution()
        
        if options.isTabIndicatorAvailable {
            setupForAutolayout(view: tabIndicator, inView: tabBarScrollView)
            tabIndicator.backgroundColor = options.tabIndicatorViewBackgroundColor
            tabIndicator.heightAnchor.constraint(equalToConstant: options.tabIndicatorViewHeight).isActive = true
            tabIndicator.bottomAnchor.constraint(equalTo: tabBarScrollView.bottomAnchor).isActive = true
            guard tabsViewList.count > currentPageIndex else {
                return
            }
            let activeTab = self.tabsViewList[currentPageIndex]
            
            tabIndicatorLeadingConstraint = tabIndicator.leadingAnchor.constraint(equalTo: activeTab.leadingAnchor)
            tabIndicatorWidthConstraint = tabIndicator.widthAnchor.constraint(equalTo: activeTab.widthAnchor)
            
            tabIndicatorLeadingConstraint?.isActive = true
            tabIndicatorWidthConstraint?.isActive = true
        }
        
        if options.isTabHighlightAvailable {
            self.tabsViewList[currentPageIndex].addHighlight(options: self.options)
        }
        
        if options.isTabBarShadowAvailable {
            
            tabBarScrollView.layer.masksToBounds = false
            tabBarScrollView.layer.shadowColor = options.shadowColor.cgColor
            tabBarScrollView.layer.shadowOpacity = options.shadowOpacity
            tabBarScrollView.layer.shadowOffset = options.shadowOffset
            tabBarScrollView.layer.shadowRadius = options.shadowRadius
            
            view.bringSubviewToFront(tabBarScrollView)
        }
    }
    
    fileprivate func setupTabsForNormalAndEqualDistribution() {
        var maxWidth: CGFloat = 0
        
        var lastTab: EventsPagerTabView?
        
        for (index, eachTab) in tabsList.enumerated() {
            
            let tabView = EventsPagerTabView()
            setupForAutolayout(view: tabView, inView: tabBarScrollView)
            
            tabView.backgroundColor = options.tabViewBackgroundDefaultColor
            tabView.setup(tab: eachTab, options: options)
            
            if let previousTab = lastTab {
                tabView.leadingAnchor.constraint(equalTo: previousTab.trailingAnchor).isActive = true
            } else {
                tabView.leadingAnchor.constraint(equalTo: tabBarScrollView.leadingAnchor).isActive = true
            }
            
            tabView.topAnchor.constraint(equalTo: tabBarScrollView.topAnchor).isActive = true
            tabView.bottomAnchor.constraint(equalTo: tabBarScrollView.bottomAnchor).isActive = true
            tabView.heightAnchor.constraint(equalToConstant: options.tabViewHeight).isActive = true
            
            tabView.tag = index
            tabsViewList.append(tabView)
            
            maxWidth = max(maxWidth, tabView.width)
            lastTab = tabView
        }
        
        lastTab?.trailingAnchor.constraint(equalTo: tabBarScrollView.trailingAnchor).isActive = true
        
        // Second pass to set Width for all tabs
        tabsViewList.forEach { tabView in
            tabView.widthAnchor.constraint(equalToConstant: tabView.width).isActive = true
        }
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
        setupCurrentPageIndicator(currentIndex: index, previousIndex: currentPageIndex)
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
    
    
    private func setupPageViewController() {
        let pageController = UIPageViewController(
            transitionStyle: options.eventsPagerTransitionStyle,
            navigationOrientation: .horizontal, options: nil)
        
        self.controller?.addChild(pageController)
        setupForAutolayout(view: pageController.view, inView: view)
        pageController.didMove(toParent: controller)
        self.pageController = pageController
        
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        
        self.pageController?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.pageController?.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.pageController?.view.topAnchor.constraint(equalTo: tabBarScrollView.bottomAnchor).isActive = true
        self.pageController?.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        guard let dataSource = dataSource else {
            fatalError("ViewPagerDataSource not set")
        }
        
        self.currentPageIndex = dataSource.startEventsPagerAtIndex()
        if let firstPageController = getViewController(forPageAt: self.currentPageIndex) {
            self.pageController?.setViewControllers([firstPageController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    fileprivate func setupCurrentPageIndicator(currentIndex: Int, previousIndex: Int) {
        self.currentPageIndex = currentIndex
        
        let activeTab = tabsViewList[currentIndex]
        let activeFrame = activeTab.frame
        if options.isTabHighlightAvailable {
            self.tabsViewList[previousIndex].removeHighlight(options: self.options)
            UIView.animate(withDuration: 0.4, animations: {
                self.tabsViewList[currentIndex].addHighlight(options: self.options)
            })
        }
        
        if options.isTabIndicatorAvailable {
            tabIndicatorLeadingConstraint?.isActive = false
            tabIndicatorWidthConstraint?.isActive = false
            
            tabIndicatorLeadingConstraint = tabIndicator.leadingAnchor.constraint(equalTo: activeTab.leadingAnchor)
            tabIndicatorWidthConstraint = tabIndicator.widthAnchor.constraint(equalTo: activeTab.widthAnchor)
            
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5) {
                self.tabIndicatorWidthConstraint?.isActive = true
                self.tabIndicatorLeadingConstraint?.isActive = true
                self.tabBarScrollView.scrollRectToVisible(activeFrame, animated: false)
                self.tabBarScrollView.layoutIfNeeded()
            }
            return
        }
        self.tabBarScrollView.scrollRectToVisible(activeFrame, animated: true)
    }
}

extension EventsPager: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousController = getViewController(forPageAt: viewController.view.tag - 1)
        return previousController
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextController = getViewController(forPageAt: viewController.view.tag + 1)
        return nextController
    }
}


extension EventsPager: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageIndex = pageViewController.viewControllers?.first?.view.tag else { return }
        if completed && finished {
            setupCurrentPageIndicator(currentIndex: pageIndex, previousIndex: currentPageIndex)
            delegate?.didMoveToControllerAtIndex(index: pageIndex)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let pageIndex = pendingViewControllers.first?.view.tag
        delegate?.willMoveToControllerAtIndex(index: pageIndex!)
    }
    
    
    internal func setupForAutolayout(view: UIView?, inView parentView: UIView) {
        guard let v = view else { return }
        v.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(v)
    }
}
