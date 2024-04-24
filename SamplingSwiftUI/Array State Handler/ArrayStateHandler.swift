//
//  ArrayStateHandler.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 05/02/24.
//

import SwiftUI


enum ItemType {
    case textOnly
    case emojiOnly
}
class Item: ObservableObject {
    @Published var isToggled: Bool = false
    let name: String
    let type: ItemType

    init(name: String, type: ItemType) {
        self.name = name
        self.type = type
    }
    
    static var textOnly: Item  {
        Item(name: "Item 1", type: .textOnly)
    }
    static var emojiOnly: Item  {
        Item(name: ":)", type: .emojiOnly)
    }
}

class ItemList: ObservableObject {
    @Published var items: [Item]
    init(items: [Item]) {
        self.items = items
    }
}

struct ItemListView: View {
    @ObservedObject var itemList: ItemList
    @State private var selectionValue: String = ""

    var body: some View {
        VStack {
            Text(selectionValue)
            HStack {
                ForEach(Array(itemList.items.enumerated()), id: \.element.name) { index, item in
                    VStack {
                        Toggle(isOn: $itemList.items[index].isToggled) {
                            Text(item.name)
                        }
                        .onChange(of: itemList.items[index].isToggled) { value in
                            if value {
                                selectionValue = "\(itemList.items[index].name) Selected"
                            } else {
                                selectionValue = "\(itemList.items[index].name) Un-Selected"
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ItemListView(itemList: .init(items:[
        .textOnly,
        .emojiOnly
    ]))
}
