//
//  EntryDetailView.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

struct EntryDetailView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    let entryID: UUID

    private var entry: ReflectionEntry? {
        viewModel.entries.first(where: { $0.id == entryID })
    }

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            Group {
                if let entry {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(entry.date.formatted(date: .complete, time: .omitted))
                                .font(.title2.bold())
                                .foregroundStyle(AppTheme.textPrimary)

                            detailCard(title: "School", text: entry.schoolReflection)
                            detailCard(title: "Work", text: entry.workReflection)
                            detailCard(title: "Personal", text: entry.personalReflection)
                            detailCard(title: "Project Lab", text: entry.projectLabReflection)
                        }
                        .padding()
                    }
                    .toolbar {
                        NavigationLink("Edit") {
                            EditEntryView(entry: entry)
                                .environmentObject(viewModel)
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 40))
                            .foregroundStyle(AppTheme.plum)

                        Text("Entry not found")
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
            }
        }
        .navigationTitle("Entry")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func detailCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Text(text)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .softCard()
    }
}
