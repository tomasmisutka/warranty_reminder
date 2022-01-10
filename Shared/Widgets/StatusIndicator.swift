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
    private var status: Int
    @State private var offset: CGFloat = 1
    @State private var animate = false
    
    //status: 0 - active, 1 - expire soon, 2 - expired
    init(status: Int)
    {
        self.status = status
    }
    
    var body: some View
    {
        let indicatorColor = getColorAccordingToStatus()
        ZStack
        {
            Circle().fill(indicatorColor.opacity(0.25)).frame(width: 30, height: 30).scaleEffect(self.animate ? 1 : 0)
                
            Circle().fill(indicatorColor.opacity(0.35)).frame(width: 23, height: 23).scaleEffect(self.animate ? 1 : 0)
            
            Circle().fill(indicatorColor.opacity(0.45)).frame(width: 18, height: 18).scaleEffect(self.animate ? 1 : 0)
                
            Circle().fill(indicatorColor).frame(width: 13, height: 13).scaleEffect(self.animate ? 1 : 0)
        }.onAppear()
        {
            self.animate.toggle()
            self.offset = 0.75
        }
        .animation(.linear(duration: 2.5).repeatForever(autoreverses: true), value: offset)
    }
    
    private func getColorAccordingToStatus() -> Color
    {
        if(status == 0) { return Color.green }
        else if(status == 1) { return Color.orange }
        else { return Color.red }
    }
}
