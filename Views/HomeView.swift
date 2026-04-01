//
//  ContentView.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Accountability Buddy")
                            .font(.largeTitle.bold())

                        Text("A tiny daily reset for your brain.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today’s prompts")
                            .font(.title3.bold())

                        promptCard(
                            title: viewModel.promptOne,
                            text: $viewModel.learnedToday
                        )

                        promptCard(
                            title: viewModel.promptTwo,
                            text: $viewModel.avoidedToday
                        )

                        promptCard(
                            title: viewModel.promptThree,
                            text: $viewModel.smallWin
                        )
                    }

                    Button {
                        viewModel.saveTodayEntry()
                    } label: {
                        Text(viewModel.hasEntryForToday() ? "Today already completed" : "Save Today’s Check-In")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.hasEntryForToday())

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Why this matters")
                            .font(.headline)

                        Text("This is not about doing everything. It’s about collecting proof that you showed up.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .navigationTitle("Today")
            .alert("Accountability Buddy", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }

    @ViewBuilder
    private func promptCard(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            TextEditor(text: text)
                .frame(minHeight: 100)
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
