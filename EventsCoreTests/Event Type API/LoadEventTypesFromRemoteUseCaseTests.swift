//
//  LoadEventTypesFromRemoteUseCaseTests.swift
//  EventsCoreTests
//
//  Created by Sherif Kamal on 10/28/21.
//

import XCTest
import EventsCore

class LoadEventTypesFromRemoteUseCaseTests: XCTestCase {
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteEventTypesLoader.Error.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let eventType1 = makeEventType(id: "id", name: "name")
        let eventType2 = makeEventType(id: "another id", name: "another name")
        
        let eventTypes = [eventType1.model, eventType2.model]
        
        expect(sut, toCompleteWith: .success(eventTypes), when: {
            let json = makeJSONObjects([eventType1.json, eventType2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteEventTypesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteEventTypesLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteEventTypesLoader, toCompleteWith expectedResult: RemoteEventTypesLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteEventTypesLoader.Error), .failure(expectedError as RemoteEventTypesLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeEventType(id: String, name: String) ->  (model: EventType, json: [String: Any]) {
        let item = EventType(id: id, name:name)
        
        let json = [
            "id": id,
            "name": name
        ].compactMapValues { $0 }
        
        return (item, json)
    }
}
