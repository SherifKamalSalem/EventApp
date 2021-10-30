//
//  EventsPlatformTests.swift
//  EventsPlatformTests
//
//  Created by Sherif Kamal on 10/30/21.
//

import XCTest
import EventsCore

struct EventsLoadingViewModelPresentable {
    let isLoading: Bool
}

protocol EventsLoadingView {
    func display(_ viewModel: EventsLoadingViewModelPresentable)
}

final class EventsListingPresenter {
    private let loadingView: EventsLoadingView
    
    init(loadingView: EventsLoadingView) {
        self.loadingView = loadingView
    }
    
    func didStartLoadingEvents() {
        loadingView.display(EventsLoadingViewModelPresentable(isLoading: true))
    }
}


class EventsPlatformTests: XCTestCase {
    func test_didStartLoadingEvents_startsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingEvents()
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: true)
        ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: EventsListingPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = EventsListingPresenter(loadingView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    
    private class ViewSpy: EventsLoadingView {
        enum Message: Hashable {
            case display(isLoading: Bool)
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: EventsLoadingViewModelPresentable) {
            messages.insert(.display(isLoading: true))
        }
    }
}
