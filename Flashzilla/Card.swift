//
//  Card.swift
//  Flashzilla
//
//  Created by Parth Antala on 2024-07-20.
//

import Foundation

struct Card: Codable, Identifiable, Hashable {
    var id = UUID()
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "What is the capital of Canada?", answer: "Ottawa")
}
