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
    @Query(sort: \Card.date, order: .reverse) var cards: [Card]
    
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
                            withAnimation(.smooth(duration: 1)) {
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
            let newCard = Card(id: card.id, prompt: card.prompt, answer: card.answer, date: Date())
            modelContext.insert(newCard)
            
        }
        try? modelContext.save()
        // Update the version to force view refresh
        cardsVersion = UUID()
        
        
        // Check if there are any cards left
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        
        let demoCards = [
            Card(prompt: "What is the capital of France?", answer: "Paris", date: Date()),
            Card(prompt: "What is the largest planet in our solar system?", answer: "Jupiter", date: Date()),
            Card(prompt: "Who wrote 'To Kill a Mockingbird'?", answer: "Harper Lee", date: Date()),
            Card(prompt: "What is the chemical symbol for water?", answer: "H2O", date: Date()),
            Card(prompt: "What year did the Titanic sink?", answer: "1912", date: Date()),
            Card(prompt: "Who painted the Mona Lisa?", answer: "Leonardo da Vinci", date: Date()),
            Card(prompt: "What is the smallest prime number?", answer: "2", date: Date()),
            Card(prompt: "What is the capital of Japan?", answer: "Tokyo", date: Date()),
            Card(prompt: "Who developed the theory of relativity?", answer: "Albert Einstein", date: Date()),
            Card(prompt: "What is the hardest natural substance on Earth?", answer: "Diamond", date: Date()),
            Card(prompt: "Who is known as the 'Father of Computers'?", answer: "Charles Babbage", date: Date()),
            Card(prompt: "What is the capital of Australia?", answer: "Canberra", date: Date()),
            Card(prompt: "What is the speed of light in a vacuum?", answer: "299,792 km/s", date: Date()),
            Card(prompt: "Who discovered penicillin?", answer: "Alexander Fleming", date: Date()),
            Card(prompt: "What is the tallest mountain in the world?", answer: "Mount Everest", date: Date()),
            Card(prompt: "What is the capital of Brazil?", answer: "Brasília", date: Date()),
            Card(prompt: "Who wrote 'Pride and Prejudice'?", answer: "Jane Austen", date: Date()),
            Card(prompt: "What is the main gas found in the Earth's atmosphere?", answer: "Nitrogen", date: Date()),
            Card(prompt: "Who was the first person to walk on the moon?", answer: "Neil Armstrong", date: Date()),
            Card(prompt: "What is the largest ocean on Earth?", answer: "Pacific Ocean", date: Date())
        ]
        
        demoCards.forEach { card in
                    modelContext.insert(card)
                }
                
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
                
                cardsVersion = UUID()
        
    }
    
    
}

#Preview {
    ContentView()
}
