import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/kenshin/Desktop/CoreData/MyCoreData/AddTaskView.swift", line: 1)
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
                TextField(__designTimeString("#21191_0", fallback: "入力"), text: $addText)
                
                Button(__designTimeString("#21191_1", fallback: "追加")) {
                    vm.addItem(text: addText)
                    dismiss()
                }
                .disabled(addText.isEmpty)
            }
            .navigationTitle(__designTimeString("#21191_2", fallback: "新規タスク"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddTaskView(vm: ListViewModel(context: PersistenceController.preview.container.viewContext))
}
