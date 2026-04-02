//
//  Theme.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import SwiftUI

enum AppTheme {
    static let background = LinearGradient(
        colors: [
            Color(red: 1.00, green: 0.95, blue: 0.98),
            Color(red: 1.00, green: 0.88, blue: 0.94),
            Color(red: 0.99, green: 0.82, blue: 0.91)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardBackground = Color.white.opacity(0.90)

    static let plum = Color(red: 0.96, green: 0.28, blue: 0.62)
    static let hotPink = Color(red: 1.00, green: 0.20, blue: 0.60)
    static let softPink = Color(red: 1.00, green: 0.72, blue: 0.84)
    static let blush = Color(red: 1.00, green: 0.84, blue: 0.90)
    static let lightPink = Color(red: 1.00, green: 0.94, blue: 0.97)

    static let lavender = Color(red: 0.93, green: 0.84, blue: 0.98)
    static let deepPlum = Color(red: 0.55, green: 0.18, blue: 0.45)
    static let success = Color(red: 0.26, green: 0.76, blue: 0.48)

    static let textPrimary = Color(red: 0.35, green: 0.10, blue: 0.24)
    static let textSecondary = Color(red: 0.55, green: 0.35, blue: 0.46)

    static let buttonGradient = LinearGradient(
        colors: [plum, hotPink],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let secondaryGradient = LinearGradient(
        colors: [softPink, blush],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let shadow = Color.black.opacity(0.08)
}

extension View {
    func softCard() -> some View {
        self
            .padding()
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: AppTheme.shadow, radius: 10, x: 0, y: 6)
    }
}
