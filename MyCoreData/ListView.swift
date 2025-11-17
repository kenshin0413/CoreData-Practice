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
                    TextField("検索", text: $vm.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                if vm.items.isEmpty {
                    Text("まだタスクがありません")
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
                                        Text(item.text ?? "")
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
                        vm.showAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("リスト")
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
