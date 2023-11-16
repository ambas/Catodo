//
//  ContentView.swift
//  Catodo
//
//  Created by Ambas Chobsanti on 15/11/23.
//

import SwiftUI


typealias TaskID = String

@Observable final class Store {
    func addTask(_ item: Item) {
        items.append(item)
    }
    
    func delete(_ id: TaskID) {
        items.removeAll { $0.id == id }
    }
    
    func toggleComplete(_ id: TaskID) {
        let index = items.firstIndex { item in
            item.id == id
        }!
        items[index].isComplete.toggle()
        
        let incomplete = items.filter { !$0.isComplete }
        let complete = items.filter { $0.isComplete }
        items = incomplete + complete
    }
    
    private(set) var items: [Item] = Item.mock
    
}

struct Item: Identifiable, Equatable {
    let taskName: String
    var isComplete: Bool
    var id: String { taskName } // TODO: Make it to be proper id
    init(taskName: String, isComplete: Bool = false) {
        self.taskName = taskName
        self.isComplete = isComplete
    }
    
    static let mock = (0..<1).map { Item(taskName: "item : \($0)") }
}
struct ContentView: View {
    
    let store: Store = Store()
    @State private var newTaskTitle = ""
    @State private var showAddNewTaskAlert = false
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(store.items) { item in
                        ItemView(item: item, onDelete: { store.delete($0) })
                            .onTapGesture {
                                store.toggleComplete(item.id)
                            }
                        Divider()
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup {
                    Button(action: {
                        showAddNewTaskAlert = true
                    }, label: {
                        Image(systemName: "plus.app")
                    })
                    .keyboardShortcut("n")
                }
            }
            .alert("Add New Task", isPresented: $showAddNewTaskAlert) {
                TextField("new task", text: $newTaskTitle)
                Button("Add", action: { store.addTask(.init(taskName: newTaskTitle)); newTaskTitle = "" })
                Button("Cancle", action: { })
            }
        }
        .animation(.spring, value: store.items)
    }
}

struct ItemView: View {
    let item: Item
    let onDelete: (TaskID) -> Void
    let fontSize: CGFloat = 30
    
    var body: some View {
        VStack {
            HStack {
                Label(
                    title: { 
                        Text(item.taskName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    },
                    icon: { Image(systemName: item.isComplete ? "circle.fill" : "circle") }
                )
                .font(.system(size: fontSize))
                Button(action: { onDelete(item.id) }, label: {
                    Image(systemName: "bin.xmark.fill")
                })
            }
            .padding()
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    ContentView()
}

#Preview("Item View") {
    Group {
        ItemView(item: .init(taskName: "sample1"), onDelete: { _ in })
    }
}


