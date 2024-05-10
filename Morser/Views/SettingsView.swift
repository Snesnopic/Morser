//
//  SettingsView.swift
//  Morser
//
//  Created by Giuseppe Francione on 09/05/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("sliderPreference") private var sliderPreference = 5.0
       var body: some View {
           Form {
               Toggle("Sound Haptics", isOn: $soundEnabled)
               HStack {
                   Text("Haptics Time Unit")
                   Spacer()
                   Text("\(Int(sliderPreference))")
               }
               Slider(value: $sliderPreference, in: 1...5) {
                   Text("Haptics Speed (\(sliderPreference))")
               }
           }
           .padding(20)
       }
}

#Preview {
    SettingsView()
}
