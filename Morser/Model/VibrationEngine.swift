//
//  VibrationEngine.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import Foundation
#if !os(watchOS)
import CoreHaptics
#else
import WatchKit
#endif
import AVFAudio
import SwiftUI

class VibrationEngine: ObservableObject {
    static let shared: VibrationEngine = VibrationEngine()
#if !os(watchOS)
    var dashAhapUrl: URL?
    var dotAhapUrl: URL?
    private init() {
        dashAhapUrl =  """
        {"Version":1,"Pattern":[{"Event":{"Time":0,"EventType":"HapticContinuous","EventDuration":\(dashDuration),"EventParameters":[{"ParameterID":"HapticIntensity","ParameterValue":1.0},{"ParameterID":"HapticSharpness","ParameterValue":0.0}]}}]}
        """.createAhapFile("dash")

        dotAhapUrl =  """
        {"Version":1,"Pattern":[{"Event":{"Time":0,"EventType":"HapticContinuous","EventDuration":\(dotDuration),"EventParameters":[{"ParameterID":"HapticIntensity","ParameterValue":1.0},{"ParameterID":"HapticSharpness","ParameterValue":0.0}]}}]}
        """.createAhapFile("dash")
    }
    // A haptic engine manages the connection to the haptic server.
    var engine: CHHapticEngine?

    // configurable time unit, will be changeable later with settings
#endif
#if os(watchOS)
    private init() {}
#endif
    @AppStorage("flashlight") private var flashlight = false
    @AppStorage("soundEnabled") static private var soundEnabled = true
    @AppStorage("sliderPreference") static private var timeUnit = 1.0
    @AppStorage("soundFrequency") static private var soundFrequency = 600.0
    var dotDuration: TimeInterval = 1 * timeUnit / 10 // Duration for a dot
    var dashDuration: TimeInterval = 3 * timeUnit / 10 // Duration for a dash
    var sameCharacterSeparatorDelay: TimeInterval = 1 * timeUnit / 10 // Delay between same characters
    var characterSeparatorDelay: TimeInterval = 3 * timeUnit / 10 // Delay between different characters
    var wordSeparatorDelay: TimeInterval = 7 * timeUnit / 10 // Delay for word separator
    func updateTimings() {
        dotDuration = 1 * VibrationEngine.timeUnit / 10
        dashDuration = 3 * VibrationEngine.timeUnit / 10
        sameCharacterSeparatorDelay = 1 * VibrationEngine.timeUnit / 10
        characterSeparatorDelay = 3 * VibrationEngine.timeUnit / 10
        wordSeparatorDelay = 7 * VibrationEngine.timeUnit / 10
    }
#if !os(watchOS)
    func updateAHAPs() {
        dashAhapUrl =  """
        {"Version":1,"Pattern":[{"Event":{"Time":0,"EventType":"HapticContinuous","EventDuration":\(dashDuration),"EventParameters":[{"ParameterID":"HapticIntensity","ParameterValue":1.0},{"ParameterID":"HapticSharpness","ParameterValue":0.0}]}}]}
        """.createAhapFile("dash")

        dotAhapUrl =  """
        {"Version":1,"Pattern":[{"Event":{"Time":0,"EventType":"HapticContinuous","EventDuration":\(dotDuration),"EventParameters":[{"ParameterID":"HapticIntensity","ParameterValue":1.0},{"ParameterID":"HapticSharpness","ParameterValue":0.0}]}}]}
        """.createAhapFile("dot")
    }
#endif
    var vibrationTimer: Timer?

    @Published var morseCodeIndex = 0
    @Published var morseCodeString = ""
    // band aid solution
    @Published var isListening = false
    var dotPlayer: BeepPlayer?
    var dashPlayer: BeepPlayer?

    func readMorseCode(morseCode: String) {
        updateTimings()
#if !os(watchOS)
        updateAHAPs()
#endif
        let soundFreq = Float(VibrationEngine.soundFrequency)
        morseCodeIndex = 0
        morseCodeString = morseCode
        if VibrationEngine.soundEnabled && dotPlayer == nil && dashPlayer == nil {
            dotPlayer = BeepPlayer(frequency: soundFreq, duration: dotDuration)
            dashPlayer = BeepPlayer(frequency: soundFreq, duration: dashDuration)
        }
        triggerNextVibration()
    }

    // Function to trigger vibrations based on Morse code
    func triggerNextVibration() {
        guard morseCodeIndex < morseCodeString.count else {
            // End of Morse code string
            stopReading()
            return
        }

        let character = morseCodeString.charAt(morseCodeIndex)
        var nextCharacter: Character {
            if morseCodeIndex + 1 >= morseCodeString.count {
                return character
            } else {
                return morseCodeString.charAt(morseCodeIndex + 1)
            }
        }
        let interCharDelay = (character == nextCharacter ? sameCharacterSeparatorDelay : characterSeparatorDelay)
        morseCodeIndex += 1

        switch character {
        case ".":
            shortVibration()
            if flashlight {
                TorchEngine.shared.toggleTorchFor(dotDuration)
            }
            if VibrationEngine.soundEnabled {
                dotPlayer?.playSound()
            }
            vibrationTimer = Timer.scheduledTimer(withTimeInterval: dotDuration +
                                                  interCharDelay, repeats: false) { _ in
                self.triggerNextVibration()
            }
        case "-":
            longVibration()
            if flashlight {
                TorchEngine.shared.toggleTorchFor(dashDuration)
            }
            if VibrationEngine.soundEnabled {
                dashPlayer?.playSound()
            }
            vibrationTimer = Timer.scheduledTimer(withTimeInterval: dashDuration + interCharDelay, repeats: false) { _ in
                self.triggerNextVibration()
            }
        case "/":
            vibrationTimer = Timer.scheduledTimer(withTimeInterval: wordSeparatorDelay, repeats: false) { _ in
                self.triggerNextVibration()
            }
        default:
            // Ignore unrecognized characters
            break
        }
    }

    // Function to stop reading Morse code
    func stopReading() {
        #if os(watchOS)
        WatchCommunicationManager.shared.sendStopRequest()
        #endif
        morseCodeIndex = 0
        morseCodeString = ""
        vibrationTimer?.invalidate()
        vibrationTimer = nil
        dotPlayer = nil
        dashPlayer = nil
    }
    
    func shortVibration() {
#if !os(watchOS)
            if supportsHaptics {
                playHaptics(url: dotAhapUrl!)
            } else {
                // weakest vibration for older systems
                AudioServicesPlaySystemSound(1520)
            }
            #else
            WKInterfaceDevice.current().play(.start)
            #endif
    }
    
    func longVibration() {
        #if !os(watchOS)
        if supportsHaptics {
            playHaptics(url: dashAhapUrl!)
        } else {
            // strongest vibration for older systems
            AudioServicesPlaySystemSound(1521)
        }
        #else
        WKInterfaceDevice.current().play(.retry)
        #endif
    }
#if !os(watchOS)

    /// - Tag: CreateEngine
    func createEngine() {
        // Create and configure a haptic engine.
        do {
            // Associate the haptic engine with the default audio session
            // to ensure the correct behavior when playing audio-based haptics.
            let audioSession = AVAudioSession.sharedInstance()
            engine = try CHHapticEngine(audioSession: audioSession)
        } catch let error {
            print("Engine Creation Error: \(error)")
        }

        guard let engine = engine else {
            print("Failed to create engine!")
            return
        }

        // The stopped handler alerts you of engine stoppage due to external causes.
        engine.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt")
            case .applicationSuspended:
                print("Application suspended")
            case .idleTimeout:
                print("Idle timeout")
            case .systemError:
                print("System error")
            case .notifyWhenFinished:
                print("Playback finished")
            case .gameControllerDisconnect:
                print("Controller disconnected.")
            case .engineDestroyed:
                print("Engine destroyed.")
            @unknown default:
                print("Unknown error")
            }
        }

        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        engine.resetHandler = {
            // Try restarting the engine.
            print("The engine reset --> Restarting now!")
            do {
                try self.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }
    /// - Tag: PlayAHAP
    func playHaptics(url: URL) {
        do {
            // Start the engine in case it's idle.
            try engine?.start()

            // Tell the engine to play a pattern.
            try engine?.playPattern(from: url)

        } catch { // Engine startup errors
            print("An error occured playing \(url): \(error).")
        }
    }
    lazy var supportsHaptics: Bool = {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        return hapticCapability.supportsHaptics
    }()
#endif

    func isVibrating() -> Bool {
        return vibrationTimer != nil
    }

}
