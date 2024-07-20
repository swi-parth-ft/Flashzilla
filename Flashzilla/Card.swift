//
//  Card.swift
//  Flashzilla
//
//  Created by Parth Antala on 2024-07-20.
//

import Foundation
import SwiftData

@Model
class Card: Identifiable, Hashable {
    var id = UUID()
    var prompt: String
    var answer: String
    var date: Date
    static let example = Card(prompt: "What is the capital of Canada?", answer: "Ottawa", date: Date.now)
    init(id: UUID = UUID(), prompt: String, answer: String, date: Date) {
        self.id = id
        self.prompt = prompt
        self.answer = answer
        self.date = date
    }
}
