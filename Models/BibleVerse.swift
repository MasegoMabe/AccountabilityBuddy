//
//  BibleVerse.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import Foundation

struct BibleVerse: Identifiable, Codable, Equatable {
    var id: String { reference }
    let text: String
    let reference: String
    let tone: VerseTone
}

enum VerseTone: String, Codable {
    case gentle
    case firm
}
