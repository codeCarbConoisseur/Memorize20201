
import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var score = 0
    private var seenCards = [Card]()
    private var firstCardTimestamp : TimeInterval = 0

    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        set {
            for index in cards.indices {
                if cards[index].isFaceUp {
                    seenCards.append(cards[index])
                }
                cards[index].isFaceUp = index == newValue
            }
        }
    }

    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard, potentialMatchIndex != chosenIndex {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true

                    let currentCardTimestamp = Date().timeIntervalSinceReferenceDate
                    let multiplier = max(5 - (currentCardTimestamp - firstCardTimestamp), 1)
                    score += Int(2 * multiplier)
                }
                else {
                    score += seenCards.firstIndex(matching: cards[potentialMatchIndex]) != nil ? -1 : 0
                    score += seenCards.firstIndex(matching: cards[chosenIndex]) != nil ? -1 : 0
                }
                cards[chosenIndex].isFaceUp = true
            }
            else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                firstCardTimestamp = Date().timeIntervalSinceReferenceDate
            }
        }
    }
    
    func foundAllMatches() -> Bool {
        var cardMatches: Int = 0
        cards.forEach({ if $0.isMatched { cardMatches += 1}})
        return cardMatches == cards.count
    }
    
    mutating func flipBack(card: Card) {
        if let cardIndex = cards.firstIndex(matching: card) {
            cards[cardIndex].isFaceUp = false
        }
    }
    
    mutating func flipEverything(isFaceUp: Bool) {
        for index in cards.indices {
            cards[index].isFaceUp = isFaceUp
        }
    }

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
        cards.shuffle()
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }
                else {
                    stopUsingBonusTime()
                }
            }
        }

        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }

        var content: CardContent

        var id = UUID()


        // MARK: - Bonus Time
    
        //  bonus time for the card
        var bonusTimeLimit: TimeInterval = 5
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
