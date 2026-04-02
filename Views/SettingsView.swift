//
//  SettingsView.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    @State private var showReminders = true
    @State private var showAI = false
    @State private var showPrompts = false
    @State private var showAbout = false
    @State private var showTesting = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        collapsibleSection(
                            title: "Reminders",
                            systemImage: "bell.badge.fill",
                            isExpanded: $showReminders
                        ) {
                            reminderSectionContent
                        }

                        collapsibleSection(
                            title: "AI Reflection",
                            systemImage: "sparkles.rectangle.stack.fill",
                            isExpanded: $showAI
                        ) {
                            aiSectionContent
                        }

                        collapsibleSection(
                            title: "Prompts",
                            systemImage: "text.quote",
                            isExpanded: $showPrompts
                        ) {
                            promptSectionContent
                        }

                        collapsibleSection(
                            title: "About",
                            systemImage: "heart.fill",
                            isExpanded: $showAbout
                        ) {
                            aboutSectionContent
                        }

                        collapsibleSection(
                            title: "Onboarding",
                            systemImage: "hammer.fill",
                            isExpanded: $showTesting
                        ) {
                            testingSectionContent
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .alert("Accountability Buddy", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }

    private var reminderSectionContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            datePickerRow(title: "Morning reminder", selection: $viewModel.morningReminderTime)
            datePickerRow(title: "Night planning reminder", selection: $viewModel.nightPlanningTime)
            datePickerRow(title: "Night check-in reminder", selection: $viewModel.nightCheckInTime)
            datePickerRow(title: "Friday review reminder", selection: $viewModel.fridayReminderTime)

            Button("Save All Reminder Times") {
                viewModel.scheduleAllReminders()
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.plum)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

        }
    }

    private var aiSectionContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Toggle("Enable AI Reflection", isOn: $viewModel.aiReflectionEnabled)
                .tint(AppTheme.plum)
                .foregroundStyle(AppTheme.textPrimary)
        }
    }

    private var promptSectionContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            styledTextField(title: "Prompt 1", text: $viewModel.promptOne)
            styledTextField(title: "Prompt 2", text: $viewModel.promptTwo)
            styledTextField(title: "Prompt 3", text: $viewModel.promptThree)

            Button("Save Prompt Titles") {
                viewModel.savePrompts()
                viewModel.alertMessage = "Prompt titles saved."
                viewModel.showAlert = true
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.plum)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Button("Reset to Default Prompts", role: .destructive) {
                viewModel.resetPromptsToDefault()
                viewModel.alertMessage = "Prompts reset to default."
                viewModel.showAlert = true
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.lavender)
            .foregroundStyle(AppTheme.deepPlum)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private var aboutSectionContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Accountability Buddy")
                .font(.headline)
                .foregroundStyle(AppTheme.deepPlum)

            Text("A simple daily reflection and planning app to help you stay consistent, clear, and honest with yourself.")
                .foregroundStyle(AppTheme.textSecondary)
        }
    }

    private var testingSectionContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button("View Welcome Screen Again") {
                UserDefaults.standard.set(false, forKey: "has_completed_onboarding")
                viewModel.hasCompletedOnboarding = false
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.softPink)
            .foregroundStyle(AppTheme.deepPlum)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    @ViewBuilder
    private func collapsibleSection<Content: View>(
        title: String,
        systemImage: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        DisclosureGroup(isExpanded: isExpanded) {
            content()
                .padding(.top, 12)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundStyle(AppTheme.plum)

                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(AppTheme.textPrimary)
            }
        }
        .tint(AppTheme.deepPlum)
        .softCard()
    }

    @ViewBuilder
    private func styledTextField(title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppTheme.softPink, lineWidth: 1)
            )
    }

    @ViewBuilder
    private func datePickerRow(title: String, selection: Binding<Date>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            DatePicker(
                "",
                selection: selection,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}
