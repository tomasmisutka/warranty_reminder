//
//  Transformer.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import Foundation

struct Transformer
{
    static func transformDaysFromString(notification: Notification) -> Int32
    {
        switch(notification)
        {
        case .day_before:
            return 1
            
        case .week_before:
            return 7
            
        case .two_weeks_before:
            return 14
            
        case .month_before:
            return 30
        }
    }
    
}
