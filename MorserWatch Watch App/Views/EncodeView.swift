//
//  EncodeView.swift
//  MorserWatch Watch App
//
//  Created by Giuseppe Francione on 26/05/24.
//

import SwiftUI

struct EncodeView: View {
    private var watchCommsManager = WatchCommunicationManager.shared
    private var vibrationEngine = VibrationEngine.shared
    var body: some View {
        VStack {
            Button("Beep 'SOS'") {
                WatchCommunicationManager.shared.sendVibrationRequest("sos")
                vibrationEngine.readMorseCode(morseCode: "sos".morseCode())
            }
        }
    }
}

#Preview {
    EncodeView()
}
