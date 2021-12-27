
import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @EnvironmentObject var store: EmojiMemoryThemeStore
    
    var body: some View {
        VStack {
            Group {
                if viewModel.foundAllMatches {
                    Text("Thank you for the game!\nYour score is: \(viewModel.score)")
                } else {
                    Grid(viewModel.cards) { card in
                        CardView(card: card)
                            .padding(5)
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.6)) {
                                    self.viewModel.choose(card: card)
                                }
                            }
                    }
                    .padding()
                    .foregroundColor(viewModel.theme.color)
                }
            }
            

            HStack {
                restartButton
                Spacer()
                helpButton
            }
        }
        .accentColor(viewModel.theme.color)
        .padding()
        .background(Color(viewModel.theme.backgroundColor))
        .navigationBarTitle(Text(viewModel.theme.name), displayMode: .large)
        .navigationBarItems(trailing: Text("\(viewModel.score)").font(.largeTitle))
        .onAppear(perform: {
            if viewModel.isRandom {
                viewModel.checkIfRandom(storeThemes: store.themes)
                viewModel.restart()
            } else {
                viewModel.restart()
            }
        })
    }
    
    private var helpButton: some View {
        Button(action: help) {
            Text("Help!")
                .font(.subheadline)
                .padding()
                .foregroundColor(viewModel.isHelpUsed || viewModel.foundAllMatches ? Color.gray : Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.theme.color))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary, lineWidth: 1))
                .shadow(radius: 5)
        }
    }
    
    private func help() {
        if !viewModel.isHelpUsed || !viewModel.foundAllMatches {
            withAnimation(.linear(duration: 0.6)) {
                viewModel.help()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                withAnimation(.linear(duration: 0.6)) {
                    viewModel.helpTimeEnded()
                }
            })
        }
    }

    private var restartButton: some View {
        Button(action: restart) {
            Text("New Game")
                .font(.headline)
                .padding()
                .foregroundColor(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.theme.color))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary, lineWidth: 1))
                .shadow(radius: 5)
        }
    }

    private func restart() {
        withAnimation(.easeInOut) {
            viewModel.restart()
        }
    }
}


struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { proxy in
            self.body(for: proxy.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0

    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }

    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: .degrees(0-90), endAngle: .degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    }
                    else {
                        Pie(startAngle: .degrees(0-90), endAngle: .degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5)
                .opacity(0.4)
                .transition(.identity)

                Text(card.content)
                    .font(fontSize(for: size))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }

    // MARK: - Drawing Constants

    private func fontSize(for size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * 0.70)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return NavigationView {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
