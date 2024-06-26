//
//  EncodeView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI

struct EncodeView: View {
    @ObservedObject var torchEngine = TorchEngine.shared
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var isRecording: Bool = false
    @State private var enteredText: String = ""
    @FocusState private var textFieldIsFocused: Bool
    @State private var circleAnimationAmount: Double = 1.005
    @State private var circles: [UUID] = []
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    @AppStorage("softwareFlashlight") private var softwareFlashlight = false
    @State var size: CGSize = .zero
    fileprivate func tryReading() {
        textFieldIsFocused = false
        if !vibrationEngine.isVibrating() {
            vibrationEngine.createEngine()
            vibrationEngine.readMorseCode(morseCode: enteredText.morseCode())
        }
    }
    var body: some View {
        CompatibilityNavigation {
            VStack {
                Spacer()
                HStack {
                    TextField("Sentence to encode", text: (isRecording ? $speechRecognizer.transcript : ($enteredText)))
                        .disabled(isRecording || vibrationEngine.isVibrating())
                        .focused($textFieldIsFocused)
                        .saveSize(in: $size)
                        .onSubmit {
                            tryReading()
                        }
                    #if !os(macOS)
                        .textInputAutocapitalization(.never)
                    #endif
                    #if !os(tvOS)
                        .textFieldStyle(.roundedBorder)
                    #endif
                        .disableAutocorrection(true)
                        .padding(.leading)
                        .frame(height: size.height * 2)
                    #if !os(tvOS)
                    Button {
                        if isRecording {
                            stopTranscribing()
                            enteredText = speechRecognizer.transcript
                            speechRecognizer.transcript = ""
                            vibrationEngine.isListening = false
                        } else {
                            textFieldIsFocused = false
                            startTranscribing()
                            enteredText = ""
                            vibrationEngine.isListening = true
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
                    .disabled(vibrationEngine.isVibrating() || !speechRecognizer.errorMessage.isEmpty)
                    .frame(width: size.height, height: size.height)
                    .padding(.trailing, 10)
                    .buttonStyle(.plain)
                    #endif
                }
                if enteredText.isEmpty && speechRecognizer.transcript.isEmpty && (enteredText.morseCode().isEmpty && speechRecognizer.transcript.morseCode().isEmpty) && vibrationEngine.morseCodeString.isEmpty {
                    Text("Morse code will be here!")
                        .bold()
                        .padding()
                        .font(.title3)
                        .accessibilityHidden(true)
                } else {
                    if !vibrationEngine.isVibrating() {
                        Text((isRecording ? speechRecognizer.transcript.morseCode() : enteredText.morseCode()))
                            .font(.title3)
                            .bold()
                            .padding()
                            #if !os(tvOS)
                            .textSelection(.enabled)
                            .onTapGesture {
                                textFieldIsFocused = false
                            }
                            #endif
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
//                if !vibrationEngine.supportsHaptics {
//                    HStack {
//                        Image(systemName: "exclamationmark.circle.fill")
//                        Text("Your device does not support haptics!\nOnly sound will be played.")
//                            .bold()
//                    }
//                    .foregroundStyle(.orange)
//                    Spacer()
//                }
                if !speechRecognizer.errorMessage.isEmpty {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text("Voice recognition not available!")
                            .bold()
                    }
                    .foregroundStyle(.orange)
                }
                Spacer()
                #if !os(tvOS)
                    .onTapGesture {
                        textFieldIsFocused = false
                    }
                #endif
                Button {
                    if !vibrationEngine.isVibrating() {
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
                            if newValue != 0 && String(vibrationEngine.morseCodeString.charAt(vibrationEngine.morseCodeIndex - 1)) != "/" {
                                let newCircle = UUID()
                                circles.append(newCircle)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    circles.removeAll { $0 == newCircle }
                                }
                            }
                        }
                        #if os(iOS)
                        if UIDevice.current.userInterfaceIdiom == .phone {
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
                        }
                        #endif
                        Circle()
                            .foregroundStyle(!vibrationEngine.isVibrating() ? Color.accentColor : Color.red)
                            .padding()
                        Text(!vibrationEngine.isVibrating() ? "Play haptics" : "Stop haptics")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
                .disabled(isRecording)
                .padding(.all, 50)
                .buttonStyle(.plain)
                Spacer()
            }
            .overlay {
                Color.white
                    .ignoresSafeArea()
                    .opacity(torchEngine.torchIsOn && softwareFlashlight ? 1 : 0)
                    .if(!torchEngine.torchIsOn) { view in
                        view
                            .animation(.easeOut(duration: vibrationEngine.dotDuration), value: torchEngine.torchIsOn)
                    }
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
    TabView {
        EncodeView()
    }
}

#Preview ("Dark mode") {
    EncodeView()
        .preferredColorScheme(.dark)
}
