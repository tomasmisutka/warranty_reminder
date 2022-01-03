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
    case day_before = "1 day before"
    case week_before = "7 days before"
    case two_weeks_before = "14 days before"
    case month_before = "30 days before"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
