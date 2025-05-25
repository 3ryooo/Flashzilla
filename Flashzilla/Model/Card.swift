//
//  Card.swift
//  Flashzilla
//

import Foundation
import Observation
import SwiftData

@Model
class Card: Identifiable {
    var id: UUID
    var prompt: String
    var answer: String
    
    init(id: UUID = UUID(), prompt: String, answer: String) {
        self.id = id
        self.prompt = prompt
        self.answer = answer
    }
    
}
