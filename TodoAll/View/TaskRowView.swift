//
//  TaskRowView.swift
//  TodoAll
//
//  Created by Franklin Cruz on 22/10/20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import SwiftUI

struct TaskRowView: View {

    @ObservedObject var viewModel: TaskRowViewModel

    var body: some View {
        HStack {
            TaskCheckMark(isOn: Binding<Bool>(
                get: {self.viewModel.completed },
                set: {self.viewModel.completed = $0}
            ), size: 20)
            Text("\(viewModel.task.title)")
            Spacer()
        }.padding()
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        let mock = MockTaskService()

        let vm = TaskRowViewModel(service: mock, task: Task(id: 1, title: "My Task"))
        return TaskRowView(viewModel: vm)
    }
}
