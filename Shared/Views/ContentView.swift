//
//  ContentView.swift
//  Shared
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import SwiftUI
import CoreData

struct ContentView: View
{
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        animation: .default)
    
    private var products: FetchedResults<Product>
    @State private var refresh: Bool = false

    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(products)
                { product in
                    NavigationLink { ProductDetailView(currentProduct: product) }
                    label: { ProductItem(currentProduct: product) }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar
            {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing)
                { EditButton() }
#endif
                ToolbarItem
                {
                    NavigationLink(destination: AddOrEditProductView(currenctProduct: nil))
                    { Image(systemName: "plus") }
                }
                ToolbarItem(placement: .navigationBarLeading)
                { AppIcon() }
            }
        }
    }

    private func deleteItems(offsets: IndexSet)
    {
        withAnimation
        {
            offsets.map { products[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch
            {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
