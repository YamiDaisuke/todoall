//
//  HomeView.swift
//  TodoAll
//
//  Created by Franklin Cruz on 28-10-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: TaskListViewModel
    
    @State var showCreateSheet = false
    
    var body: some View {
        NavigationView {
            TaskListView(viewModel: self.viewModel)
                .navigationBarTitle("My TODO", displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: {}) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(Color(.systemTeal))
                            .onTapGesture {
                                self.showCreateSheet.toggle()
                            }
                    }
                )
        }.sheet(isPresented: self.$showCreateSheet, onDismiss: {
            self.viewModel.refresh()
        }, content: {
            CreateTaskView(viewModel: self.viewModel.getCreateViewModel())
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mock = MockTaskService()
        let vm = TaskListViewModel(service: mock, userId: 1)
        HomeView(viewModel: vm)
    }
}
