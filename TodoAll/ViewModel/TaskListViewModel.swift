//
//  TaskListViewModel.swift
//  TodoAll
//
//  Created by Franklin Cruz on 22/10/20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//
import Foundation
import Combine

class TaskListViewModel: ObservableObject, Identifiable {
    @Published var userId: Int = 1
    @Published var dataSource: [TaskRowViewModel] = []

    private let service: TaskService
    private var disposables = Set<AnyCancellable>()

    init(service: TaskService, userId: Int, scheduler: DispatchQueue = DispatchQueue(label: "TaskListViewModel")) {
        self.service = service

        $userId
            .dropFirst()
            .debounce(for: .seconds(0.1), scheduler: scheduler)
            .sink(receiveValue: fetchTasks(forUser:))
            .store(in: &disposables)

        self.userId = userId
    }

    func refresh() {
        self.fetchTasks(forUser: self.userId)
    }
    
    func fetchTasks(forUser userId: Int) {
        self.service.getTasks(forUser: userId)
            .receive(on: DispatchQueue.main)
            .map({ [weak self] response -> [TaskRowViewModel] in
                guard let `self` = self else { return [] }
                return response.map({ TaskRowViewModel(service: self.service, task: $0) })
            })
            .sink(receiveCompletion: { [weak self] (value) in
                guard let `self` = self else { return }
                switch value {
                case.failure:
                    self.dataSource = []
                case .finished:
                    break
                }
            }) { [weak self] (data) in
                guard let self = self else { return }
                self.dataSource = data
        }
        .store(in: &self.disposables)
    }
    
    func getCreateViewModel() -> CreateTaskViewModel {
        let vm = CreateTaskViewModel(service: self.service, userId: self.userId)
        return vm
    }
}
