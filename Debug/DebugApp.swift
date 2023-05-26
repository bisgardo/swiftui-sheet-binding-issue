import SwiftUI

struct Model {
    var items: [Item]
}

struct Item: Identifiable {
    var id: String
}

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

struct MainView: View {
    @Binding var model: Model
    @State private var editItemIdx: Int?
    
    var body: some View {
        VStack {
            List(model.items.indices, id: \.self) { idx in
                ItemCardView(item: model.items[idx])
                    .onTapGesture {
                        editItemIdx = idx
                    }
            }
            Button(action: {
                model.items.append(Item(id: "New item"))
                editItemIdx = model.items.count-1
                let _=print("writing", model, editItemIdx)
            }) {
                Image(systemName: "plus")
            }
        }.sheet(item: $editItemIdx) { idx in
            let _=print("reading", model, idx)
            ItemEditView(item: $model.items[idx])
        }
    }
}

struct ItemCardView: View {
    var item: Item
    var body: some View {
        Text(item.id)
    }
}

struct ItemEditView: View {
    @Binding var item: Item
    @State private var editingItem: Item = Item(id: "dummy")
    
    var body: some View {
        TextField("Title", text: $editingItem.id)
        .onAppear {
            editingItem = item
        }
        .onDisappear {
            item = editingItem
        }
    }
}

@main
struct MyApp: App {
    @State var model = Model(items: [])
    
    var body: some Scene {
        WindowGroup {
            MainView(model: $model)
        }
    }
}
