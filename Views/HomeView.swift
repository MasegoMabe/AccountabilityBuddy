//
//  HomeView.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    @State private var showTodayTasks = true
    @State private var showTomorrowPlan = false
    @State private var showNightCheckIn = false
    @State private var showWhyItMatters = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        headerSection
                        verseCard
                        collapsibleSection(
                            title: "Today’s to-do list",
                            systemImage: "sparkles",
                            isExpanded: $showTodayTasks
                        ) {
                            todayTodoContent
                        }

                        collapsibleSection(
                            title: "Plan tomorrow tonight",
                            systemImage: "moon.stars.fill",
                            isExpanded: $showTomorrowPlan
                        ) {
                            tomorrowPlanningContent
                        }

                        collapsibleSection(
                            title: "Night check-in",
                            systemImage: "heart.text.square.fill",
                            isExpanded: $showNightCheckIn
                        ) {
                            reflectionContent
                        }

                        collapsibleSection(
                            title: "Why this matters",
                            systemImage: "heart.fill",
                            isExpanded: $showWhyItMatters
                        ) {
                            whyItMattersContent
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Today")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.deepPlum)
                }
            }
            .alert("Accountability Buddy", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Hey Masego 🌷")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("your Accountability Buddy here, ")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.deepPlum.opacity(0.9))

            Text("Let’s have a beautiful, disciplined day 💕")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var verseCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today’s verse")
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                Spacer()

                Text(viewModel.todayVerse.tone == .firm ? "Firm" : "Gentle")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(viewModel.todayVerse.tone == .firm ? AppTheme.softPink : AppTheme.lavender)
                    .clipShape(Capsule())
                    .foregroundStyle(AppTheme.deepPlum)
            }

            Text("“\(viewModel.todayVerse.text)”")
                .font(.body)
                .foregroundStyle(AppTheme.textPrimary)

            Text(viewModel.todayVerse.reference)
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .softCard()
    }

    private var todayTodoContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                TextField("Add a task for today", text: $viewModel.todayTaskInput)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppTheme.softPink, lineWidth: 1)
                    )

                Button("Add") {
                    viewModel.addTaskToToday()
                }
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppTheme.plum)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            if viewModel.todayTasks().isEmpty {
                Text("No tasks yet for today ✨")
                    .foregroundStyle(AppTheme.textSecondary)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.todayTasks()) { task in
                        HStack(spacing: 12) {
                            Button {
                                viewModel.toggleTodayTask(task)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundStyle(task.isCompleted ? AppTheme.success : AppTheme.blush)

                                    Text(task.title)
                                        .font(.body)
                                        .strikethrough(task.isCompleted)
                                        .foregroundStyle(AppTheme.textPrimary)

                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)

                            Button(role: .destructive) {
                                viewModel.deleteTodayTask(task)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(12)
                        .background(AppTheme.lightPink.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
            }

            Text("Completed \(viewModel.completedTaskCountToday()) of \(viewModel.totalTaskCountToday())")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.textSecondary)
        }
    }

    private var tomorrowPlanningContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                TextField("Add a task for tomorrow", text: $viewModel.tomorrowTaskInput)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppTheme.lavender, lineWidth: 1)
                    )

                Button("Add") {
                    viewModel.addTaskToTomorrow()
                    viewModel.scheduleTomorrowMorningReminder()
                }
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppTheme.deepPlum)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            if viewModel.tomorrowTasks().isEmpty {
                Text("No tasks yet for tomorrow 🌙")
                    .foregroundStyle(AppTheme.textSecondary)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.tomorrowTasks()) { task in
                        HStack(spacing: 12) {
                            Image(systemName: "moon.stars")
                                .foregroundStyle(AppTheme.plum)

                            Text(task.title)
                                .foregroundStyle(AppTheme.textPrimary)

                            Spacer()

                            Button(role: .destructive) {
                                viewModel.deleteTomorrowTask(task)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(12)
                        .background(AppTheme.lightPink.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Notes for tomorrow")
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                TextEditor(text: $viewModel.tomorrowNotes)
                    .frame(minHeight: 100)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(AppTheme.softPink, lineWidth: 1)
                    )

                Button("Save Tomorrow Plan") {
                    viewModel.saveTomorrowNotes()
                    viewModel.scheduleTomorrowMorningReminder()
                    viewModel.alertMessage = "Tomorrow’s plan saved."
                    viewModel.showAlert = true
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppTheme.softPink)
                .foregroundStyle(AppTheme.deepPlum)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }

    private var reflectionContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            promptCard(title: viewModel.promptOne, text: $viewModel.learnedToday)
            promptCard(title: viewModel.promptTwo, text: $viewModel.avoidedToday)
            promptCard(title: viewModel.promptThree, text: $viewModel.smallWin)

            Button {
                viewModel.saveTodayEntry()
            } label: {
                Text(viewModel.hasEntryForToday() ? "Today already completed" : "Save Today’s Check-In")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(viewModel.hasEntryForToday() ? AppTheme.lavender : AppTheme.plum)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .disabled(viewModel.hasEntryForToday())
        }
    }

    private var whyItMattersContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("This is not about doing everything. It’s about collecting proof that you showed up.")
                .foregroundStyle(AppTheme.textSecondary)
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
    private func promptCard(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            TextEditor(text: text)
                .frame(minHeight: 95)
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppTheme.softPink, lineWidth: 1)
                )
        }
        .padding(14)
        .background(AppTheme.lightPink.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
