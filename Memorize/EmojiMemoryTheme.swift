
import Foundation
import SwiftUI

struct EmojiMemoryTheme: Codable, Identifiable, Equatable {
    var id: String { name }
    let name: String
    let emoji: [String]
    let cardBackColor: UIColor.RGB
    let backgroundColor: UIColor.RGB
    let numberOfPairs: Int

    var color: Color {
        Color(cardBackColor)
    }

    var json: Data? {
        try? JSONEncoder().encode(self)
    }

    init(name: String, emoji: [String], cardBackColor: UIColor.RGB, backgroundColor: UIColor.RGB, numberOfPairs: Int) {
        self.name = name
        self.emoji = emoji
        self.cardBackColor = cardBackColor
        self.backgroundColor =  backgroundColor
        self.numberOfPairs = numberOfPairs
    }

    init?(json: Data?) {
        if let json = json, let newEmojiTheme = try? JSONDecoder().decode(EmojiMemoryTheme.self, from: json) {
            self = newEmojiTheme
        }
        else {
            return nil
        }
    }

    static var themes: [EmojiMemoryTheme] = [
        EmojiMemoryTheme(name: "Animals", emoji: ["🐶","🐯","🐱","🐭","🦊","🐻","🐼","🐷","🐨","🐵","🦁", "🐔"], cardBackColor: UIColor.blue.rgb, backgroundColor: UIColor.clear.rgb, numberOfPairs: 8),
        EmojiMemoryTheme(name: "Food", emoji: ["🍏","🍎","🍊","🍋","🍌","🥑","🥝","🍇","🍐","🍓","🍒","🍉"], cardBackColor: UIColor.blue.rgb, backgroundColor: UIColor.clear.rgb, numberOfPairs: 8),
        EmojiMemoryTheme(name: "Faces", emoji: ["😃","😂","😍","🙃","😇","😎","🤓","🤩",
                                                "🤬","🥶","🤢","🤠","😷","🤕","😱","😜",
                                                "🥵","🤡","💩","🥳"],
                         cardBackColor: UIColor.systemPink.rgb, backgroundColor: UIColor.clear.rgb, numberOfPairs: 7),
    ]

    static let template = EmojiMemoryTheme(name: "Untitled", emoji: ["😃", "👍🏻", "🌈", "❤️"], cardBackColor: UIColor.systemGreen.rgb, backgroundColor: UIColor.clear.rgb, numberOfPairs: 4)
    
    static func ==(lhs: EmojiMemoryTheme, rhs: EmojiMemoryTheme) -> Bool {
        return lhs.id == rhs.id
    }
}
