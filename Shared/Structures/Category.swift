//
//  Category.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import Foundation
import SwiftUI

enum ProductCategory: String, Equatable, CaseIterable
{
    case home = "HOME"
    case electronics = "ELECTRONICS"
    case sports = "SPORTS"
    case fashion = "FASHION"
    case auto_moto = "AUTO&MOTO"
    case toys = "TOYS"
    case others = "OTHERS"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
