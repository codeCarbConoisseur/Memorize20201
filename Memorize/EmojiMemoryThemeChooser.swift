
import SwiftUI

struct EmojiMemoryThemeChooser: View {
    @EnvironmentObject var store: EmojiMemoryThemeStore
    @State private var editMode: EditMode = .inactive
    @State private var showThemeEditor = false
    @State private var editingTheme: EmojiMemoryTheme?
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    ZStack {
                        EmojiThemeRow(theme: theme, isEditing: self.editMode == .active) {
                            self.editingTheme = theme
                        }
                        NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))) {
                            Color.clear
                        }
                        .opacity(self.editMode.isEditing ? 0 : 1)
                        
                    }
                }
                .onDelete { indexSet in
                    self.store.themes.remove(atOffsets: indexSet)
                }
                Spacer()
                NavigationLink(destination: EmojiMemoryGameRules()) {
                    Text("Show me some rules!")
                        .font(.title)
                        .foregroundColor(Color.primary)
                }
            }
            .sheet(item: self.$editingTheme, content: { theme in
                EmojiMemoryThemeEditor(theme: theme)
                    .environmentObject(self.store)
            })
            .navigationBarTitle("Memorize")
            .navigationBarItems(
                leading: Button(action: { self.store.themes.append(EmojiMemoryTheme.template) },
                                label: { Image(systemName: "plus").imageScale(.large) })
                    .opacity(editMode == .inactive ? 1 : 0),
                trailing: HStack {
                    EditButton()
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame())) {
                        Text("Random")
                    }.environmentObject(self.store)
                })
//            .environment(\.editMode, $editMode)
        }
    }
}

struct EmojiMemoryThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryThemeChooser()
            .environmentObject(EmojiMemoryThemeStore())
    }
}

struct EmojiThemeRow: View {
    let theme: EmojiMemoryTheme
    let isEditing: Bool
    let editTheme: ()->Void
    

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(theme.name)
                    .font(.title)
                    .foregroundColor(self.isEditing ? Color.primary : theme.color)

                HStack {
                    Text("\(theme.numberOfPairs == theme.emoji.count ? "All" : "\(theme.numberOfPairs)") of \(theme.emoji.joined())")
                        .truncationMode(.tail)
                        .lineLimit(1)
                }
            }
            Spacer()

                if self.isEditing {
                    Button(action: editTheme) {
                        Image(systemName: "pencil.circle.fill")
                            .imageScale(.large)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(theme.color)
                }
        }
    }
}
