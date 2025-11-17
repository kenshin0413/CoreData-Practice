//
//  AddTaskView.swift
//  CoreData
//
//  Created by miyamotokenshin on R 7/11/14.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var vm: ListViewModel
    @Environment(\.dismiss) var dismiss

    @State private var addText: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("入力", text: $addText)
                
                Button("追加") {
                    vm.addItem(text: addText)
                    dismiss()
                }
                .disabled(addText.isEmpty)
            }
            .navigationTitle("新規タスク")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddTaskView(vm: ListViewModel(context: PersistenceController.preview.container.viewContext))
}
