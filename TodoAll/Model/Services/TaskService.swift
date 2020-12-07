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
    var store: Store? { get set }
    func getTasks(forUser user: Int) -> AnyPublisher<[Task], ServiceError>
    func create(task: Task) -> AnyPublisher<Task?, ServiceError>
    func update(task: Task) -> AnyPublisher<Task?, ServiceError>
}

class TaskServiceProvider: TaskService {
    var store: Store?
    
    init(store: Store = DefaultStore.shared) {
        self.store = store
    }
    
    func getTasks(forUser user: Int) -> AnyPublisher<[Task], ServiceError> {
        return store!.list().eraseToAnyPublisher()
    }
    
    func create(task: Task) -> AnyPublisher<Task?, ServiceError> {
        return store!.create(task).eraseToAnyPublisher()
    }
    
    func update(task: Task) -> AnyPublisher<Task?, ServiceError> {
        return store!.update(task).eraseToAnyPublisher()
    }
}

#if DEBUG
class MockTaskService: TaskService {
    var store: Store?

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
    
    func create(task: Task) -> AnyPublisher<Task?, ServiceError> {
        var task = task
        task.id = 1
        
        return Just(task)
            .mapError({ _ in ServiceError(code: -1, message: "never") })
            .eraseToAnyPublisher()
    }
    
    func update(task: Task) -> AnyPublisher<Task?, ServiceError> {
        return Just(task)
            .mapError({ _ in ServiceError(code: -1, message: "never") })
            .eraseToAnyPublisher()
    }
}
#endif
