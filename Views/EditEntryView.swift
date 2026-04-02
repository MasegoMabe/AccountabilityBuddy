//
//  EditEntryView.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

struct EditEntryView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss

    let entry: ReflectionEntry

    @State private var schoolReflection: String
    @State private var workReflection: String
    @State private var personalReflection: String
    @State private var projectLabReflection: String
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(entry: ReflectionEntry) {
        self.entry = entry
        _schoolReflection = State(initialValue: entry.schoolReflection)
        _workReflection = State(initialValue: entry.workReflection)
        _personalReflection = State(initialValue: entry.personalReflection)
        _projectLabReflection = State(initialValue: entry.projectLabReflection)
    }

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Edit Reflection")
                            .font(.largeTitle.bold())
                            .foregroundStyle(AppTheme.textPrimary)

                        Text(entry.date.formatted(date: .complete, time: .omitted))
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    promptCard(title: "School", text: $schoolReflection)
                    promptCard(title: "Work", text: $workReflection)
                    promptCard(title: "Personal", text: $personalReflection)
                    promptCard(title: "Project Lab", text: $projectLabReflection)

                    Button("Save Changes") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.plum)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .padding()
            }
        }
        .navigationTitle("Edit Entry")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Accountability Buddy", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func saveChanges() {
        let school = schoolReflection.trimmingCharacters(in: .whitespacesAndNewlines)
        let work = workReflection.trimmingCharacters(in: .whitespacesAndNewlines)
        let personal = personalReflection.trimmingCharacters(in: .whitespacesAndNewlines)
        let projectLab = projectLabReflection.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !school.isEmpty, !work.isEmpty, !personal.isEmpty, !projectLab.isEmpty else {
            alertMessage = "Please fill in all 4 reflection sections before saving."
            showAlert = true
            return
        }

        let updatedEntry = ReflectionEntry(
            id: entry.id,
            date: entry.date,
            schoolReflection: school,
            workReflection: work,
            personalReflection: personal,
            projectLabReflection: projectLab
        )

        viewModel.updateEntry(updatedEntry: updatedEntry)
        dismiss()
    }

    @ViewBuilder
    private func promptCard(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            TextEditor(text: text)
                .frame(minHeight: 120)
                .padding(8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.softPink, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .softCard()
    }
}
