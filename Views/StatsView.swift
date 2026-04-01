//
//  StatsView.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                statCard(title: "Current Streak", value: "\(viewModel.currentStreak()) days")
                statCard(title: "Total Check-Ins", value: "\(viewModel.totalEntries())")
                statCard(title: "Today’s Status", value: viewModel.hasEntryForToday() ? "Completed" : "Not completed")

                Spacer()
            }
            .padding()
            .navigationTitle("Progress")
        }
    }

    @ViewBuilder
    private func statCard(title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)

            Text(value)
                .font(.title.bold())
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
