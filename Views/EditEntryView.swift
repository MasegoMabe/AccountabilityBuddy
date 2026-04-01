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

    @State private var learnedToday: String
    @State private var avoidedToday: String
    @State private var smallWin: String
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(entry: ReflectionEntry) {
        self.entry = entry
        _learnedToday = State(initialValue: entry.learnedToday)
        _avoidedToday = State(initialValue: entry.avoidedToday)
        _smallWin = State(initialValue: entry.smallWin)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Edit Check-In")
                        .font(.largeTitle.bold())

                    Text(entry.date.formatted(date: .complete, time: .omitted))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                promptCard(title: viewModel.promptOne, text: $learnedToday)
                promptCard(title: viewModel.promptTwo, text: $avoidedToday)
                promptCard(title: viewModel.promptThree, text: $smallWin)

                Button("Save Changes") {
                    saveChanges()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
            .padding()
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
        let trimmedLearned = learnedToday.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAvoided = avoidedToday.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSmallWin = smallWin.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedLearned.isEmpty,
              !trimmedAvoided.isEmpty,
              !trimmedSmallWin.isEmpty else {
            alertMessage = "Please fill in all 3 prompts before saving."
            showAlert = true
            return
        }

        let updatedEntry = ReflectionEntry(
            id: entry.id,
            date: entry.date,
            learnedToday: trimmedLearned,
            avoidedToday: trimmedAvoided,
            smallWin: trimmedSmallWin,
            aiReflection: entry.aiReflection
        )

        viewModel.updateEntry(updatedEntry: updatedEntry)
        dismiss()
    }

    @ViewBuilder
    private func promptCard(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            TextEditor(text: text)
                .frame(minHeight: 120)
                .padding(8)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
