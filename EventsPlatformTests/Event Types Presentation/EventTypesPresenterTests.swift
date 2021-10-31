//
//  EventTypesPresenterTests.swift
//  EventsPlatformTests
//
//  Created by Sherif Kamal on 10/31/21.
//

import XCTest
import EventsPlatform
import EventsCore

class EventTypesTests: XCTestCase {
    func test_didStartLoadingEvents_startsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingEventTypes()
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingEvents_displaysEventsAndStopsLoading() {
        let (sut, view) = makeSUT()
        let eventTypes = makeEventTypes()
        
        sut.didFinishLoadingEventTypes(with: eventTypes)
        
        XCTAssertEqual(view.messages, [
            .display(events: eventTypes),
            .display(isLoading: false),
        ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: EventTypesPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = EventTypesPresenter(loadingView: view, eventTypesView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    func makeEventTypes() -> [EventType] {
        return [
            EventType(id: "any", name: "any"),
            EventType(id: "any", name: "any")
        ]
    }
    
    private class ViewSpy: EventsLoadingView, EventTypesView {
        
        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(events: [EventType])
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: EventTypesViewModelPresentable) {
            messages.insert(.display(events: viewModel.eventTypes))
        }
        
        func display(_ viewModel: EventsLoadingViewModelPresentable) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
    }
}
