//
//  ExpandingCircle.swift
//  Morser
//
//  Created by Giuseppe Francione on 24/05/24.
//

import SwiftUI

struct ExpandingCircle: View {
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 1.0
    var duration: TimeInterval = 0.3
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    var body: some View {
        Circle()
            .fill(vibrationEngine.isVibrating() ? Color.red : .blue)
            .padding()
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.easeOut(duration: duration)) {
                    self.scale = 2.0
                    self.opacity = 0.0
                }
            }
    }
}

#Preview {
    ExpandingCircle()
}

#Preview("Dark mode") {
    ExpandingCircle()
        .preferredColorScheme(.dark)
}
