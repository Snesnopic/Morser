//
//  EncodeView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI

struct EncodeView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var isRecording: Bool = false
    @State private var enteredText: String = ""
    @FocusState private var textFieldIsFocused: Bool
    @State private var circleAnimationAmount: Double = 1.005
    @State private var circles: [UUID] = []
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    @State var size: CGSize = .zero
    fileprivate func tryReading() {
        textFieldIsFocused = false
        if !vibrationEngine.isVibrating() {
            vibrationEngine.createEngine()
            vibrationEngine.readMorseCode(morseCode: enteredText.morseCode())
        }
    }
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    TextField("Sentence to encode", text: $enteredText)
                        .focused($textFieldIsFocused)
                        .saveSize(in: $size)
                        .onSubmit {
                            tryReading()
                        }
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                        .padding(.leading)
                    Button {
                        if isRecording {
                            stopTranscribing()
                            enteredText = speechRecognizer.transcript
                        } else {
                            startTranscribing()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color.accentColor.opacity(0.5))
                                .if(isRecording, transform: { view in
                                    view
                                        .scaleEffect(speechRecognizer.audioLevel)
                                })
                            Circle()
                                .foregroundStyle(Color.accentColor)
                            Image(systemName: "mic" + (isRecording ? ".slash" : "") + ".fill")
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: size.height)
                    .padding(.horizontal, 10)
                    .buttonStyle(.plain)
                }
                if enteredText.isEmpty {
                    Text("Morse code will be here!")
                        .bold()
                        .padding()
                        .font(.title3)
                        .accessibilityHidden(true)
                } else {
                    if !vibrationEngine.isVibrating() {
                        Text(enteredText.morseCode())
                            .font(.title3)
                            .bold()
                            .padding()
                            .textSelection(.enabled)
                            .onTapGesture {
                                textFieldIsFocused = false
                            }
                            .accessibilityHidden(true)
                    } else {
                        HStack {
                            Text(vibrationEngine.morseCodeString.prefix(vibrationEngine.morseCodeIndex - 1)) +
                            Text(String(vibrationEngine.morseCodeString.charAt(vibrationEngine.morseCodeIndex - 1)))
                                .font(.largeTitle) +
                            Text(vibrationEngine.morseCodeString.dropFirst(vibrationEngine.morseCodeIndex))
                        }
                        .accessibilityHidden(true)
                        .padding()
                        .font(.title3)
                    }
                }

                Spacer()
                    .onTapGesture {
                        textFieldIsFocused = false
                    }

                Button {
                    if !vibrationEngine.isVibrating() {
                        print("Size: \(size)")
                        tryReading()
                    } else {
                        vibrationEngine.stopReading()
                    }
                } label: {
                    ZStack {
                        ForEach(circles, id: \.self) { _ in
                            ExpandingCircle()
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
                            .foregroundStyle(!vibrationEngine.isVibrating() ? Color.accentColor.opacity(0.5) : Color.red.opacity(0.5))
                            .scaleEffect(circleAnimationAmount)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                    circleAnimationAmount *= 1.2
                                }
                            }
                            .onDisappear {
                                circleAnimationAmount = 1.0
                            }
                            .padding()
                        Circle()
                            .foregroundStyle(!vibrationEngine.isVibrating() ? Color.accentColor : Color.red)
                            .padding()
                        Text(!vibrationEngine.isVibrating() ? "Play haptics" : "Stop haptics")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.all, 50)
                .buttonStyle(.plain)
                Spacer()
            }
            .navigationTitle("Encode")
            .ignoresSafeArea(.keyboard)
        }

    }
    private func startTranscribing() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    private func stopTranscribing() {
        speechRecognizer.stopTranscribing()
        isRecording = false
    }
}

#Preview {
    EncodeView()
}

#Preview ("Dark mode") {
    EncodeView()
        .preferredColorScheme(.dark)
}
