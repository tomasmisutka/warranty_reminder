//
//  AppIcon.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 04/01/2022.
//

import Foundation
import SwiftUI

struct AppIcon: View
{
    var body: some View
    {
        HStack
        {
            Image("warranty")
                .resizable()
                .frame(width: 50, height: 50)
            Text("WR")
                .fontWeight(.bold)
                .font(.title)
        }
    }
}
