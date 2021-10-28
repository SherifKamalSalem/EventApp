//
//  RemoteEventTypesLoaderTests.swift
//  EventsCoreTests
//
//  Created by Sherif Kamal on 10/28/21.
//

import XCTest

class RemoteEventTypesLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteEventTypesLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteEventTypesLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
