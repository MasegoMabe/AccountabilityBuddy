//
//  EntryStore.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import Foundation

final class EntryStore {
    private let entriesKey = "accountability_entries"

    func save(entries: [ReflectionEntry]) {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: entriesKey)
        } catch {
            print("Failed to save entries: \(error.localizedDescription)")
        }
    }

    func load() -> [ReflectionEntry] {
        guard let data = UserDefaults.standard.data(forKey: entriesKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([ReflectionEntry].self, from: data)
        } catch {
            print("Failed to load entries: \(error.localizedDescription)")
            return []
        }
    }
}
