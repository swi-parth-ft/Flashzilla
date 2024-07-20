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
        Text("Start Timer")
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == .active {
                    print("Active")
                } else if newValue == .inactive {
                    print("Inactive")
                } else if newValue == .background
                {
                    print("Background")
                }
                }
    }
}

#Preview {
    ContentView()
}
