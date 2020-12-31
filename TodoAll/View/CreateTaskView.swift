//
//  CreateTaskView.swift
//  TodoAll
//
//  Created by Franklin Cruz on 28-10-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import SwiftUI

struct CreateTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CreateTaskViewModel
    @Binding var presented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("New Task").font(.title)
                Spacer()
            }.padding()
            
            TextField("Title", text: self.$viewModel.title )
                .padding()
            
            DatePicker("Due Date", selection: self.$viewModel.dueDate)
                .padding()
            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                TextEditor(text: $viewModel.taskDescription)
                    .background(Color.clear)
                    .padding()
                
                if self.viewModel.taskDescription.isEmpty {
                    Text("Description")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .padding(.top, 8)
                        .padding(.leading, 2)
                        .padding()
                        .disabled(true)
                        .allowsHitTesting(false)
                }
            }
            
            TagCloud(tags: self.$viewModel.tags, isEditing: true)
                .padding()
            
            HStack {
                Spacer()
                Button(self.viewModel.saving ? "Saving..." : "Save") {
                    self.viewModel.save()
                }.disabled(!self.viewModel.valid || self.viewModel.saving)
                
                if self.viewModel.saving && !self.viewModel.saved {
                    ProgressView()
                        .padding([.leading], 8)
                        .padding([.trailing])
                        // A trick to dimiss this sheet only after
                        // the saving process have finish
                        .onDisappear {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
            }.padding()
            
            
        }
    }
}

struct CreateTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let mock = MockTaskService()

        let vm = CreateTaskViewModel(service: mock, userId: 1)
        CreateTaskView(viewModel: vm, presented: .constant(true))
    }
}
