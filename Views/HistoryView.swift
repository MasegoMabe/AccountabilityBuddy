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
            List {
                if viewModel.entries.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 40))
                            .foregroundStyle(.gray)

                        Text("No entries yet")
                            .font(.headline)

                        Text("Your daily check-ins will appear here.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    ForEach(viewModel.entries) { entry in
                        NavigationLink(destination: EntryDetailView(entryID: entry.id)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.headline)

                                Text("Learned: \(entry.learnedToday)")
                                    .lineLimit(1)

                                Text("Avoided: \(entry.avoidedToday)")
                                    .lineLimit(1)

                                Text("Small win: \(entry.smallWin)")
                                    .lineLimit(1)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .onDelete(perform: viewModel.deleteEntries)
                }
            }
            .navigationTitle("History")
        }
    }
}
