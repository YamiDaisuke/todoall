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
    
    var body: some View {
        VStack {
            HStack {
                Text("New Task").font(.title)
                Spacer()
            }.padding()
            TextField("Title", text:$viewModel.title )
                .padding()
            
            HStack {
                Spacer()
                Button("Save") {
                    self.viewModel.save()
                    self.presentationMode.wrappedValue.dismiss()
                }.disabled(!viewModel.valid)
            }.padding()
        }
    }
}

struct CreateTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let mock = MockTaskService()

        let vm = CreateTaskViewModel(service: mock, userId: 1)
        CreateTaskView(viewModel: vm)
    }
}
