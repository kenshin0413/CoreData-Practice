//
//  ListViewModel.swift
//  MyCoreData
//
//  Created by miyamotokenshin on R 7/11/14.
//

import Foundation
import CoreData
import Combine

class ListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var filteredItems: [Item] = []
    @Published var showAddTask = false
    @Published var searchText = ""
    @Published var sectionedItems: [String: [Item]] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchItems()
    }
    // 読み込み処理
    func fetchItems() {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        // 検索バーが空じゃなかったらpredicate実行
        if !searchText.isEmpty {
            request.predicate = NSPredicate(format: "text CONTAINS[c] %@", searchText)
        }
        
        do {
            // UIを更新　配列を新しいのに変更してる
            items = try context.fetch(request)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            let grouped = Dictionary(grouping: items) { item -> String in
                let date = item.createdAt ?? Date()
                return dateFormatter.string(from: date)
            }
            
            sectionedItems = grouped
                .sorted(by: { $0.key > $1.key })
                .reduce(into: [:]) { $0[$1.key] = $1.value }
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }
    
    func addItem(text: String) {
        let newItem = Item(context: context)
        newItem.text = text
        newItem.createdAt = Date()
        
        save()
        fetchItems() // リストを更新
    }
    
    func deleteItem(at offsets: IndexSet, in dateKey: String) {
        // 削除対象のセクション内アイテム一覧
        guard let sectionItems = sectionedItems[dateKey] else {
            // falseだった場合returnで終了
            // trueだった場合下を実行x
            return
        }
        
        // 削除するアイテムを取得
        let itemsToDelete = offsets.map { sectionItems[$0] }
        
        // CoreData から削除
        itemsToDelete.forEach { context.delete($0) }
        
        save()
        fetchItems()
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("❌ Save error: \(error.localizedDescription)")
        }
    }
    
    func update(item: Item, newText: String) {
        item.text = newText
        save()
        fetchItems()
    }
}
