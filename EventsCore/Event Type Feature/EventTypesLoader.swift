//
//  EventTypesLoader.swift
//  EventsCore
//
//  Created by Sherif Kamal on 10/28/21.
//

import Foundation

protocol EventTypesLoader {
    func load(completion: @escaping (Result<[EventType], Error>) -> Void)
}
