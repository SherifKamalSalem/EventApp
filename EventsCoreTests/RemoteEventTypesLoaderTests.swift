//
//  RemoteEventTypesLoaderTests.swift
//  EventsCoreTests
//
//  Created by Sherif Kamal on 10/28/21.
//

import XCTest
import EventsCore

class RemoteEventTypesLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
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
            let json = makeEventTypesJSON([eventType1.json, eventType2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteEventTypesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteEventTypesLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteEventTypesLoader, toCompleteWith result: RemoteEventTypesLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteEventTypesLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeEventType(id: String, name: String) ->  (model: EventType, json: [String: Any]) {
        let item = EventType(id: id, name:name)
        
        let json = [
            "id": id,
            "name": name
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeEventTypesJSON(_ types: [[String: Any]]) -> Data {
        let json = types
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
                
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success((data, response)))
        }
    }
}
