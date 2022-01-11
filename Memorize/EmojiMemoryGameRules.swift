//
//  EmojiMemoryGameRules.swift
//  Memorize
//
//  Created by Захар  Сегал on 11.01.2022.
//  Copyright © 2022 Philipp. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameRules: View {
    var body: some View {
        VStack {
            Text("Rules!")
                .ruleModified()
            Spacer().frame(height: 50)
            Text("основной текст правил")
                .ruleModified()
            Text("За каждое несовпадение ранее увиденной карты штраф 1 очко")
                .ruleModified()
            Spacer().frame(height: 50)
            Text("У игрока есть возможность воспользоваться подсказкой, тогда все карты перевернутся на 1 сек.Подсказкой можно воспользоваться лишь один раз за игру.")
                .ruleModified()
        }
        
    }
}

struct EmojiMemoryGameRules_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameRules()
    }
}
