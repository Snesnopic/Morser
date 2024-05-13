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

