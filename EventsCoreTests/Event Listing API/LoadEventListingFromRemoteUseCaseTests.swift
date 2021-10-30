//
//  LoadEventListingFromRemoteUseCaseTests.swift
//  EventsCoreTests
//
//  Created by Sherif Kamal on 10/30/21.
//

import XCTest
import EventsCore

class LoadEventListingFromRemoteUseCaseTests: XCTestCase {
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteEventListingLoader.Error.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let event1 = makeEvent(id: "id1", longitude: "longitude1", latitude: "latitude1", name: "name1", startDate: "startDate1", endDate: "endDate1", welcomeDescription: "welcomeDescription1", cover: "cover1")
        let event2 = makeEvent(id: "id2", longitude: "longitude2", latitude: "latitude2", name: "name2", startDate: "startDate2", endDate: "endDate2", welcomeDescription: "welcomeDescription2", cover: "cover2")
        
        let events = [event1.model, event2.model]
        
        expect(sut, toCompleteWith: .success(events), when: {
            let json = makeJSONObjects([event1.json, event2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteEventListingLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteEventListingLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteEventListingLoader, toCompleteWith expectedResult: RemoteEventListingLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteEventListingLoader.Error), .failure(expectedError as RemoteEventListingLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeEvent(id: String, longitude: String, latitude: String, name: String, startDate: String, endDate: String, welcomeDescription: String, cover: String) ->  (model: Event, json: [String: Any]) {
        let item = Event(id: id, name: name, longitude: longitude, latitude: latitude, startDate: startDate, endDate: endDate, welcomeDescription: welcomeDescription, cover: cover)
        
        let json = [
            "id": id,
            "longitude": longitude,
            "latitude": latitude,
            "name": name,
            "startDate": startDate,
            "endDate": endDate,
            "welcomeDescription": welcomeDescription,
            "cover": cover
        ].compactMapValues { $0 }
        
        return (item, json)
    }
}

