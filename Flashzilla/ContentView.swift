//
//  ContentView.swift
//  Flashzilla
//
//  Created by Parth Antala on 2024-07-19.
//

import SwiftUI

struct ContentView: View {
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }
        
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        
        let combinedGesture = pressGesture.sequenced(before: dragGesture)
        
        Circle()
            .fill(.orange)
        .frame(width: 100, height: 100)
        .scaleEffect(isDragging ? 1.5 : 1)
        .offset(offset)
        .gesture(combinedGesture)
    }
}

#Preview {
    ContentView()
}
