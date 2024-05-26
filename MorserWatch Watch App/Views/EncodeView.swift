//
//  EncodeView.swift
//  MorserWatch Watch App
//
//  Created by Giuseppe Francione on 26/05/24.
//

import SwiftUI

struct EncodeView: View {
    @State private var enteredText: String = ""
    @FocusState private var textFieldIsFocused: Bool
    @State private var circleAnimationAmount: Double = 1.005
    @State private var circles: [UUID] = []
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    fileprivate func tryReading() {
        textFieldIsFocused = false
        if !vibrationEngine.isVibrating() {
            vibrationEngine.readMorseCode(morseCode: enteredText.morseCode())
        }
    }
    var body: some View {
        NavigationView {
            ScrollView {
                    TextField("Sentence to encode", text: $enteredText)
                        .disabled(vibrationEngine.isVibrating())
                        .focused($textFieldIsFocused)
                        .onSubmit {
                            textFieldIsFocused = false
                        }
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)

                if enteredText.isEmpty || enteredText.morseCode().isEmpty {
                    Text("Morse code will be here!")
                        .bold()
                        .padding()
                        .accessibilityHidden(true)
                } else {
                    if !vibrationEngine.isVibrating() {
                        Text(enteredText.morseCode())
                            .bold()
                            .padding()
                            .onTapGesture {
                                textFieldIsFocused = false
                            }
                            .accessibilityHidden(true)
                    } else {
                        HStack {
                            Text(vibrationEngine.morseCodeString.prefix(vibrationEngine.morseCodeIndex - 1)) +
                            Text(String(vibrationEngine.morseCodeString.charAt(vibrationEngine.morseCodeIndex - 1)))
                                .font(.title3) +
                            Text(vibrationEngine.morseCodeString.dropFirst(vibrationEngine.morseCodeIndex))
                        }
                        .accessibilityHidden(true)
                        .padding()
                    }
                }

                Button {
                    if !vibrationEngine.isVibrating() {
                        tryReading()
                    } else {
                        vibrationEngine.stopReading()
                    }
                } label: {
                    ZStack {
                        ForEach(circles, id: \.self) { _ in
                            ExpandingCircle(duration: 0.6)
                        }
                        .onChange(of: vibrationEngine.morseCodeIndex) { newValue in
                            if newValue != 0 {
                                let newCircle = UUID()
                                circles.append(newCircle)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    circles.removeAll { $0 == newCircle }
                                }
                            }
                        }
                        Circle()
                            .foregroundStyle(!vibrationEngine.isVibrating() ? Color.blue.opacity(0.5) : Color.red.opacity(0.5))
                            .scaleEffect(circleAnimationAmount)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                    circleAnimationAmount *= 1.2
                                }
                            }
                            .onDisappear {
                                circleAnimationAmount = 1.0
                            }
                        Circle()
                            .foregroundStyle(!vibrationEngine.isVibrating() ? Color.blue : Color.red)
                        Text(!vibrationEngine.isVibrating() ? "Play" : "Stop")
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                .padding(.all, 30)
                .buttonStyle(.plain)
            }
            .navigationTitle("Encode")
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    EncodeView()
}

#Preview ("Dark mode") {
    EncodeView()
        .preferredColorScheme(.dark)
}
