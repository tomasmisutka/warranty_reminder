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
    @State private var currentProduct: Product
    
    init(product: Product)
    {
        self.currentProduct = product
    }
        
    var body: some View
    {
        HStack
        {
            //image loaded from persistence
            if let image = UIImage(data: currentProduct.image!)
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
                Text(currentProduct.name ?? "product name")
                    .fontWeight(.bold)
                Text(currentProduct.category ?? "category")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                //Expiration information
                HStack
                {
                    Text("Expire on:")
                        .fontWeight(.bold)
                        .padding(.trailing, 5)
                        .font(.system(size: 15))
                    Text(self.getFormattedDateAsString(warrantyDate: currentProduct.warrantyUntil ?? Date()))
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                    Spacer()
                }
                //Remaining information
                HStack
                {
                    Text("Remaining:")
                        .fontWeight(.bold)
                        .padding(.trailing, 2)
                        .font(.system(size: 15))
                    let remainingDays = getNumberOfDaysBetweenDates(warrantyUntil: currentProduct.warrantyUntil ?? Date())
                    Text(getFormattedDayString(days: remainingDays))
                        .fontWeight(remainingDays == 0 ? .bold : .regular)
                        .font(.system(size: 14))
                        .foregroundColor(remainingDays == 0 ? .red : .black)
                    Spacer()
                }
            }
            Spacer()
            let productStatus: Int = Int(currentProduct.status)
            StatusIndicator(status: productStatus)
            //todo here comes status
        }
    }
    
    //this method return formated date as String
    private func getFormattedDateAsString(warrantyDate: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: warrantyDate)
    }
    
    //this method counts number of days between current date and date, when warranty expires on
    private func getNumberOfDaysBetweenDates(warrantyUntil: Date) -> Int
    {
        let calendar = Calendar.current
        
        let dateNow = calendar.startOfDay(for: Date())
        let warrantyDate = calendar.startOfDay(for: warrantyUntil)
        
        let components = calendar.dateComponents([.day], from: dateNow, to: warrantyDate)
        if(components.day ?? 0 <= 0) { return 0 }
        return components.day ?? 0 //return zero if counting fails
    }
    
    //this method return formated string according to how many days are remaining
    private func getFormattedDayString(days: Int) -> String
    {
        if(days == 1) { return "\(days) day" }
        else if(days > 1) { return "\(days) days" }
        return "expired"
    }
    
}
