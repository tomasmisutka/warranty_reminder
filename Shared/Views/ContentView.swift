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
    @State private var showNotificationAlert: Bool = false
    @State private var refresh: Bool = false
    @StateObject private var notificationManager = NotificationManager()

    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(products)
                { product in
                    NavigationLink { ProductDetailView(currentProduct: product, refresh: $refresh, notificationManager: notificationManager) }
                label: { ProductItem(currentProduct: product, refresh: $refresh) }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar
            {
#if os(iOS)
                //items just for iphone or ipad
#endif
                ToolbarItem
                {
                    NavigationLink(destination: AddOrEditProductView(currentProduct: Binding.constant(nil), refresh: Binding.constant(false), notificationManager: notificationManager))
                    { Image(systemName: "plus") }
                }
                ToolbarItem(placement: .navigationBarLeading)
                { AppIcon() }
            }
        }
        .onAppear(perform:
            {
            notificationManager.reloadAuthorizationStatus()
            })
        .onChange(of: notificationManager.authorizationStatus)
        { authorizationStatus in
            switch authorizationStatus
            {
            case .notDetermined:
                notificationManager.requestAuthorization()
                break
            case .authorized:
                notificationManager.requestAuthorization()
                break
            case .denied:
                showNotificationAlert.toggle()
                break
            default:
                break
            }
        }
        .alert("Notifications are disabled. To get full functionality, please enable notifications in Settings", isPresented: $showNotificationAlert)
        {
            Button("OK", role: .cancel) { }
        }
        .accentColor(refresh ? .blue : .blue)
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
