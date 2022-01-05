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
}
