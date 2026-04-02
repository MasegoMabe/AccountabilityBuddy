//
//  HomeViewModel.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var schoolReflection = ""
    @Published var workReflection = ""
    @Published var personalReflection = ""
    @Published var projectLabReflection = ""

    @Published var entries: [ReflectionEntry] = []
    @Published var plans: [DayPlan] = []
    @Published var academicReminders: [AcademicReminder] = []

    @Published var todayTaskInput = ""
    @Published var tomorrowTaskInput = ""
    @Published var tomorrowNotes = ""

    @Published var morningReminderTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var nightPlanningTime: Date = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var nightCheckInTime: Date = Calendar.current.date(bySettingHour: 21, minute: 30, second: 0, of: Date()) ?? Date()
    @Published var fridayReminderTime: Date = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()

    @Published var reminderTitleInput = ""
    @Published var reminderDateInput = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @Published var reminderTypeInput: ReminderType = .exam
    @Published var includesOptionalReminder = false
    @Published var optionalReminderOffset: ReminderOffset = .twoDaysBefore
    @Published var editingReminderID: UUID?

    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var aiReflectionEnabled = false
    @Published var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "has_completed_onboarding")

    @Published var todayVerse: BibleVerse = BibleVerseProvider.verseForToday()

    private let store = EntryStore()
    private let planStore = PlanStore()
    private let reminderStore = ReminderStore()

    private let morningReminderTimeKey = "morning_reminder_time"
    private let nightPlanningTimeKey = "night_planning_time"
    private let nightCheckInTimeKey = "night_checkin_time"
    private let fridayReminderTimeKey = "friday_reminder_time"

    init() {
        loadEntries()
        loadPlans()
        loadAcademicReminders()
        loadReminderTimes()
        refreshVerse()
        prepareTomorrowDraftFromExistingPlan()
    }

    func refreshVerse() {
        todayVerse = BibleVerseProvider.verseForToday()
    }

    func loadEntries() {
        entries = store.load().sorted(by: { $0.date > $1.date })
    }

    func loadPlans() {
        plans = planStore.load().sorted(by: { $0.date > $1.date })
    }

    func loadAcademicReminders() {
        academicReminders = reminderStore.load().sorted(by: { $0.date < $1.date })
    }

    func saveTodayEntry() {
        let school = schoolReflection.trimmingCharacters(in: .whitespacesAndNewlines)
        let work = workReflection.trimmingCharacters(in: .whitespacesAndNewlines)
        let personal = personalReflection.trimmingCharacters(in: .whitespacesAndNewlines)
        let projectLab = projectLabReflection.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !school.isEmpty, !work.isEmpty, !personal.isEmpty, !projectLab.isEmpty else {
            alertMessage = "Please fill in school, work, personal, and project lab before saving."
            showAlert = true
            return
        }

        if hasEntryForToday() {
            alertMessage = "You’ve already completed tonight’s reflection."
            showAlert = true
            return
        }

        let entry = ReflectionEntry(
            schoolReflection: school,
            workReflection: work,
            personalReflection: personal,
            projectLabReflection: projectLab
        )

        entries.insert(entry, at: 0)
        store.save(entries: entries)

        schoolReflection = ""
        workReflection = ""
        personalReflection = ""
        projectLabReflection = ""

        alertMessage = "Tonight’s reflection saved."
        showAlert = true
    }

    func hasEntryForToday() -> Bool {
        entries.contains { Calendar.current.isDateInToday($0.date) }
    }

    func totalEntries() -> Int {
        entries.count
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

    func todayPlan() -> DayPlan {
        let today = Calendar.current.startOfDay(for: Date())
        if let existing = plans.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            return existing
        }

        let newPlan = DayPlan(date: today)
        plans.append(newPlan)
        savePlans()
        return newPlan
    }

    func tomorrowPlan() -> DayPlan {
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let tomorrow = Calendar.current.startOfDay(for: tomorrowDate)

        if let existing = plans.first(where: { Calendar.current.isDate($0.date, inSameDayAs: tomorrow) }) {
            return existing
        }

        let newPlan = DayPlan(date: tomorrow)
        plans.append(newPlan)
        savePlans()
        return newPlan
    }

    func todayTasks() -> [DailyTask] {
        todayPlan().tasks
    }

    func tomorrowTasks() -> [DailyTask] {
        tomorrowPlan().tasks
    }

    func addTaskToToday() {
        let trimmed = todayTaskInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        var plan = todayPlan()
        plan.tasks.append(DailyTask(title: trimmed))
        upsertPlan(plan)

        todayTaskInput = ""
    }

    func addTaskToTomorrow() {
        let trimmed = tomorrowTaskInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        var plan = tomorrowPlan()
        plan.tasks.append(DailyTask(title: trimmed))
        plan.notes = tomorrowNotes
        upsertPlan(plan)

        tomorrowTaskInput = ""
    }

    func toggleTodayTask(_ task: DailyTask) {
        var plan = todayPlan()
        guard let index = plan.tasks.firstIndex(where: { $0.id == task.id }) else { return }
        plan.tasks[index].isCompleted.toggle()
        upsertPlan(plan)
    }

    func toggleTomorrowTask(_ task: DailyTask) {
        var plan = tomorrowPlan()
        guard let index = plan.tasks.firstIndex(where: { $0.id == task.id }) else { return }
        plan.tasks[index].isCompleted.toggle()
        upsertPlan(plan)
    }

    func saveTomorrowNotes() {
        var plan = tomorrowPlan()
        plan.notes = tomorrowNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        upsertPlan(plan)
    }

    func completedTaskCountToday() -> Int {
        todayTasks().filter { $0.isCompleted }.count
    }

    func totalTaskCountToday() -> Int {
        todayTasks().count
    }

    func scheduleAllReminders() {
        saveReminderTimes()

        NotificationManager.shared.checkPermissionStatus { status in
            DispatchQueue.main.async {
                switch status {
                case .notDetermined:
                    NotificationManager.shared.requestPermission { granted in
                        DispatchQueue.main.async {
                            if granted {
                                self.scheduleNotificationsAfterPermission()
                            } else {
                                self.alertMessage = "Notification permission was not granted."
                                self.showAlert = true
                            }
                        }
                    }

                case .authorized, .provisional, .ephemeral:
                    self.scheduleNotificationsAfterPermission()

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

    private func scheduleNotificationsAfterPermission() {
        let morning = Calendar.current.dateComponents([.hour, .minute], from: morningReminderTime)
        let planning = Calendar.current.dateComponents([.hour, .minute], from: nightPlanningTime)
        let nightly = Calendar.current.dateComponents([.hour, .minute], from: nightCheckInTime)
        let friday = Calendar.current.dateComponents([.hour, .minute], from: fridayReminderTime)

        NotificationManager.shared.scheduleNightPlanningReminder(
            hour: planning.hour ?? 21,
            minute: planning.minute ?? 0
        )

        NotificationManager.shared.scheduleNightCheckInReminder(
            hour: nightly.hour ?? 21,
            minute: nightly.minute ?? 30
        )

        NotificationManager.shared.scheduleFridayReminder(
            hour: friday.hour ?? 18,
            minute: friday.minute ?? 0
        )

        scheduleTomorrowMorningReminder(
            hour: morning.hour ?? 7,
            minute: morning.minute ?? 0
        )

        for reminder in academicReminders {
            NotificationManager.shared.scheduleAcademicReminder(reminder)
        }

        alertMessage = "Your reminders were scheduled."
        showAlert = true
    }

    func scheduleTomorrowMorningReminder(hour: Int? = nil, minute: Int? = nil) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: morningReminderTime)
        let finalHour = hour ?? components.hour ?? 7
        let finalMinute = minute ?? components.minute ?? 0

        let tasks = tomorrowTasks().map(\.title)
        let verse = todayVerse.reference

        NotificationManager.shared.scheduleTomorrowMorningReminder(
            hour: finalHour,
            minute: finalMinute,
            tasks: tasks,
            verseReference: verse
        )
    }

    func prepareTomorrowDraftFromExistingPlan() {
        let existingPlan = tomorrowPlan()
        tomorrowNotes = existingPlan.notes
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

    private func upsertPlan(_ plan: DayPlan) {
        if let index = plans.firstIndex(where: { $0.id == plan.id }) {
            plans[index] = plan
        } else if let sameDayIndex = plans.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: plan.date) }) {
            plans[sameDayIndex] = plan
        } else {
            plans.append(plan)
        }

        plans.sort(by: { $0.date > $1.date })
        savePlans()
    }

    private func savePlans() {
        planStore.save(plans: plans)
    }

    private func saveReminderTimes() {
        UserDefaults.standard.set(morningReminderTime, forKey: morningReminderTimeKey)
        UserDefaults.standard.set(nightPlanningTime, forKey: nightPlanningTimeKey)
        UserDefaults.standard.set(nightCheckInTime, forKey: nightCheckInTimeKey)
        UserDefaults.standard.set(fridayReminderTime, forKey: fridayReminderTimeKey)
    }

    private func loadReminderTimes() {
        if let saved = UserDefaults.standard.object(forKey: morningReminderTimeKey) as? Date {
            morningReminderTime = saved
        }
        if let saved = UserDefaults.standard.object(forKey: nightPlanningTimeKey) as? Date {
            nightPlanningTime = saved
        }
        if let saved = UserDefaults.standard.object(forKey: nightCheckInTimeKey) as? Date {
            nightCheckInTime = saved
        }
        if let saved = UserDefaults.standard.object(forKey: fridayReminderTimeKey) as? Date {
            fridayReminderTime = saved
        }
    }

    func deleteTodayTask(_ task: DailyTask) {
        var plan = todayPlan()
        plan.tasks.removeAll { $0.id == task.id }
        upsertPlan(plan)
    }

    func deleteTomorrowTask(_ task: DailyTask) {
        var plan = tomorrowPlan()
        plan.tasks.removeAll { $0.id == task.id }
        upsertPlan(plan)
    }

    func saveAcademicReminder() {
        let trimmedTitle = reminderTitleInput.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            alertMessage = "Please enter a reminder title."
            showAlert = true
            return
        }

        let reminder = AcademicReminder(
            id: editingReminderID ?? UUID(),
            title: trimmedTitle,
            date: reminderDateInput,
            type: reminderTypeInput,
            includesOptionalReminder: includesOptionalReminder,
            optionalOffset: includesOptionalReminder ? optionalReminderOffset : nil
        )

        if let existingIndex = academicReminders.firstIndex(where: { $0.id == reminder.id }) {
            academicReminders[existingIndex] = reminder
        } else {
            academicReminders.append(reminder)
        }

        academicReminders.sort(by: { $0.date < $1.date })
        reminderStore.save(reminders: academicReminders)
        NotificationManager.shared.scheduleAcademicReminder(reminder)
        clearReminderForm()

        alertMessage = "Reminder saved."
        showAlert = true
    }

    func startEditingReminder(_ reminder: AcademicReminder) {
        reminderTitleInput = reminder.title
        reminderDateInput = reminder.date
        reminderTypeInput = reminder.type
        includesOptionalReminder = reminder.includesOptionalReminder
        optionalReminderOffset = reminder.optionalOffset ?? .twoDaysBefore
        editingReminderID = reminder.id
    }

    func clearReminderForm() {
        reminderTitleInput = ""
        reminderDateInput = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        reminderTypeInput = .exam
        includesOptionalReminder = false
        optionalReminderOffset = .twoDaysBefore
        editingReminderID = nil
    }

    func deleteAcademicReminder(_ reminder: AcademicReminder) {
        academicReminders.removeAll { $0.id == reminder.id }
        reminderStore.save(reminders: academicReminders)
        NotificationManager.shared.removeAcademicReminderNotifications(for: reminder.id)

        if editingReminderID == reminder.id {
            clearReminderForm()
        }
    }
}
