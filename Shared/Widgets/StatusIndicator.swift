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
    @State private var indicatorColor: Color
    @State private var offset: CGFloat = 0.75
    @State private var animate = false
    
    //status: 0 - active, 1 - expire soon, 2 - expired
    init(status: Int)
    {
        self.status = status
        _indicatorColor = State(initialValue: .green)
        //just workarround to set correct status color to keep correct color after return from child view
        _indicatorColor = State(initialValue: getColorAccordingToStatus())
    }
    
    var body: some View
    {
        ZStack
        {
            Circle().fill(indicatorColor.opacity(0.25)).frame(width: 30, height: 30).scaleEffect(self.animate ? 1 : 0)
                
            Circle().fill(indicatorColor.opacity(0.35)).frame(width: 23, height: 23).scaleEffect(self.animate ? 1 : 0)
            
            Circle().fill(indicatorColor.opacity(0.45)).frame(width: 18, height: 18).scaleEffect(self.animate ? 1 : 0)
                
            Circle().fill(indicatorColor).frame(width: 13, height: 13).scaleEffect(self.animate ? 1 : 0)
        }.onAppear()
        {
            self.animate.toggle()
            self.offset = 1.0
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
