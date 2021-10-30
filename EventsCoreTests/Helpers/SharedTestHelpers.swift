//
//  SharedTestHelpers.swift
//  EventsCoreTests
//
//  Created by Sherif Kamal on 10/29/21.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyHTTPURLResponse() -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
}

func nonHTTPURLResponse() -> URLResponse {
    return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}

func makeJSONObjects(_ objects: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: objects)
}
