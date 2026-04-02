//
//  PlanStore.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import Foundation

final class PlanStore {
    private let plansKey = "accountability_day_plans"

    func save(plans: [DayPlan]) {
        do {
            let data = try JSONEncoder().encode(plans)
            UserDefaults.standard.set(data, forKey: plansKey)
        } catch {
            print("Failed to save plans: \(error.localizedDescription)")
        }
    }

    func load() -> [DayPlan] {
        guard let data = UserDefaults.standard.data(forKey: plansKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([DayPlan].self, from: data)
        } catch {
            print("Failed to load plans: \(error.localizedDescription)")
            return []
        }
    }
}
