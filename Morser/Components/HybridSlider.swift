//
//  HybridSlider.swift
//  Morser
//
//  Created by Giuseppe Francione on 23/06/24.
//

import SwiftUI

struct HybridSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double = 1.0
    var label: String
    var body: some View {
        #if os(tvOS)
        HStack {
            Text(label)
            Spacer()
            VStack {
                Button("", systemImage: "chevron.up") {
                    if value <= range.upperBound {
                        value += step
                    }
                }
                Button("", systemImage: "chevron.down") {
                    if value >= range.lowerBound {
                        value -= step
                    }
                }
            }
        }
        #else
        Slider(value: $value, in: range) {
            Text(label)
        } onEditingChanged: { bool in
            #if os(iOS)
            if !bool {
                WatchConnectivityProvider.sendSettingsToWatch()
            }
            #endif
        }
        #endif
    }
}

#Preview {
    HybridSlider(value: .constant(1.0), range: 1.0 ... 3.0, label: "Slider")
}

#Preview ("Dark mode") {
    HybridSlider(value: .constant(1.0), range: 1.0 ... 3.0, label: "Slider")
        .preferredColorScheme(.dark)
}
