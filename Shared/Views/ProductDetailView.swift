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
    
    init(currentProduct: Product)
    {
        self.product = currentProduct
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
                Text(product.category ?? "Category")
                    .foregroundColor(.blue)
                    .fontWeight(.heavy)
                    .font(.title2)
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
                HStack
                {
                    Text("Expiry date:")
                    Text(Utils.getFormattedDateAsString(warrantyDate: product.warrantyUntil ?? Date()))
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
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
                    NavigationLink(destination: AddProductView(currenctProduct: product, isEditingMode: true))
                    {
                        Image(systemName: "slider.horizontal.3").resizable().frame(width: 20, height: 20)
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
