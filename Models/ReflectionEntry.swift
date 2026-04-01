//
//  ReflectionEntry.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import Foundation

struct ReflectionEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    let learnedToday: String
    let avoidedToday: String
    let smallWin: String
    let aiReflection: String?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        learnedToday: String,
        avoidedToday: String,
        smallWin: String,
        aiReflection: String? = nil
    ) {
        self.id = id
        self.date = date
        self.learnedToday = learnedToday
        self.avoidedToday = avoidedToday
        self.smallWin = smallWin
        self.aiReflection = aiReflection
    }
}
