//
//  TaskListView.swift
//  TodoAll
//
//  Created by Franklin Cruz on 22/10/20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import SwiftUI
import Combine

struct TaskListView: View {

    @ObservedObject var viewModel: TaskListViewModel

    var emptySection: some View {
        Section {
            Text("No results")
                .foregroundColor(.gray)
        }
    }

    var taskList: some View {
        Section {
            ForEach(self.viewModel.dataSource) { task in
                return TaskRowView(viewModel: task)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                if viewModel.dataSource.isEmpty {
                    emptySection
                } else {
                    taskList
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("My Tasks")
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let mock = MockTaskService()
        let vm = TaskListViewModel(service: mock, userId: 1)
        return TaskListView(viewModel: vm)
    }
}
