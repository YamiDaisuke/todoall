//
//  TaskCreateViewModel.swift
//  TodoAll
//
//  Created by Franklin Cruz on 28-10-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//
import Foundation
import Combine

class CreateTaskViewModel: ObservableObject, Identifiable {
    @Published var title: String = ""
    @Published var taskDescription: String?
    @Published var dueDate: Date?
    @Published var duration: TimeInterval?
    @Published var tags: [String] = []
    
    @Published var valid: Bool = false
    @Published var saved: Bool = false

    private let service: TaskService
    private var disposables = Set<AnyCancellable>()

    init(service: TaskService, userId: Int, scheduler: DispatchQueue = DispatchQueue(label: "TaskListViewModel")) {
        self.service = service

        self.$title
            .dropFirst()
            .debounce(for: .seconds(0.1), scheduler: scheduler)
            .sink { [weak self] value in
                guard let `self` = self else { return }
                guard value.count > 0 else { self.valid = false; return }
                self.valid = true
            }.store(in: &disposables)
    }

    func save() {
        let task = Task(
            id: nil,
            title: self.title,
            description: self.taskDescription,
            dueDate: self.dueDate,
            duration: self.duration,
            tags: self.tags,
            completed: false
        )
        
        self.service.create(task: task)
            .receive(on: DispatchQueue.main)
            .sink { [weak self](value) in
                switch value {
                case .finished:
                    break
                case .failure(let e):
                    print("Error: \(e)")
                    self?.saved = false
                }
            } receiveValue: { (data) in
                self.saved = true
            }.store(in: &self.disposables)
    }
}
