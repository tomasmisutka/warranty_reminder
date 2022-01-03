//
//  Notification.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import Foundation
import SwiftUI

enum Notification: String, Equatable, CaseIterable
{
    case day_before = "DAY BEFORE"
    case week_before = "WEEK BEFORE"
    case two_weeks_before = "2 WEEKS BEFORE"
    case month_before = "MONTH BEFORE"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
