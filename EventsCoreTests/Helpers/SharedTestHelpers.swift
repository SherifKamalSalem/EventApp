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
