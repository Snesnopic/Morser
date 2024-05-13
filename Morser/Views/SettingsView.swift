//
//  SettingsView.swift
//  Morser
//
//  Created by Giuseppe Francione on 09/05/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("sliderPreference") private var sliderPreference = 1.0
    @AppStorage("soundFrequency") private var soundFrequency = 600.0
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Sound Haptics", isOn: $soundEnabled)
                    if soundEnabled {
                        HStack {
                            Text("Sound Pitch")
                            Spacer()
                            Text("\(Int(soundFrequency))")
                        }
                        Slider(value: $soundFrequency, in: 300...800) {
                            Text("Sound Pitch (\(soundFrequency))")
                        }
                    }
                } header: {
                    Text("Sound")
                }
            footer: {
                if soundEnabled {
                    Text("A \(Int(soundFrequency))Hz sound will be played alongside haptics to help recognition.")
                }
                else {
                    Text("No sound will be played alongside haptics.")
                }
                
            }
                Section {
                    HStack {
                        Text("Haptics Time Unit")
                        Spacer()
                        Text("\(sliderPreference * 100,specifier: "%.0f") ms")
                    }
                    Slider(value: $sliderPreference, in: (0.1)...(5.0)) {
                        Text("Haptics Speed (\(sliderPreference))")
                    }
                    .onChange(of: sliderPreference) { oldValue, newValue in
                        VibrationEngine.shared.updateTimings()
                    }
                } header: {
                    Text("Timings")
                }
            footer: {
                Text("""
                        Time unit is espressed in ms (milliseconds).
                        Timings:
                        . = 1 time unit (\(sliderPreference * 100,specifier: "%.0f") ms)
                        - = 3 time units (\(sliderPreference * 100 * 3,specifier: "%.0f") ms)
                        Space between same symbols = 1 time unit (\(sliderPreference * 100,specifier: "%.0f") ms)
                        Space between different symbols = 3 time units (\(sliderPreference * 100 * 3,specifier: "%.0f") ms)
                        Space between words = 7 time units (\(sliderPreference * 100 * 7,specifier: "%.0f") ms)
                        """
                )
            }
            }
            .navigationTitle(String(localized: "Settings"))
        }
    }
}

#Preview {
    SettingsView()
}
