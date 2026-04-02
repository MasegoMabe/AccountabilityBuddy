//
//  BibleVerseProvider.swift
//  AccountabilityBuddy
//
//  Created by Masego Mabe on 2026. 04. 01..
//

import Foundation

enum BibleVerseProvider {
    static let verses: [BibleVerse] = [
        BibleVerse(
            text: "Commit your work to the Lord, and your plans will be established.",
            reference: "~Proverbs 16:3",
            tone: .gentle
        ),
        BibleVerse(
            text: "Whatever you do, work heartily, as for the Lord and not for men.",
            reference: "~Colossians 3:23",
            tone: .firm
        ),
        BibleVerse(
            text: "The plans of the diligent lead surely to abundance, but everyone who is hasty comes only to poverty.",
            reference: "~Proverbs 21:5",
            tone: .firm
        ),
        BibleVerse(
            text: "A little sleep, a little slumber, a little folding of the hands to rest, and poverty will come upon you like a robber.",
            reference: "~Proverbs 24:33–34",
            tone: .firm
        ),
        BibleVerse(
            text: "Let all that you do be done in love.",
            reference: "~1 Corinthians 16:14",
            tone: .gentle
        ),
        BibleVerse(
            text: "My grace is sufficient for you, for my power is made perfect in weakness.",
            reference: "~2 Corinthians 12:9",
            tone: .gentle
        ),
        BibleVerse(
            text: "The soul of the sluggard craves and gets nothing, while the soul of the diligent is richly supplied.",
            reference: "~Proverbs 13:4",
            tone: .firm
        ),
        BibleVerse(
            text: "Be strong, and let your heart take courage, all you who wait for the Lord.",
            reference: "~Psalm 31:24",
            tone: .gentle
        )
    ]

    static func verseForToday() -> BibleVerse {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return verses[(day - 1) % verses.count]
    }
}
