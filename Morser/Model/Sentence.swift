//
//  Sentence.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import Foundation
import SwiftData
import SwiftUI
@Model
class Sentence{
    init(sentence: String, order: Int) {
        self.sentence = sentence
        self.order = order
    }
    var sentence: String
    var boundSentence: Binding<String> {
        .init(
            get: {
                self.sentence
            },
            set: { newValue in
                self.sentence = newValue
            }
        )
    }
    var order:Int
    var morseCode:String {
        return MorseEncoder.encode(string: sentence)
    }
}