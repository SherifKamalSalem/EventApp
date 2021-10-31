//
//  EventsPlatformTests.swift
//  EventsPlatformTests
//
//  Created by Sherif Kamal on 10/30/21.
//

import XCTest
import EventsPlatform
import EventsCore

class EventsPlatformTests: XCTestCase {
    func test_didStartLoadingEvents_startsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingEvents()
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingEvents_displaysEventsAndStopsLoading() {
        let (sut, view) = makeSUT()
        let events = makeEvents()
        
        sut.didFinishLoadingEvents(with: events)
        
        XCTAssertEqual(view.messages, [
            .display(events: events),
            .display(isLoading: false),
        ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: EventsListingPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = EventsListingPresenter(loadingView: view, eventsView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    func makeEvents() -> [Event] {
        return [
            Event(id: "any", name: "any", longitude: "any", latitude: "any", startDate: "any", endDate: "any", description: "any", cover: "any"),
            Event(id: "any", name: "any", longitude: "any", latitude: "any", startDate: "any", endDate: "any", description: "any", cover: "any")
        ]
    }
    
    private class ViewSpy: EventsLoadingView, EventsView {
        
        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(events: [Event])
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: EventsViewModelPresentable) {
            messages.insert(.display(events: viewModel.events))
        }
        
        func display(_ viewModel: EventsLoadingViewModelPresentable) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
    }
}
