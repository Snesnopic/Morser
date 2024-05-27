//
//  IntentHandler.swift
//  Morser
//
//  Created by Giuseppe Francione on 27/05/24.
//

import Foundation
import Intents

class EncodeMorseIntentHandler: NSObject, EncodeMorseIntentHandling {
    func resolveSentence(for intent: EncodeMorseIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let inputText = intent.sentence else {
            completion(INStringResolutionResult.success(with: "Invalid input"))
            return
        }

        // Trigger vibration (assuming you have this function)
        VibrationEngine.shared.createEngine()
        VibrationEngine.shared.readMorseCode(morseCode: inputText.morseCode())

        // Respond with a success message
        let response = INStringResolutionResult.success(with: "Vibrating...")
        completion(response)
    }

//    func handle(intent: EncodeMorseIntent, completion: @escaping (EncodeMorseIntentResponse) -> Void) {
//        guard let inputText = intent.inputText else {
//            completion(EncodeMorseIntentResponse.failure(error: "Invalid input"))
//            return
//        }
//        
//        // Encode the inputText to Morse code
//        let morseCode = encodeToMorse(inputText)
//        
//        // Trigger vibration (assuming you have this function)
//        vibrateMorse(morseCode)
//        
//        // Respond with a success message
//        let response = EncodeMorseIntentResponse.success(result: morseCode)
//        completion(response)
//    }
//    
    func encodeToMorse(_ text: String) -> String {
        // Use your existing Morse code encoding logic here
        return "..." // Example placeholder
    }

    func vibrateMorse(_ morseCode: String) {
        // Use your existing vibration logic here
    }
 }
