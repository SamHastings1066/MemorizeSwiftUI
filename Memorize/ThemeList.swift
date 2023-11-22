//
//  ThemeList.swift
//  Memorize
//
//  Created by sam hastings on 17/11/2023.
//

import SwiftUI

struct ThemeList: View {
    @ObservedObject var store: ThemeStore
    
    @State private var themeSelectedForEditing: Theme?
    
    var body: some View {
        // Navigation stack 41:30 in lecture 13
        NavigationStack {
            List{
                ForEach(store.themes) { theme in
                    NavigationLink(value: theme){
                        ThemeRow(theme: theme)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            themeSelectedForEditing = theme
                        } label: {
                            Label("Edit", systemImage: "info.circle.fill")
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            store.delete(theme)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationDestination(for: Theme.self) { theme in
                let game = EmojiMemoryGame(theme: theme)
                EmojiMemoryGameView(viewModel: game)
            }
            .popover(item: $themeSelectedForEditing) { theme in
                if let index = store.themes.firstIndex(where: {$0.id == theme.id}) {
                    ThemeEditor(theme: $store.themes[index] )
                }
                
            }
            .navigationTitle("Themes")
            .toolbar{
                Button {
                    store.appendDefaultTheme()
                    themeSelectedForEditing = store.themes.last
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct ThemeRow: View {
    var theme: Theme
    var body: some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .foregroundStyle(Color(rgba: theme.color))
            Text("\(theme.numPairs)" + " pairs from " + theme.emojis.joined()).lineLimit(1)
        }
    }
}

//#Preview {
//    ThemeList()
//}
