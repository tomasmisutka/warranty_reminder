//
//  ProductItem.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 04/01/2022.
//

import Foundation
import SwiftUI

struct ProductItem: View
{
    @State private var product: Product
    @Binding var refresh: Bool
    
    init(currentProduct: Product, refresh: Binding<Bool>)
    {
        self.product = currentProduct
        self._refresh = refresh
    }
        
    var body: some View
    {
        HStack
        {
            //image loaded from persistence
            if let image = UIImage(data: product.image!)
            {
                Image(uiImage: image)
                    .resizable()
                    .cornerRadius(12)
                    .frame(width: 50, height: 50, alignment: .center)
            }
            Spacer()
            VStack(spacing: 5)
            {
                //Category and product name information
                Text(product.name ?? "product name")
                    .fontWeight(.bold)
                Text(product.category ?? "category")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                //Expiration information
                HStack
                {
                    Text("Expire on:")
                        .fontWeight(.bold)
                        .padding(.trailing, 5)
                        .font(.system(size: 15))
                    Text(Utils.getFormattedDateAsString(warrantyDate: product.warrantyUntil ?? Date()))
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                    Spacer()
                }
                //Remaining information
                HStack
                {
                    Text("Remaining:")
                        .fontWeight(.bold)
                        .padding(.trailing, 2)
                        .font(.system(size: 15))
                    //counting how many days are remaining to warranty end
                    let remainingDays = Utils.getNumberOfDaysBetweenDates(currentProduct: product)
                    Text(Utils.getFormattedDayString(days: remainingDays))
                        .fontWeight(remainingDays == 0 ? .bold : .regular)
                        .font(.system(size: 14))
                        .foregroundColor(remainingDays == 0 ? .red : .black)
                    Spacer()
                }
            }
            Spacer()
            StatusIndicator(status: Int(product.status)) //status indicator
        }.accentColor(refresh ? .blue : .blue)
    }
    
}
