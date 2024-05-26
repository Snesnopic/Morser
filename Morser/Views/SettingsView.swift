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
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Sound Haptics", isOn: $soundEnabled)
                        .disabled(vibrationEngine.isListening || vibrationEngine.isVibrating())
                    if soundEnabled {
                        HStack {
                            Text("Sound Pitch")
                            Spacer()
                            Text("\(Int(soundFrequency))")
                        }
                        Slider(value: $soundFrequency, in: 300...800) {
                            Text("Sound Pitch (\(soundFrequency))")
                        } onEditingChanged: { bool in
                            if !bool {
                                WatchConnectivityProvider.sendSettingsToWatch()
                            }
                        }
                        .disabled(vibrationEngine.isListening || vibrationEngine.isVibrating())
                    }
                } header: {
                    Text("Sound")
                }
            footer: {
                if soundEnabled {
                    Text("A \(Int(soundFrequency))Hz sound will be played alongside haptics to help recognition.")
                } else {
                    Text("No sound will be played alongside haptics.")
                }
            }
                Section {
                    HStack {
                        Text("Haptics Time Unit")
                        Spacer()
                        Text("\(sliderPreference * 100, specifier: "%.0f") ms")
                    }
                    Slider(value: $sliderPreference, in: (0.5)...(5.0)) {
                        Text("Haptics Speed (\(sliderPreference))")
                    } onEditingChanged: { bool in
                        if !bool {
                            WatchConnectivityProvider.sendSettingsToWatch()
                        }
                    }
                    .disabled(vibrationEngine.isListening || vibrationEngine.isVibrating())
                    .onChange(of: sliderPreference, perform: { _ in
                        VibrationEngine.shared.updateTimings()
                    })

                } header: {
                    Text("Timings")
                }
            footer: {
                Text("""
                        Time unit is espressed in ms (milliseconds).
                        Timings:
                        . = 1 time unit (\(sliderPreference * 100, specifier: "%.0f") ms)
                        - = 3 time units (\(sliderPreference * 100 * 3, specifier: "%.0f") ms)
                        Space between same symbols = 1 time unit (\(sliderPreference * 100, specifier: "%.0f") ms)
                        Space between different symbols = 3 time units (\(sliderPreference * 100 * 3, specifier: "%.0f") ms)
                        Space between words = 7 time units (\(sliderPreference * 100 * 7, specifier: "%.0f") ms)
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

#Preview ("Dark mode") {
    SettingsView()
        .preferredColorScheme(.dark)
}
