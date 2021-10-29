//
//  EventsCoreAPIEndToEndTests.swift
//  EventsCoreAPIEndToEndTests
//
//  Created by Sherif Kamal on 10/29/21.
//

import XCTest
import EventsCore

class EventsCoreAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {
        switch getFeedResult() {
        case let .success(eventTypes)?:
            XCTAssertEqual(eventTypes.count, 4, "Expected 4 items in the test account")
            XCTAssertEqual(eventTypes[0], expectedOEventType(at: 0))
            XCTAssertEqual(eventTypes[1], expectedOEventType(at: 1))
            XCTAssertEqual(eventTypes[2], expectedOEventType(at: 2))
            XCTAssertEqual(eventTypes[3], expectedOEventType(at: 3))
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
            
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getFeedResult(file: StaticString = #file, line: UInt = #line) ->  EventTypesLoader.Result? {
        let testServerURL = URL(string: "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/eventtypes")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteEventTypesLoader(url: testServerURL, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: EventTypesLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }
    
    private func expectedOEventType(at index: Int) -> EventType {
        return EventType(
            id: id(at: index),
            name: name(at: index))
    }
    
    private func id(at index: Int) -> String {
        return [
            "5aa98d9fd7306cec6835667c",
            "5aa98d9f57fbc42a8f4f3260",
            "5aa98d9f4871099fdf896edf",
            "5aa98d9f7f5b7afd0770ebbf"
        ][index]
    }
    
    private func name(at index: Int) -> String {
        return [
            "Sports",
            "Entertainments",
            "Music",
            "Business"
        ][index]
    }
}
