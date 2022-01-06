//
//  ContentView.swift
//  Shared
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View
{
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        animation: .default)
    
    private var products: FetchedResults<Product>
    @State private var usingNotification: Bool = false

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
        .onAppear()
        {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler:
            { permission in
                switch permission.authorizationStatus
                {
                    case .authorized:
                        print("User granted permission for notification")
                        usingNotification = false
                    case .denied:
                        print("User denied notification permission")
                        usingNotification = true
                    case .notDetermined:
                        print("Notification permission haven't been asked yet")
                        usingNotification = false
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success { print("All set!") }
                        else if let error = error { print(error.localizedDescription) }
                    }
                    case .provisional:
                        print("The application is authorized to post non-interruptive user notifications.")
                        usingNotification = true
                    case .ephemeral:
                        print("The application is temporarily authorized to post notifications. Only available to app clips.")
                    @unknown default:
                        print("Unknow Status")
                        usingNotification = false
                }
            })
        }
        .alert("Notification are disabled. To Correct APP functionality, please enable notification in Settings", isPresented: $usingNotification)
        {
            Button("OK", role: .cancel) { }
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
