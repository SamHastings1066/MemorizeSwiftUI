//
//  ThemeStore.swift
//  Memorize
//
//  Created by sam hastings on 17/11/2023.
//

import SwiftUI

extension UserDefaults {

    /// Returns the an array of all themes stored in UserDefaults with the key `forKey`.
    func theme(forKey key: String) -> [Theme] {
        if let jsonData = data(forKey: key),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            return decodedThemes
        } else {
            return []
        }
    }
    /// Sets the `themes` array of Theme instances in UserDefault for the key `forKey`.
    func set(_ themes: [Theme], forKey key: String) {
        let data = try? JSONEncoder().encode(themes)
        set(data, forKey: key)
    }
}

class ThemeStore: ObservableObject {
    
    /// Key to access the themes array stored in UserDefaults.
    private let userDefaultsKey = "ThemeStore"
    
    /// The array of all Theme instances that can be used to implement a game's theme.
    var themes: [Theme] {
        get {
            UserDefaults.standard.theme(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send()
            }
        }
    }
    
    
    init() {
        // In the event that there is no Array of Theme instances stored in UserDefaults (because, for example, it is the first time the game is loaded), this code ensures that `themes` is populated with the pre-defined builtins array.
        if themes.isEmpty {
            themes = ThemeStore.builtins
        }
    }
    
    @Published private var _cursorIndex = 0
    
    var cursorIndex: Int {
        get { boundsCheckedCursorIndex(_cursorIndex) }
        set { _cursorIndex = boundsCheckedCursorIndex(newValue)}
    }
    
    /// Returns a cursor index that is within the range [0,..,themes.count - 1]
    private func boundsCheckedCursorIndex(_ index: Int) -> Int {
        var index = index % themes.count
        if index < 0 {
            index += themes.count
        }
        return index
    }
    
    static var builtins: [Theme] {
        [
            Theme(name: "Vehicles", emojisString: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓", numPairs: 9, color: Theme.RGBA(color: .blue)),
            Theme(name: "Sports", emojisString: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳", numPairs: 7, color: Theme.RGBA(color: .green))
        ]
    }
    
    // MARK: - Adding themes
    
    func append(_ theme: Theme) {
        if let themeIndex = themes.firstIndex(where: {$0.id == theme.id}) {
            if themes.count == 1 {
                themes = [theme]
            } else {
                themes.remove(at: themeIndex)
                themes.append(theme)
            }
        } else {
            themes.append(theme)
        }
    }
    
    func append(name: String, emojisString: String, numPairs: Int, color: Theme.RGBA) {
        append(Theme(name: name, emojisString: emojisString, numPairs: numPairs, color: color))
    }
    
    func appendDefaultTheme() {
        let themeName = "New Theme".madeUnique(withRespectTo: themes.map{$0.name})
        
        let defaultTheme = Theme(name: themeName, emojisString: "🍆🍑💦", numPairs: 3, color: Theme.RGBA(red: 0, green: 0, blue: 0, alpha: 1))
        append(defaultTheme)
    }
    
    // MARK: - deleting themes
    
    func delete(_ theme: Theme) {
        if let index = themes.firstIndex(where: {$0.id == theme.id}) {
            themes.remove(at: index)
        }
    }
    
}

extension Color {
    init(rgba: Theme.RGBA) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}
extension Theme.RGBA {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}
