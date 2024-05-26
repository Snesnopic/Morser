//
//  ContentView.swift
//  MorserWatch Watch App
//
//  Created by Giuseppe Francione on 24/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Vibrate iPhone") {
                WatchCommunicationManager.shared.sendVibrationRequest()
            }
            Button("Beep 'SOS'") {
                let dot = BeepPlayer(frequency: 300, duration: 0.1)
                let dash = BeepPlayer(frequency: 300, duration: 0.3)
                dot.playSound()
                usleep(100000)
                dot.playSound()
                usleep(100000)
                dot.playSound()
                usleep(300000)
                dash.playSound()
                usleep(100000)
                dash.playSound()
                usleep(100000)
                dash.playSound()
                usleep(3000000)
                dot.playSound()
                usleep(100000)
                dot.playSound()
                usleep(100000)
                dot.playSound()
            }
        }
    }
}

#Preview {
    ContentView()
}
