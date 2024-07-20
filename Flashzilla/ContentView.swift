//
//  ContentView.swift
//  Flashzilla
//
//  Created by Parth Antala on 2024-07-19.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    @State private var currentAngle = Angle.zero
    @State private var finalAngle = Angle.zero
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Long press")
                .onLongPressGesture(minimumDuration: 2) {
                    print("Long pressed")
                } onPressingChanged: { inProgress in
                    print("In progress: \(inProgress)")
                }
            
            Text("Zoom")
                        .scaleEffect(finalAmount + currentAmount)
                        .gesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    currentAmount = value.magnification - 1
                                }
                                .onEnded { value in
                                    finalAmount += currentAmount
                                    currentAmount = 0
                                }
                        )
            
            
            Text("rotation")
                .rotationEffect(finalAngle + currentAngle)
                .gesture(
                    RotateGesture()
                        .onChanged { value in
                            currentAngle = value.rotation
                        }
                        .onEnded { value in
                            finalAngle += currentAngle
                            currentAngle = .zero
                        }
                )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
