//
//  HistoryView.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                if viewModel.entries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 46))
                            .foregroundStyle(AppTheme.plum)

                        Text("No entries yet")
                            .font(.title3.bold())
                            .foregroundStyle(AppTheme.textPrimary)

                        Text("Your daily check-ins will appear here.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.entries) { entry in
                            NavigationLink(destination: EntryDetailView(entryID: entry.id)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.deepPlum)

                                    Text("Learned: \(entry.learnedToday)")
                                        .lineLimit(1)
                                        .foregroundStyle(AppTheme.textPrimary)

                                    Text("Avoided: \(entry.avoidedToday)")
                                        .lineLimit(1)
                                        .foregroundStyle(AppTheme.textPrimary)

                                    Text("Small win: \(entry.smallWin)")
                                        .lineLimit(1)
                                        .foregroundStyle(AppTheme.textPrimary)
                                }
                                .padding(.vertical, 8)
                            }
                            .listRowBackground(AppTheme.cardBackground)
                        }
                        .onDelete(perform: viewModel.deleteEntries)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                }
            }
            .navigationTitle("History")
        }
    }
}
