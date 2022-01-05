//
//  ColoredStatus.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 05/01/2022.
//

import Foundation
import SwiftUI

struct ColoredStatusText: View
{
    private var status: Int
    @State private var statusText: String = "expired"
    
    init(status: Int)
    {
        self.status = status
    }
    
    var body: some View
    {
        Text(statusText)
            .fontWeight(.heavy)
            .font(.system(size: 40))
            .foregroundColor(self.getColorAccordingToStatus())
            .onAppear { self.prepareTextAccordingToStatus() }
    }
    
    private func getColorAccordingToStatus() -> Color
    {
        if(status == 0) { return .green }
        else if(status == 1) { return .orange }
        else {return .red}
    }
    
    private func prepareTextAccordingToStatus()
    {
        if(status == 0) { statusText = "active" }
        else if(status == 1) { statusText = "expiry soon" }
    }
}
