//
//  EventsPagerTabView.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/1/21.
//

import UIKit

public final class EventsPagerTabView: UIView {
    
    internal var titleLabel:UILabel?
    internal var imageView:UIImageView?
    internal var width: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setup(tab: String, options: EventsPagerConfig) {
        buildTitleLabel(withOptions: options, text: tab)
        
        setupForAutolayout(view: titleLabel)
        titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        titleLabel?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        let labelWidth = titleLabel!.intrinsicContentSize.width + options.tabViewPaddingLeft + options.tabViewPaddingRight
        self.width = labelWidth
    }
    
    fileprivate func buildTitleLabel(withOptions options: EventsPagerConfig, text: String) {
        
        titleLabel = UILabel()
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = options.tabViewTextDefaultColor
        titleLabel?.numberOfLines = 2
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = options.tabViewTextFont
        titleLabel?.text = text
    }
    
    internal func addHighlight(options: EventsPagerConfig) {
        
        self.backgroundColor = options.tabViewBackgroundHighlightColor
        self.titleLabel?.textColor = options.tabViewTextHighlightColor
    }
    
    internal func removeHighlight(options: EventsPagerConfig) {
        
        self.backgroundColor = options.tabViewBackgroundDefaultColor
        self.titleLabel?.textColor = options.tabViewTextDefaultColor
    }
    
    internal func setupForAutolayout(view: UIView?) {
        
        guard let v = view else { return }
        
        v.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v)
    }
}
