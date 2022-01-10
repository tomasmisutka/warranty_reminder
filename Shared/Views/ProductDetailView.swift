//
//  ProductDetailView.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 04/01/2022.
//

import SwiftUI

struct ProductDetailView: View
{
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var notificationManager: NotificationManager
    @State private var product: Product?
    @Binding private var refresh: Bool
    
    init(currentProduct: Product, refresh: Binding<Bool>, notificationManager: NotificationManager)
    {
        self.product = currentProduct
        self._refresh = refresh
        self.notificationManager = notificationManager
    }
    
    var body: some View
    {
        ScrollView
        {
            VStack(alignment: .leading, spacing: 20)
            {
                //image loaded from persistence
                if let productImage = UIImage(data: product!.image!)
                {
                    Image(uiImage: productImage)
                        .resizable()
                        .cornerRadius(12)
                        .scaledToFit()
                }
                //name of the product
                HStack
                {
                    Text(product!.name!)
                        .fontWeight(.bold)
                        .font(.title)
                    Spacer()
                }
                //text with category info
                Text(product!.category ?? "Category")
                    .foregroundColor(.blue)
                    .fontWeight(.heavy)
                    .font(.title2)
                //information about notification how many days appear before expiration
                HStack
                {
                    Image(systemName: "bell.badge")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 20, height: 20)
                    Text("\(product!.notificationBefore) Day(s) from expiry")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
                // Date information - when the product expires on
                HStack
                {
                    Text("Expiry date:")
                    Text(Utils.getFormattedDateAsString(warrantyDate: product!.warrantyUntil ?? Date()))
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
                //information, how many days are remaining to expire the product
                HStack
                {
                    Text("Remaining:")
                    let days = Utils.getNumberOfDaysBetweenDates(currentProduct: product!, verifyStatus: false)
                    Text("\(days) Day(s)")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
                //information about status in colored text
                HStack
                {
                    Spacer()
                    ColoredStatusText(status: Int(product!.status))
                    Spacer()
                }
                //move everything to top
                Spacer()
            }.padding(.horizontal, 15)
            .navigationTitle("Product Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    NavigationLink(destination: AddOrEditProductView(currentProduct: self.$product, isEditingMode: true, refresh: $refresh, notificationManager: notificationManager))
                    {
                        Image(systemName: "slider.horizontal.3").imageScale(.large)
                    }
                }
            }
        }.accentColor(refresh ? .blue : .blue)
    }
}

//struct ProductDetailView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ProductDetailView(currentProduct: product)
//    }
//}
