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
        NavigationView {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    Text("Your progress 💖")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.textPrimary)
                        .padding(.top, 8)

                    statCard(title: "Current Streak", value: "\(viewModel.currentStreak()) days", icon: "flame.fill")
                    statCard(title: "Total Check-Ins", value: "\(viewModel.totalEntries())", icon: "heart.circle.fill")
                    statCard(
                        title: "Today’s Status",
                        value: viewModel.hasEntryForToday() ? "Completed" : "Not completed",
                        icon: "checkmark.seal.fill"
                    )

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }

    @ViewBuilder
    private func statCard(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppTheme.lavender)
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .foregroundStyle(AppTheme.deepPlum)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                Text(value)
                    .font(.title3.bold())
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()
        }
        .softCard()
    }
}
