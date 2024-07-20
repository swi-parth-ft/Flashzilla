//
//  EditCardsView.swift
//  Flashzilla
//
//  Created by Parth Antala on 2024-07-20.
//

import SwiftUI
import SwiftData

struct EditCardsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var cards: [Card]
    
    @Environment(\.dismiss) var dismiss
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
          
        }
    }
    

    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard !trimmedAnswer.isEmpty && !trimmedPrompt.isEmpty else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer, date: Date.now)

        modelContext.insert(card)
        newAnswer = ""
        newPrompt = ""

        try? modelContext.save()
    }
    
    func removeCards(at offsets: IndexSet) {
        for index in offsets {
            let card = cards[index]
            modelContext.delete(card)
        }
        try? modelContext.save()
    }
}

#Preview {
    EditCardsView()
}
