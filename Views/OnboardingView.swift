//
//  OnboardingView.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer()

                Image(systemName: "heart.text.square")
                    .font(.system(size: 70))
                    .foregroundStyle(.purple)

                VStack(spacing: 12) {
                    Text("Welcome to Accountability Buddy")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)

                    Text("A simple daily reflection app to help you stay consistent, clear, and honest with yourself.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 14) {
                    onboardingPoint(
                        title: "Reflect in 2–5 minutes",
                        subtitle: "Answer a few small prompts each day."
                    )

                    onboardingPoint(
                        title: "Track your progress",
                        subtitle: "Build proof that you are showing up."
                    )

                    onboardingPoint(
                        title: "Stay consistent",
                        subtitle: "Focus on small wins, not perfection."
                    )
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Button {
                    viewModel.completeOnboarding()
                } label: {
                    Text("Get Started")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }

    @ViewBuilder
    private func onboardingPoint(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)

            Text(subtitle)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
