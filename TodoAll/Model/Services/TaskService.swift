//
//  TaskService.swift
//  TodoAll
//
//  Created by Franklin Cruz on 22/10/20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import UIKit
import Combine

protocol TaskService {
    var provider: Provider? { get }
    func getTasks(forUser user: Int) -> AnyPublisher<[Task], ServiceError>
}

class TaskServiceProvider {
    var provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func getTasks(forUser user: Int) -> AnyPublisher<[Task], ServiceError> {
        return provider.list()
            .eraseToAnyPublisher()
    }
}

#if DEBUG
class MockTaskService: TaskService {
    var provider: Provider? = nil
    
    func getTasks(forUser user: Int) -> AnyPublisher<[Task], ServiceError> {
        let mockData = [
            Task(id: 1, title: "My Mock task"),
            Task(id: 2, title: "My Mock task"),
            Task(id: 3, title: "My Mock task"),
            Task(id: 4, title: "My Mock task"),
        ]
        
        return Just(mockData)
            .mapError({ _ in ServiceError(code: -1, message: "never") })
            .eraseToAnyPublisher()
    }
}
#endif
