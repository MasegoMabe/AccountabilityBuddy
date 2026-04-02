//
//  ReminderStore.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 02..
//

import Foundation

final class ReminderStore {
    private let remindersKey = "accountability_academic_reminders"

    func save(reminders: [AcademicReminder]) {
        do {
            let data = try JSONEncoder().encode(reminders)
            UserDefaults.standard.set(data, forKey: remindersKey)
        } catch {
            print("Failed to save reminders: \(error.localizedDescription)")
        }
    }

    func load() -> [AcademicReminder] {
        guard let data = UserDefaults.standard.data(forKey: remindersKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([AcademicReminder].self, from: data)
        } catch {
            print("Failed to load reminders: \(error.localizedDescription)")
            return []
        }
    }
}
