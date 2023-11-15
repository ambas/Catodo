//
//  ContentView.swift
//  Catodo
//
//  Created by Ambas Chobsanti on 15/11/23.
//

import SwiftUI

struct Item: Identifiable {
    let taskName: String
    let isComplete: Bool
    var id: String { taskName }
    init(taskName: String, isComplete: Bool = false) {
        self.taskName = taskName
        self.isComplete = isComplete
    }
}
let mock = (0..<10).map { Item(taskName: "item : \($0)") }
struct ContentView: View {
    @State var items: [Item] = mock
    var body: some View {
        LazyVStack {
            ScrollView {
                ForEach(items) { item in
                    ItemView(item)
                        .onTapGesture {
                            print("aa")
                        }
                    Divider()
                }
            }
        }
    }
}

struct ItemView: View {
    let item: Item
    let fontSize: CGFloat = 30
    
    init(_ item: Item) {
        self.item = item
    }
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
            }
            .padding()
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 500, height: 500)
}

#Preview("Item View") {
    Group {
        ItemView(.init(taskName: "sample1"))
        ItemView(.init(taskName: "sample2", isComplete: true))
    }
}


