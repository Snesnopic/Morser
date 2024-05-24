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
        }
    }
}

#Preview {
    ContentView()
}
