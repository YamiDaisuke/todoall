//
//  Provider.swift
//  TodoAll
//
//  Created by Franklin Cruz on 27-10-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import Foundation
import Combine

enum SortDirection {
    case ascending
    case descending
}

protocol Store {
    func list<T>(filter: [String:Any]?, sort: [String: SortDirection]?) -> Future<[T], ServiceError>  where T: Entity
    func get<T>(byId id: T.ID) -> Future<T?, ServiceError>  where T: Entity
    func create<T>(_ element: T) -> Future<T?, ServiceError> where T: Entity
    func update<T>(_ element: T) -> Future<T?, ServiceError> where T: Entity
    func delete<T>(byId id: T.ID) -> Future<T?, ServiceError>  where T: Entity
}

extension Store {
    func list<T>(filter: [String:Any]? = nil, sort: [String: SortDirection]? = nil) -> Future<[T], ServiceError>  where T: Entity {
        return list(filter: filter, sort: sort)
    }
}

class DefaultStore {
    public static var shared: Store! 
}
