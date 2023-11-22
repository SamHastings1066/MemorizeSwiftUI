//
//  Theme.swift
//  Memorize
//
//  Created by sam hastings on 17/11/2023.
//

import Foundation

struct Theme: Codable, Hashable, Identifiable {
    var name: String
    var emojisString: String
    var emojis: [String] {
        emojisString.map{String($0)}
    }
    var numPairs: Int
    var color: RGBA
    var id = UUID()
    
    struct RGBA: Codable, Equatable, Hashable {
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
    }
}
