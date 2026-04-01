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
        Group {
            if let entry {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(entry.date.formatted(date: .complete, time: .omitted))
                            .font(.title2.bold())

                        detailCard(
                            title: viewModel.promptOne,
                            text: entry.learnedToday
                        )

                        detailCard(
                            title: viewModel.promptTwo,
                            text: entry.avoidedToday
                        )

                        detailCard(
                            title: viewModel.promptThree,
                            text: entry.smallWin
                        )

                        if let aiReflection = entry.aiReflection, !aiReflection.isEmpty {
                            detailCard(
                                title: "AI Reflection",
                                text: aiReflection
                            )
                        }
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
                        .foregroundStyle(.gray)

                    Text("Entry not found")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
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

            Text(text)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
