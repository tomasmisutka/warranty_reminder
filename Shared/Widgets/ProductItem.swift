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
    
    init(currentProduct: Product)
    {
        self.product = currentProduct
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
                    let remainingDays = self.getNumberOfDaysBetweenDates(warrantyUntil: product.warrantyUntil ?? Date())
                    Text(getFormattedDayString(days: remainingDays))
                        .fontWeight(remainingDays == 0 ? .bold : .regular)
                        .font(.system(size: 14))
                        .foregroundColor(remainingDays == 0 ? .red : .black)
                    Spacer()
                }
            }
            Spacer()
            let productStatus: Int = Int(product.status)
            StatusIndicator(status: productStatus)          
        }
    }
    
    //this method return formated string according to how many days are remaining
    private func getFormattedDayString(days: Int) -> String
    {
        if(days == 1) { return "\(days) day" }
        else if(days > 1) { return "\(days) days" }
        return "expired"
    }
    
    //this method counts number of days between current date and date, when warranty expires on
    private func getNumberOfDaysBetweenDates(warrantyUntil: Date) -> Int
    {
        let calendar = Calendar.current
        
        let dateNow = calendar.startOfDay(for: Date())
        let warrantyDate = calendar.startOfDay(for: warrantyUntil)
        
        let components = calendar.dateComponents([.day], from: dateNow, to: warrantyDate)
        
        self.setStatusForProduct(remainingDays: components.day ?? 0)
        
        if(components.day ?? 0 <= 0)
        { return 0 }
        return components.day ?? 0 //return zero if counting fails
    }
    
    //setting status according to counted remaining days
    private func setStatusForProduct(remainingDays: Int)
    {
        if(remainingDays > 30) { product.status = 0 } //warranty active
        else if(remainingDays <= 30 && remainingDays > 0) { product.status = 1 } //waranty expires soon
        else { product.status = 2 } //warranty expired
    }
    
}
