//
//  HTTPClient.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/29/21.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<HTTPURLResponse, Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
