//
//  ContentView.swift
//  Flashzilla
//
//  Created by Parth Antala on 2024-07-19.
//

import SwiftUI
import SwiftData


extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self
            .offset(y: offset * 10)
            .zIndex(Double(position))
    }
}
struct ContentView: View {
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Card.date) var cards: [Card]
    
    @State private var showingEditScreen = false
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var cardsVersion = UUID()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = false
    
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card) { isCorrect in
                            withAnimation {
                                if let index = cards.firstIndex(of: card) {
                                    removeCard(at: index, isCorrect: isCorrect)
                                }
                            }
                        }
                        .stacked(at: cards.firstIndex(of: card) ?? 0, in: cards.count)
                        .allowsHitTesting(cards.firstIndex(of: card) == cards.count - 1)
                        .accessibilityHidden(cards.firstIndex(of: card) ?? 0 < cards.count - 1)
                        .id(card.id)
                    }
                }
                .id(cardsVersion)
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, isCorrect: false)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        
                        Spacer()
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, isCorrect: true)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                        
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if scenePhase == .active {
                if !cards.isEmpty {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCardsView()
        }
        .onAppear(perform: resetCards)
    }
    
    func removeCard(at index: Int, isCorrect: Bool) {
        guard index >= 0, index < cards.count else { return }
        
        let card = cards[index]

        modelContext.delete(cards[index])
        
        if !isCorrect {

            modelContext.insert(card)
        }
        
        // Update the version to force view refresh
        cardsVersion = UUID()

        try? modelContext.save()
        // Check if there are any cards left
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
    }
    
    
}
   
    #Preview {
        ContentView()
    }
