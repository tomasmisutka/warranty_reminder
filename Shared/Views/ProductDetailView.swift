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
    @State private var product: Product
    private var usingNotification: Bool
    
    init(currentProduct: Product, usingNotification: Bool)
    {
        self.product = currentProduct
        self.usingNotification = usingNotification
    }
    
    var body: some View
    {
        ScrollView
        {
            VStack(alignment: .leading, spacing: 20)
            {
                //image loaded from persistence
                if let productImage = UIImage(data: product.image!)
                {
                    Image(uiImage: productImage)
                        .resizable()
                        .cornerRadius(12)
                        .scaledToFit()
                }
                //name of the product
                HStack
                {
                    Text(product.name!)
                        .fontWeight(.bold)
                        .font(.title)
                    Spacer()
                }
                //text with category info
                Text(product.category ?? "Category")
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
                    Text("\(product.notificationBefore) Day(s) from expiry")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
                // Date information - when the product expires on
                HStack
                {
                    Text("Expiry date:")
                    Text(Utils.getFormattedDateAsString(warrantyDate: product.warrantyUntil ?? Date()))
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
                //information, how many days are remaining to expire the product
                HStack
                {
                    Text("Remaining:")
                    let days = Utils.getNumberOfDaysBetweenDates(currentProduct: product, verifyStatus: false)
                    Text("\(days) Day(s)")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
                //information about status in colored text
                HStack
                {
                    Spacer()
                    ColoredStatusText(status: Int(product.status))
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
                    NavigationLink(destination: AddOrEditProductView(currenctProduct: product, isEditingMode: true, usingNotification: usingNotification))
                    {
                        Image(systemName: "slider.horizontal.3").imageScale(.large)
                    }
                }
            }
        }
    }
}

//struct ProductDetailView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ProductDetailView(currentProduct: product)
//    }
//}
