//
//  EditTaskView.swift
//  MyCoreData
//
//  Created by miyamotokenshin on R 7/11/15.
//

import SwiftUI

struct EditTaskView: View {
    @ObservedObject var vm: ListViewModel
    @Environment(\.dismiss) var dismiss
    @State private var text: String
    var item: Item
    
    init(vm: ListViewModel, item: Item) {
        self.vm = vm
        self.item = item
        _text = State(initialValue: item.text ?? "")
    }

    var body: some View {
        Form {
            TextField("編集", text: $text)

            Button("保存") {
                vm.update(item: item, newText: text)
                dismiss()
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sample = Item(context: context)
    sample.text = "プレビュー用"
    sample.createdAt = Date()

    return EditTaskView(
        vm: ListViewModel(context: context),
        item: sample
    )
}
