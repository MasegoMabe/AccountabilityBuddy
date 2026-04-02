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
    let schoolReflection: String
    let workReflection: String
    let personalReflection: String
    let projectLabReflection: String

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        schoolReflection: String,
        workReflection: String,
        personalReflection: String,
        projectLabReflection: String
    ) {
        self.id = id
        self.date = date
        self.schoolReflection = schoolReflection
        self.workReflection = workReflection
        self.personalReflection = personalReflection
        self.projectLabReflection = projectLabReflection
    }
}
