//
//  Extensions.swift
//  Memorize
//
//  Created by sam hastings on 20/11/2023.
//

import Foundation

extension String {
    func madeUnique(withRespectTo otherStrings: [String]) -> String {
        var possiblyUnique = self
        var uniqueNumber = 1
        while otherStrings.contains(possiblyUnique) {
            possiblyUnique = self + String(uniqueNumber)
            uniqueNumber += 1
        }
        return possiblyUnique
    }
}
