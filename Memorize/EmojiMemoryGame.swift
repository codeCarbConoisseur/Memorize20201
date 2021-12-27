
import SwiftUI

class EmojiMemoryGame: ObservableObject {

    @Published private var model: MemoryGame<String>
    @Published private var _isHelpUsed: Bool = false
    @Published private var _foundAllMatches: Bool = false
    private var _isRandom: Bool = false
    private(set) var theme: EmojiMemoryTheme

    init(theme: EmojiMemoryTheme? = nil) {
        if let theme = theme {
            self.theme = theme
        } else {
            self.theme = EmojiMemoryTheme.themes.randomElement()!
            _isRandom = true
        }
        let emoji = self.theme.emoji.shuffled()
        model = MemoryGame(numberOfPairsOfCards: self.theme.numberOfPairs) { emoji[$0] }
    }

    // MARK: - Access to the Model

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

    var score: Int {
        model.score
    }
    
    var isHelpUsed: Bool {
        return _isHelpUsed
    }
    
    var isRandom: Bool {
        return _isRandom
    }
    
    var foundAllMatches: Bool {
        return _foundAllMatches
    }

    // MARK: - Intent(s)

    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
        if model.foundAllMatches() {
            _foundAllMatches = true
        }
    }

    func helpTimeEnded() {
        model.flipEverything(isFaceUp: false)
    }
    
    
    func help() {
        model.flipEverything(isFaceUp: true)
        _isHelpUsed = true
    }
    
    func checkIfRandom(storeThemes: [EmojiMemoryTheme]) {
        if isRandom {
            self.theme = storeThemes.randomElement()!
        }
    }
    
    func restart() {
        _foundAllMatches = false
        let emoji = theme.emoji.shuffled()
        let numberOfPairs: Int = theme.numberOfPairs
        model = MemoryGame(numberOfPairsOfCards: numberOfPairs) { emoji[$0] }
    }
}
