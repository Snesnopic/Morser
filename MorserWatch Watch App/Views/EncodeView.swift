//
//  EncodeView.swift
//  MorserWatch Watch App
//
//  Created by Giuseppe Francione on 26/05/24.
//

import SwiftUI

struct EncodeView: View {
    private var vibrationEngine = VibrationEngine.shared
    var body: some View {
        VStack {
            Button("Vibrate iPhone") {
                WatchCommunicationManager.shared.sendVibrationRequest()
            }
            Button("Beep 'SOS'") {
                vibrationEngine.readMorseCode(morseCode: "sos".morseCode())
            }
        }
    }
}

#Preview {
    EncodeView()
}
