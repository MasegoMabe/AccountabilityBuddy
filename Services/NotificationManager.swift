//
//  NotificationManager.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import Foundation
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private override init() {
        super.init()
    }

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
                completion(false)
                return
            }

            completion(granted)
        }
    }

    func checkPermissionStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    func scheduleTomorrowMorningReminder(hour: Int, minute: Int, tasks: [String], verseReference: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["tomorrow_morning_plan_reminder"])

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        var components = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
        components.hour = hour
        components.minute = minute

        let preview = tasks.prefix(3).joined(separator: " • ")
        let body = tasks.isEmpty
        ? "Good morning. Open Accountability Buddy and plan your day. \(verseReference)"
        : "Today: \(preview). \(verseReference)"

        let content = UNMutableNotificationContent()
        content.title = "Good morning ☀️"
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: "tomorrow_morning_plan_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func scheduleNightPlanningReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["night_planning_reminder"])

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "Plan tomorrow"
        content.body = "Write tomorrow’s to-do list tonight so tomorrow feels lighter."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: "night_planning_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func scheduleNightCheckInReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["night_checkin_reminder"])

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "Night reflection"
        content.body = "Reflect on school, work, personal life, and project lab before you sleep."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: "night_checkin_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func scheduleFridayReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["friday_submission_reminder"])

        var components = DateComponents()
        components.weekday = 6
        components.hour = hour
        components.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "Friday review"
        content.body = "Check what needs to be submitted for the coming week — Friday to Friday."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: "friday_submission_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func scheduleAcademicReminder(_ reminder: AcademicReminder) {
        removeAcademicReminderNotifications(for: reminder.id)

        scheduleSingleAcademicNotification(
            id: "\(reminder.id.uuidString)_weekBefore",
            title: "\(reminder.type.rawValue) reminder",
            body: "\(reminder.title) is in 1 week.",
            targetDate: Calendar.current.date(byAdding: .day, value: -7, to: reminder.date)
        )

        scheduleSingleAcademicNotification(
            id: "\(reminder.id.uuidString)_dayBefore",
            title: "\(reminder.type.rawValue) reminder",
            body: "\(reminder.title) is tomorrow.",
            targetDate: Calendar.current.date(byAdding: .day, value: -1, to: reminder.date)
        )

        if reminder.includesOptionalReminder, let optionalOffset = reminder.optionalOffset {
            let customDate = Calendar.current.date(byAdding: optionalOffset.dateComponents, to: reminder.date)

            scheduleSingleAcademicNotification(
                id: "\(reminder.id.uuidString)_optional",
                title: "\(reminder.type.rawValue) reminder",
                body: "\(reminder.title) is coming up soon.",
                targetDate: customDate
            )
        }
    }

    func removeAcademicReminderNotifications(for reminderID: UUID) {
        let center = UNUserNotificationCenter.current()
        let identifiers = [
            "\(reminderID.uuidString)_weekBefore",
            "\(reminderID.uuidString)_dayBefore",
            "\(reminderID.uuidString)_optional"
        ]
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    private func scheduleSingleAcademicNotification(id: String, title: String, body: String, targetDate: Date?) {
        guard let targetDate else { return }
        guard targetDate > Date() else { return }

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .badge]
    }
}
