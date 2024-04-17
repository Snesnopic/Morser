//
//  MorseEncoder.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import Foundation

class MorseEncoder {
    // map of all characters to morse
    private static let AlphaNumToMorse: [String:String] = [
        "A": ".-",
        "B": "-...",
        "C": "-.-.",
        "D": "-..",
        "E": ".",
        "F": "..-.",
        "G": "--.",
        "H": "....",
        "I": "..",
        "J": ".---",
        "K": "-.-",
        "L": ".-..",
        "M": "--",
        "N": "-.",
        "O": "---",
        "P": ".--.",
        "Q": "--.-",
        "R": ".-.",
        "S": "...",
        "T": "-",
        "U": "..-",
        "V": "...-",
        "W": ".--",
        "X": "-..-",
        "Y": "-.--",
        "Z": "--..",
        "a": ".-",
        "b": "-...",
        "c": "-.-.",
        "d": "-..",
        "e": ".",
        "f": "..-.",
        "g": "--.",
        "h": "....",
        "i": "..",
        "j": ".---",
        "k": "-.-",
        "l": ".-..",
        "m": "--",
        "n": "-.",
        "o": "---",
        "p": ".--.",
        "q": "--.-",
        "r": ".-.",
        "s": "...",
        "t": "-",
        "u": "..-",
        "v": "...-",
        "w": ".--",
        "x": "-..-",
        "y": "-.--",
        "z": "--..",
        "1": ".----",
        "2": "..---",
        "3": "...--",
        "4": "....-",
        "5": ".....",
        "6": "-....",
        "7": "--...",
        "8": "---..",
        "9": "----.",
        "0": "-----",
        " ": "/",
        "'": ".----.",
        ".": ".-.-.-",
        ",": "--..--",
        ":": "---...",
        "+": ".-.-.",
        "\"": ".-..-.",
        "!":"-.-.--",
        "?": "..--..",
        "=": "-...-",
        "@": ".--.-."
    ]
    
    // encode string to morse (removing trailing and leading whitespace)
    public static func encode(string: String) -> String {
        var morse: String = ""
        string.trimmingCharacters(in: .whitespacesAndNewlines).forEach { char in
            if char.isASCII {
                morse.append(AlphaNumToMorse[char.description]!)
            }
        }
        return morse
    }
}


extension String {
    // helper function to get single char from string
    func charAt(_ i: Int) -> Character {
     return Array(self)[i]
    }
}
