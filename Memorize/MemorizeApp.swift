//
//  MemorizeApp.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/3/23.
//  Copyright Stanford University 2023
//

import SwiftUI

@main
struct MemorizeApp: App {
    //@StateObject var game = EmojiMemoryGame()
    @StateObject var themeStore = ThemeStore()
    
    var body: some Scene {
        WindowGroup {
            ThemeList(store: themeStore)
            //EmojiMemoryGameView(viewModel: game)
        }
    }
}
