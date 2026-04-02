//
//  DailyPlan.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import Foundation

struct DayPlan: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    var tasks: [DailyTask]
    var notes: String

    init(
        id: UUID = UUID(),
        date: Date,
        tasks: [DailyTask] = [],
        notes: String = ""
    ) {
        self.id = id
        self.date = date
        self.tasks = tasks
        self.notes = notes
    }
}
