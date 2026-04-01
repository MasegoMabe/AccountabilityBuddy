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

            print("Notification permission granted: \(granted)")
            completion(granted)
        }
    }

    func checkPermissionStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    func scheduleDailyReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_accountability_reminder"])

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "Accountability Buddy"
        content.body = "What did you learn today?"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: "daily_accountability_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled for \(hour):\(String(format: "%02d", minute))")
                self.printPendingNotifications()
            }
        }
    }

    func scheduleTestReminder() {
        checkPermissionStatus { status in
            switch status {
            case .notDetermined:
                self.requestPermission { granted in
                    if granted {
                        self.scheduleTestNotificationNow()
                    } else {
                        print("Test notification permission not granted.")
                    }
                }

            case .authorized, .provisional, .ephemeral:
                self.scheduleTestNotificationNow()

            case .denied:
                print("Notifications are denied. Enable them in Settings.")

            @unknown default:
                print("Unknown notification status.")
            }
        }
    }

    private func scheduleTestNotificationNow() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["test_accountability_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Accountability Buddy Test"
        content.body = "This is a test notification."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(
            identifier: "test_accountability_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Failed to schedule test notification: \(error.localizedDescription)")
            } else {
                print("Test notification scheduled for 5 seconds from now")
                self.printPendingNotifications()
            }
        }
    }

    func printPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Pending notifications count: \(requests.count)")
            for request in requests {
                print("Identifier: \(request.identifier)")
                print("Title: \(request.content.title)")
                print("Body: \(request.content.body)")
                print("-----")
            }
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound, .badge]
    }
}
