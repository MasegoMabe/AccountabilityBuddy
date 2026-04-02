//
//  AcademicReminder.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 02..
//

import Foundation

struct AcademicReminder: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var date: Date
    var type: ReminderType
    var includesOptionalReminder: Bool
    var optionalOffset: ReminderOffset?

    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        type: ReminderType,
        includesOptionalReminder: Bool = false,
        optionalOffset: ReminderOffset? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.includesOptionalReminder = includesOptionalReminder
        self.optionalOffset = optionalOffset
    }
}

enum ReminderType: String, Codable, CaseIterable, Identifiable {
    case exam = "Exam"
    case deadline = "Deadline"

    var id: String { rawValue }
}

enum ReminderOffset: String, Codable, CaseIterable, Identifiable {
    case twoHoursBefore = "2 hours before"
    case sixHoursBefore = "6 hours before"
    case twelveHoursBefore = "12 hours before"
    case twoDaysBefore = "2 days before"
    case threeDaysBefore = "3 days before"

    var id: String { rawValue }

    var dateComponents: DateComponents {
        switch self {
        case .twoHoursBefore:
            return DateComponents(hour: -2)
        case .sixHoursBefore:
            return DateComponents(hour: -6)
        case .twelveHoursBefore:
            return DateComponents(hour: -12)
        case .twoDaysBefore:
            return DateComponents(day: -2)
        case .threeDaysBefore:
            return DateComponents(day: -3)
        }
    }
}
