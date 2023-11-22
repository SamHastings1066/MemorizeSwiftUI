//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/12/23.
//  Copyright Stanford University 2023
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    var theme: Theme?
    
    private static let emojis = ["👻","🎃","🕷️","😈","💀","🕸️","🧙‍♀️","🙀","👹","😱","☠️","🍭"]
      
    private static func createMemoryGame(with theme: Theme?) -> MemoryGame<String> {
            if let theme = theme {
                return MemoryGame(numberOfPairsOfCards: theme.numPairs) { pairIndex in
                    if theme.emojis.indices.contains(pairIndex) {
                        return theme.emojis[pairIndex]
                    } else {
                        return "⁉️"
                    }
                }
            } else {
                return MemoryGame(numberOfPairsOfCards: 9) { _ in "⁉️" }
            }
        }
    
    init(theme: Theme?) {
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(with: theme)

    }
      
    @Published private var model: MemoryGame<String>
    
    var cards: Array<Card> {
        model.cards
    }
    
    var color: Color {
        if let theme = theme {
            Color(rgba: theme.color)
        } else {
            .orange
        }
    }
    
    var themeName: String {
        if let theme = theme {
            theme.name
        } else {
            "Unnamed"
        }
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
}
