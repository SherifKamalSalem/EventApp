//
//  EventLoadingView.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/31/21.
//

import Foundation

public struct EventsLoadingViewModelPresentable {
    public let isLoading: Bool
    
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}

public protocol EventsLoadingView {
    func display(_ viewModel: EventsLoadingViewModelPresentable)
}
