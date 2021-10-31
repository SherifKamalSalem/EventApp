//
//  EventsCoreAPIEndToEndTests.swift
//  EventsCoreAPIEndToEndTests
//
//  Created by Sherif Kamal on 10/29/21.
//

import XCTest
import EventsCore

class EventsCoreAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETEventTypesResult_matchesFixedTestAccountData() {
        switch getEventTypesResult() {
        case let .success(eventTypes)?:
            XCTAssertEqual(eventTypes.count, 4, "Expected 4 items in the test account")
            XCTAssertEqual(eventTypes[0], expectedEventType(at: 0))
            XCTAssertEqual(eventTypes[1], expectedEventType(at: 1))
            XCTAssertEqual(eventTypes[2], expectedEventType(at: 2))
            XCTAssertEqual(eventTypes[3], expectedEventType(at: 3))
        case let .failure(error)?:
            XCTFail("Expected successful events result, got \(error) instead")
            
        default:
            XCTFail("Expected successful events result, got no result instead")
        }
    }
    
    func test_endToEndTestServerGETEventListResult_matchesFixedTestAccountData() {
        switch getEventListingResult() {
        case let .success(events)?:
            XCTAssertEqual(events.count, 8, "Expected 8 items in the test account")
            XCTAssertEqual(events[0], expectedEvent(at: 0))
            XCTAssertEqual(events[1], expectedEvent(at: 1))
            XCTAssertEqual(events[2], expectedEvent(at: 2))
            XCTAssertEqual(events[3], expectedEvent(at: 3))
            XCTAssertEqual(events[4], expectedEvent(at: 4))
            XCTAssertEqual(events[5], expectedEvent(at: 5))
            XCTAssertEqual(events[6], expectedEvent(at: 6))
            XCTAssertEqual(events[7], expectedEvent(at: 7))
        case let .failure(error)?:
            XCTFail("Expected successful events result, got \(error) instead")
            
        default:
            XCTFail("Expected successful events result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getEventTypesResult(file: StaticString = #file, line: UInt = #line) ->  Swift.Result<[EventType], Error>? {
        let testServerURL = URL(string: "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/eventtypes")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteEventTypesLoader(url: testServerURL, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: EventLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }
    
    private func getEventListingResult(file: StaticString = #file, line: UInt = #line) -> Swift.Result<[Event], Error>? {
        let testServerURL = URL(string: "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/events?event_type=Sports&page=1")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteEventListingLoader(url: testServerURL, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: Swift.Result<[Event], Error>?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }
}

private extension EventsCoreAPIEndToEndTests {
    private func expectedEventType(at index: Int) -> EventType {
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


private extension EventsCoreAPIEndToEndTests {
    private func expectedEvent(at index: Int) -> Event {
        return Event(id: eventId(at: index), name: eventName(at: index), longitude: longitude(at: index), latitude: latitude(at: index), startDate: startDate(at: index), endDate: endDate(at: index), description: eventDescription, cover: cover)
    }
    
    private func eventId(at index: Int) -> String {
        return [
            "5aa9888a039aec632d2aa54d",
            "5aa9888a368eb48586024b18",
            "5aa9888a768d591cb625255e",
            "5aa9888a2b87d5a7b419d429",
            "5aa9888aa7d2b73961131243",
            "5aa9888a22114eedc1c96304",
            "5aa9888a8690607204ba17ea",
            "5aa9888ae12ea1898d74c3ab"
        ][index]
    }
    
    private func eventName(at index: Int) -> String {
        return [
            "BEFORE THE REVOLUTION",
            "BEFORE THE REVOLUTION",
            "VAVOOM FESTIVAL",
            "RIDE WITH THE PHARAOHS",
            "EGYPTIAN CONTEMPORARY DANCE PROGRAMME",
            "TAREK YAMANI AND OUT OF NATIONS",
            "OMAR KHAIRAT MARCH CONCERTS",
            "OMAR KHAIRAT MARCH CONCERTS"
        ][index]
    }
    
    private var eventDescription: String {
        return "Living up to the challenges we face isn’t an edge to acquire but a necessity to live by. A startup, an individual, an investor or an entity, located in the MENA region or beyond, we were all faced by the same challenge"
    }
    
    private var cover: String {
        return "https://www.newstatesman.com/sites/all/themes/creative-responsive-theme/images/new_statesman_events.jpg"
    }
    
    private func startDate(at index: Int) -> String {
        return [
            "Wednesday, September 7, 2016 3:29 PM",
            "Wednesday, April 29, 2015 11:00 AM",
            "Thursday, January 5, 2017 8:37 AM",
            "Sunday, October 22, 2017 12:27 AM",
            "Tuesday, August 9, 2016 6:13 PM",
            "Sunday, May 15, 2016 2:52 PM",
            "Thursday, June 5, 2014 10:39 PM",
            "Friday, December 5, 2014 2:46 PM",
        ][index]
    }
    
    private func endDate(at index: Int) -> String {
        return [
            "Saturday, December 3, 2016 8:50 AM",
            "Wednesday, September 2, 2015 5:39 PM",
            "Tuesday, February 7, 2017 3:31 PM",
            "Friday, July 29, 2016 3:36 AM",
            "Tuesday, November 17, 2015 4:37 PM",
            "Thursday, January 22, 2015 6:02 PM",
            "Sunday, July 10, 2016 4:52 PM",
            "Saturday, January 6, 2018 11:44 PM",
        ][index]
    }
    
    private func longitude(at index: Int) -> String {
        return [
            "32.51794",
            "34.06669",
            "33.26718",
            "32.72019",
            "30.46614",
            "28.40495",
            "28.53383",
            "31.54933",
        ][index]
    }
    
    private func latitude(at index: Int) -> String {
        return [
            "28.99553",
            "29.49126",
            "26.4062",
            "26.52392",
            "30.5843",
            "27.37457",
            "24.91903",
            "25.44811",
        ][index]
    }
}
