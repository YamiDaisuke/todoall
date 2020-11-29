//
//  TaskRowViewModel.swift
//  TodoAll
//
//  Created by Franklin Cruz on 22/10/20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//
import Foundation
import Combine

class TaskRowViewModel: ObservableObject, Identifiable {
    @Published var task: Task
    @Published var completed = false

    private let service: TaskService
    private var disposables = Set<AnyCancellable>()

    init(service: TaskService, task: Task, scheduler: DispatchQueue = DispatchQueue(label: "TaskRowViewModel")) {
        self.service = service
        self.task = task
        
        $completed
            .dropFirst()
            .debounce(for: .seconds(0.1), scheduler: scheduler)
            .sink(receiveValue: update(taskStatus:))
            .store(in: &disposables)
    }

    func update(taskStatus status: Bool) {
        // TODO:
    }
}
