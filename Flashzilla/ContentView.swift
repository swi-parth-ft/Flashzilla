//
//  ContentView.swift
//  Flashzilla
//
//  Created by Parth Antala on 2024-07-19.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        CardView(card: .example)
    }
}

#Preview {
    ContentView()
}
