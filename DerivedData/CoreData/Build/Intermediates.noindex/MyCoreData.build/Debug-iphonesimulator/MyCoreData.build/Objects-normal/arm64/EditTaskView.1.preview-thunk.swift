import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/kenshin/Desktop/CoreData/MyCoreData/EditTaskView.swift", line: 1)
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
            TextField(__designTimeString("#25790_0", fallback: "編集"), text: $text)

            Button(__designTimeString("#25790_1", fallback: "保存")) {
                vm.update(item: item, newText: text)
                dismiss()
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sample = Item(context: context)
    sample.text = __designTimeString("#25790_2", fallback: "プレビュー用")
    sample.createdAt = Date()

    return EditTaskView(
        vm: ListViewModel(context: context),
        item: sample
    )
}
