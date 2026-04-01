//
//  HomeViewModel.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var learnedToday = ""
    @Published var avoidedToday = ""
    @Published var smallWin = ""
    @Published var entries: [ReflectionEntry] = []
    @Published var dailyPromptTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var aiReflectionEnabled = false
    @Published var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "has_completed_onboarding")
    @Published var promptOne = UserDefaults.standard.string(forKey: "prompt_one") ?? "What did you learn today?"
    @Published var promptTwo = UserDefaults.standard.string(forKey: "prompt_two") ?? "What did you avoid today?"
    @Published var promptThree = UserDefaults.standard.string(forKey: "prompt_three") ?? "What’s one small win?"

    private let store = EntryStore()
    private let reminderTimeKey = "daily_prompt_time"
    
    init() {
        loadEntries()
        loadReminderTime()
    }

    func loadEntries() {
        entries = store.load().sorted(by: { $0.date > $1.date })
    }

    func saveTodayEntry() {
        guard !learnedToday.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !avoidedToday.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !smallWin.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please answer all 3 prompts before saving."
            showAlert = true
            return
        }

        if hasEntryForToday() {
            alertMessage = "You’ve already completed today’s check-in."
            showAlert = true
            return
        }

        let entry = ReflectionEntry(
            learnedToday: learnedToday,
            avoidedToday: avoidedToday,
            smallWin: smallWin,
            aiReflection: nil
        )

        entries.insert(entry, at: 0)
        store.save(entries: entries)

        learnedToday = ""
        avoidedToday = ""
        smallWin = ""

        alertMessage = "Today’s check-in saved."
        showAlert = true
    }

    func hasEntryForToday() -> Bool {
        entries.contains { Calendar.current.isDateInToday($0.date) }
    }

    func currentStreak() -> Int {
        let sortedDates = entries
            .map { Calendar.current.startOfDay(for: $0.date) }
            .sorted(by: >)

        guard let first = sortedDates.first else { return 0 }

        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())

        if first == currentDate {
            streak = 1
        } else if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate), first == yesterday {
            streak = 1
            currentDate = yesterday
        } else {
            return 0
        }

        for i in 1..<sortedDates.count {
            guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { break }

            if sortedDates[i] == previousDay {
                streak += 1
                currentDate = previousDay
            } else if sortedDates[i] == currentDate {
                continue
            } else {
                break
            }
        }

        return streak
    }

    func scheduleReminder() {
        saveReminderTime()

        NotificationManager.shared.checkPermissionStatus { status in
            DispatchQueue.main.async {
                switch status {
                case .notDetermined:
                    NotificationManager.shared.requestPermission { granted in
                        if granted {
                            let components = Calendar.current.dateComponents([.hour, .minute], from: self.dailyPromptTime)
                            let hour = components.hour ?? 20
                            let minute = components.minute ?? 0
                            NotificationManager.shared.scheduleDailyReminder(hour: hour, minute: minute)

                            self.alertMessage = "Reminder scheduled successfully."
                            self.showAlert = true
                        } else {
                            self.alertMessage = "Notification permission was not granted."
                            self.showAlert = true
                        }
                    }

                case .authorized, .provisional, .ephemeral:
                    let components = Calendar.current.dateComponents([.hour, .minute], from: self.dailyPromptTime)
                    let hour = components.hour ?? 20
                    let minute = components.minute ?? 0
                    NotificationManager.shared.scheduleDailyReminder(hour: hour, minute: minute)

                    self.alertMessage = "Reminder scheduled successfully."
                    self.showAlert = true

                case .denied:
                    self.alertMessage = "Notifications are disabled. Please enable them in Settings."
                    self.showAlert = true

                @unknown default:
                    self.alertMessage = "Something went wrong with notifications."
                    self.showAlert = true
                }
            }
        }
    }

    func totalEntries() -> Int {
        entries.count
    }
    
    func deleteEntries(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        store.save(entries: entries)
    }
    
    func updateEntry(updatedEntry: ReflectionEntry) {
        if let index = entries.firstIndex(where: { $0.id == updatedEntry.id }) {
            entries[index] = updatedEntry
            entries.sort(by: { $0.date > $1.date })
            store.save(entries: entries)
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
    }
    
    func savePrompts() {
        let trimmedOne = promptOne.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTwo = promptTwo.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedThree = promptThree.trimmingCharacters(in: .whitespacesAndNewlines)

        promptOne = trimmedOne.isEmpty ? "What did you learn today?" : trimmedOne
        promptTwo = trimmedTwo.isEmpty ? "What did you avoid today?" : trimmedTwo
        promptThree = trimmedThree.isEmpty ? "What’s one small win?" : trimmedThree

        UserDefaults.standard.set(promptOne, forKey: "prompt_one")
        UserDefaults.standard.set(promptTwo, forKey: "prompt_two")
        UserDefaults.standard.set(promptThree, forKey: "prompt_three")
    }

    func resetPromptsToDefault() {
        promptOne = "What did you learn today?"
        promptTwo = "What did you avoid today?"
        promptThree = "What’s one small win?"

        savePrompts()
    }
    
    func loadReminderTime() {
        if let savedDate = UserDefaults.standard.object(forKey: reminderTimeKey) as? Date {
            dailyPromptTime = savedDate
        }
    }

    func saveReminderTime() {
        UserDefaults.standard.set(dailyPromptTime, forKey: reminderTimeKey)
    }
}
