//
//  ContentView.swift
//  Shared
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.warrantyUntil, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>

    var body: some View {
        NavigationView {
            List {
                ForEach(products) { item in
                    NavigationLink {
                        Text("Item at \(item.warrantyUntil!, formatter: itemFormatter)")
                    } label: {
                        Text(item.warrantyUntil!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    NavigationLink(destination: AddProductView()) {
                        Image(systemName: "plus")
                    }
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
                }
            }
        }
        .navigationTitle("Dashboard")
    }

    private func addItem() {
        withAnimation {
            let newItem = Product(context: viewContext)
            newItem.warrantyUntil = Date()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
