//
//  ContentView.swift
//  Flashzilla
//
//  Created by Parth Antala on 2024-07-19.
//

import SwiftUI


extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}
struct ContentView: View {
    
    @State private var cards = Array<Card>(repeating: .example, count: 10)
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Image("background")
                        .resizable()
                        .ignoresSafeArea()
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index])
                            .stacked(at: index, in: cards.count)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
