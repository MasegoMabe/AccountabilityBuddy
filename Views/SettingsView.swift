//
//  SettingsView.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Reminder") {
                    DatePicker(
                        "Daily prompt time",
                        selection: $viewModel.dailyPromptTime,
                        displayedComponents: .hourAndMinute
                    )

                    Button("Save Reminder Time") {
                        viewModel.scheduleReminder()
                    }

                    Button("Send Test Notification") {
                        NotificationManager.shared.scheduleTestReminder()
                    }
                }

                Section("AI Reflection") {
                    Toggle("Enable AI Reflection", isOn: $viewModel.aiReflectionEnabled)
                }

                Section("Prompts") {
                    TextField("Prompt 1", text: $viewModel.promptOne)
                    TextField("Prompt 2", text: $viewModel.promptTwo)
                    TextField("Prompt 3", text: $viewModel.promptThree)

                    Button("Save Prompt Titles") {
                        viewModel.savePrompts()
                    }

                    Button("Reset to Default Prompts", role: .destructive) {
                        viewModel.resetPromptsToDefault()
                    }
                }

                Section("About") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Accountability Buddy")
                            .font(.headline)

                        Text("A simple daily reflection app to help you stay consistent, clear, and honest with yourself.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Testing") {
                    Button("Show Onboarding Again") {
                        UserDefaults.standard.set(false, forKey: "has_completed_onboarding")
                        viewModel.hasCompletedOnboarding = false
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}
