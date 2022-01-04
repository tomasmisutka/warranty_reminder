//
//  StatusIndicator.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 04/01/2022.
//

import Foundation
import SwiftUI
import AVFoundation

struct StatusIndicator: View
{
    @State private var status: Int
    
    //status: 0 - active, 1 - expire soon, 2 - expired
    init(status: Int)
    {
        self.status = status
    }
    
    var body: some View
    {
        Circle().fill(self.getColorAccordingToStatus(status: self.status))
            .frame(width: 25, height: 25, alignment: .center)
    }
    
    private func getColorAccordingToStatus(status: Int) -> Color
    {
        if(status == 0) { return Color.green }
        else if(status == 1) { return Color.orange }
        else { return Color.red }
    }
}
