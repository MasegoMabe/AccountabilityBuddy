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
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()

                    ZStack {
                        Circle()
                            .fill(AppTheme.lavender.opacity(0.7))
                            .frame(width: 120, height: 120)

                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 58))
                            .foregroundStyle(AppTheme.plum)
                    }

                    VStack(spacing: 12) {
                        Text("Welcome to Masego's Accountability Buddy")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("A soft little space to plan, reflect, and stay consistent with yourself.")
                            .font(.body)
                            .foregroundStyle(AppTheme.textSecondary)
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
                    .softCard()

                    Button {
                        viewModel.completeOnboarding()
                    } label: {
                        Text("Get Started")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppTheme.buttonGradient)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }

    @ViewBuilder
    private func onboardingPoint(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Text(subtitle)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
