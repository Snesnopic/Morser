//
//  Extensions.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func `if`<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T: View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension Character {
    var isKorean: Bool {
        // Define the range of Hangul syllables in Unicode
        let hangulRange = 0xAC00...0xD7A3
        // Get the Unicode scalar value of the character
        let scalarValue = self.unicodeScalars.first?.value
        // Check if the scalar value falls within the Hangul range
        return scalarValue != nil && hangulRange.contains(Int(scalarValue!))
    }
}

extension String {
    func createAhapFile(_ withName: String = "temp") -> URL {
      let url = FileManager.default.temporaryDirectory
        .appendingPathComponent(withName)
        .appendingPathExtension("ahap")
      let string = self
      try? string.write(to: url, atomically: true, encoding: .utf8)
      return url
    }
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
    // helper function to get single char from string
    func charAt(_ index: Int) -> Character {
        return Array(self)[index]
    }
    func morseCode() -> String {
          return MorseEncoder.encode(string: self)
    }
}

extension FetchedResults<Sentence> {
    func toArray() -> [Sentence] {
        var array: [Sentence] = []
        self.forEach { result in
            array.append(result)
        }
        return array
    }
}
