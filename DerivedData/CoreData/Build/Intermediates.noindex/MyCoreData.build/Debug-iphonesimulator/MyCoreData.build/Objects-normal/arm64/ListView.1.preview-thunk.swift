import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/kenshin/Desktop/CoreData/MyCoreData/ListView.swift", line: 1)
//
//  ContentView.swift
//  CoreData
//
//  Created by miyamotokenshin on R 7/11/14.
//

import SwiftUI
import CoreData

struct ListView: View {
    @StateObject var vm: ListViewModel
    
    init(context: NSManagedObjectContext) {
        _vm = StateObject(wrappedValue: ListViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                    TextField(__designTimeString("#21405_0", fallback: "検索"), text: $vm.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                if vm.items.isEmpty {
                    Text(__designTimeString("#21405_1", fallback: "まだタスクがありません"))
                        .foregroundColor(.gray)
                } else {
                    List {
                       // Arrayで.keysを配列にしている
                       // sectionedItemsには配列Itemとキー.keysが格納されてる
                       // .keysは日付
                        ForEach(Array(vm.sectionedItems.keys), id: \.self) { dateKey in
                            Section(header: Text(dateKey)) {

                                // 🔹 各セクションに対応する Item をループ
                                ForEach(vm.sectionedItems[dateKey] ?? []) { item in
                                    NavigationLink {
                                        EditTaskView(vm: vm, item: item)
                                    } label: {
                                        Text(item.text ?? __designTimeString("#21405_2", fallback: ""))
                                    }
                                }
                                .onDelete { indexSet in
                                    // セクション内で削除するには変換が必要（後で説明）
                                    vm.deleteItem(at: indexSet, in: dateKey)
                                }
                            }
                        }
                    }
                }
            }
            .onChange(of: vm.searchText) {
                vm.fetchItems()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.showAddTask = __designTimeBoolean("#21405_3", fallback: true)
                    } label: {
                        Image(systemName: __designTimeString("#21405_4", fallback: "plus.circle.fill"))
                    }
                }
            }
            .navigationTitle(__designTimeString("#21405_5", fallback: "リスト"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $vm.showAddTask) {
            AddTaskView(vm: vm)
        }
    }
}

#Preview {
    ListView(context: PersistenceController.preview.container.viewContext)
}
