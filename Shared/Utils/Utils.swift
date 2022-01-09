//
//  Utils.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 05/01/2022.
//

import Foundation
import SwiftUI

struct Utils
{
    //this method return formated date as String
    static func getFormattedDateAsString(warrantyDate: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: warrantyDate)
    }
    
    //this method counts number of days between current date and date, when warranty expires on
    static func getNumberOfDaysBetweenDates(currentProduct: Product, verifyStatus: Bool = true) -> Int
    {
        let calendar = Calendar.current
        
        let dateNow = calendar.startOfDay(for: Date())
        let warrantyDate = calendar.startOfDay(for: currentProduct.warrantyUntil ?? Date())
        
        let components = calendar.dateComponents([.day], from: dateNow, to: warrantyDate)
        
        if(verifyStatus) { setStatusForProduct(remainingDays: components.day ?? 0, product: currentProduct) }
        
        if(components.day ?? 0 <= 0)
        { return 0 }
        return components.day ?? 0 //return zero if counting fails
    }
    
    //setting status according to counted remaining days
    private static func setStatusForProduct(remainingDays: Int, product: Product)
    {
        if(remainingDays > 30) { product.status = 0 } //warranty active
        else if(remainingDays <= 30 && remainingDays > 0) { product.status = 1 } //waranty expires soon
        else { product.status = 2 } //warranty expired
    }
    
    static func categoryFromString(valueString: String) -> ProductCategory
    {
        let correctCategory = ProductCategory(rawValue: valueString)
        return correctCategory ?? .home
    }
    
    static func notificationFromString(valueInt: Int) -> Notification
    {
        var correctCategory: Notification = .day_before
        for notification in Notification.allCases
        {
            let currentIntValue = Int(notification.rawValue.prefix(2).trimmingCharacters(in: .whitespaces))
            if(currentIntValue == valueInt)
            {
                correctCategory = notification
                break
            }
        }
        return correctCategory
    }
    
    static func getImageFromBinary(binaryValue: Data?) -> Image
    {
        if(binaryValue == nil) { return Image(systemName: "camera.viewfinder") }
        let productImageFromBinary = UIImage(data: binaryValue!)
        return Image(uiImage: productImageFromBinary!)
    }
    
    //this method return formated string according to how many days are remaining
    static func getFormattedDayString(days: Int) -> String
    {
        if days == 1 { return "\(days) day" }
        else if days > 1 { return "\(days) days" }
        return "expired"
    }
}
