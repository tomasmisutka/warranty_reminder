//
//  NotificationSender.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 09/01/2022.
//

import Foundation
import UserNotifications

struct NotificationSender
{
    static func scheduleNotification(product: Product, daysFromExpiry: Int)
    {
        //notification content
        let content = UNMutableNotificationContent()
        content.title = "\(product.name ?? "product name not defined")"
        content.subtitle = "This product expires in \(Utils.getFormattedDayString(days: Int(product.notificationBefore)))"
        content.sound = UNNotificationSound.default
        
        let subtractedDaysComponent = DateComponents(day: -daysFromExpiry)
        let subtractedDate = Calendar.current.date(byAdding: subtractedDaysComponent, to: product.warrantyUntil!)

        //setup specific notification time
        var triggerDateComponents = DateComponents()
        triggerDateComponents.day = Calendar.current.dateComponents([.day], from: subtractedDate ?? Date()).day!
        triggerDateComponents.month = Calendar.current.dateComponents([.month], from: subtractedDate ?? Date()).month!
        triggerDateComponents.year = Calendar.current.dateComponents([.year], from: subtractedDate ?? Date()).year!
        triggerDateComponents.hour = 08
        triggerDateComponents.minute = 00
            
        // Setup trigger time
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: product.id!.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        print("notification prepared to time: \(String(describing: Calendar.current.date(from: triggerDateComponents)))")
    }
    
    static func deleteScheduledNotification(productID: String)
    {
        let center = UNUserNotificationCenter.current()
        //delete already delived notification
        center.removeDeliveredNotifications(withIdentifiers: [productID])
        //delete pending notificatoin
        center.removePendingNotificationRequests(withIdentifiers: [productID])
    }
}
