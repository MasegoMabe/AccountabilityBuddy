//
//  AccountabilityBuddyApp.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI
import UserNotifications

@main
struct AccountabilityBuddyApp: App {
    @StateObject private var viewModel = HomeViewModel()

    init() {
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
    }

    var body: some Scene {
        WindowGroup {
            if viewModel.hasCompletedOnboarding {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Today", systemImage: "sun.max")
                        }

                    HistoryView()
                        .tabItem {
                            Label("History", systemImage: "clock.arrow.circlepath")
                        }

                    StatsView()
                        .tabItem {
                            Label("Progress", systemImage: "chart.bar")
                        }

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                }
                .environmentObject(viewModel)
                .tint(.purple)
            } else {
                OnboardingView()
                    .environmentObject(viewModel)
            }
        }
    }
}
