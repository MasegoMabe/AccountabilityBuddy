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
    @State private var showAcademicReminders = true
    @State private var showAbout = false
    @State private var showOnboarding = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        collapsibleSection(
                            title: "Daily reminders",
                            systemImage: "bell.badge.fill",
                            isExpanded: $showReminders
                        ) {
                            dailyReminderSectionContent
                        }

                        collapsibleSection(
                            title: "Exam & deadline reminders",
                            systemImage: "calendar.circle.fill",
                            isExpanded: $showAcademicReminders
                        ) {
                            academicReminderSectionContent
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
                            systemImage: "sparkles",
                            isExpanded: $showOnboarding
                        ) {
                            onboardingSectionContent
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

    private var dailyReminderSectionContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            datePickerRow(title: "Morning reminder", selection: $viewModel.morningReminderTime)
            datePickerRow(title: "Night planning reminder", selection: $viewModel.nightPlanningTime)
            datePickerRow(title: "Night reflection reminder", selection: $viewModel.nightCheckInTime)
            datePickerRow(title: "Friday review reminder", selection: $viewModel.fridayReminderTime)

            Button("Save Daily Reminder Times") {
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

    private var academicReminderSectionContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            styledTextField(title: "Reminder title", text: $viewModel.reminderTitleInput)

            VStack(alignment: .leading, spacing: 8) {
                Text("Type")
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                Picker("Type", selection: $viewModel.reminderTypeInput) {
                    ForEach(ReminderType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Date and time")
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                DatePicker(
                    "",
                    selection: $viewModel.reminderDateInput,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .labelsHidden()
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            VStack(alignment: .leading, spacing: 10) {
                Toggle("Add optional extra reminder", isOn: $viewModel.includesOptionalReminder)
                    .tint(AppTheme.plum)
                    .foregroundStyle(AppTheme.textPrimary)

                if viewModel.includesOptionalReminder {
                    Picker("Extra reminder", selection: $viewModel.optionalReminderOffset) {
                        ForEach(ReminderOffset.allCases) { offset in
                            Text(offset.rawValue).tag(offset)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }

            Text("Hard-coded reminders: 1 week before and 1 day before.")
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)

            HStack(spacing: 10) {
                Button(viewModel.editingReminderID == nil ? "Save Reminder" : "Update Reminder") {
                    viewModel.saveAcademicReminder()
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppTheme.plum)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                if viewModel.editingReminderID != nil {
                    Button("Cancel") {
                        viewModel.clearReminderForm()
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.lavender)
                    .foregroundStyle(AppTheme.deepPlum)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
            }

            if !viewModel.academicReminders.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Saved reminders")
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)

                    ForEach(viewModel.academicReminders) { reminder in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(reminder.title)
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.textPrimary)

                                    Text(reminder.type.rawValue)
                                        .font(.subheadline)
                                        .foregroundStyle(AppTheme.deepPlum)

                                    Text(reminder.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.subheadline)
                                        .foregroundStyle(AppTheme.textSecondary)
                                }

                                Spacer()
                            }

                            HStack(spacing: 10) {
                                Button("Edit") {
                                    viewModel.startEditingReminder(reminder)
                                }
                                .fontWeight(.semibold)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(AppTheme.softPink)
                                .foregroundStyle(AppTheme.deepPlum)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                                Button("Delete", role: .destructive) {
                                    viewModel.deleteAcademicReminder(reminder)
                                }
                                .fontWeight(.semibold)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(AppTheme.lavender)
                                .foregroundStyle(AppTheme.deepPlum)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                        }
                        .padding(14)
                        .background(AppTheme.lightPink.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
            }
        }
    }

    private var aboutSectionContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Accountability Buddy")
                .font(.headline)
                .foregroundStyle(AppTheme.deepPlum)

            Text("A soft little space for planning tomorrow, handling today, and reflecting honestly each night.")
                .foregroundStyle(AppTheme.textSecondary)
        }
    }

    private var onboardingSectionContent: some View {
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
