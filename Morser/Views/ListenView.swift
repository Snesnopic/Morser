//
//  ListenView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI

struct ListenView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var isRecording: Bool = false
    @ObservedObject var vibrationEngine = VibrationEngine.shared
    var body: some View {
        CompatibilityNavigation {
            VStack {
                Button {
                    if isRecording {
                        stopTranscribing()
                        if !vibrationEngine.isVibrating() {
                            vibrationEngine.createEngine()
                            vibrationEngine.readMorseCode(morseCode: speechRecognizer.transcript.morseCode())
                        }
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
                            .padding()
                        Circle()
                            .foregroundStyle(Color.accentColor)
                            .padding()
                        VStack {
                            Image(systemName: "mic.fill")
                            if isRecording {
                                Text("Stop listening")
                                    .bold()
                            } else {
                                Text("Start listening")
                                    .bold()
                            }
                        }
                        .font(.title)
                        .foregroundStyle(.white)
                    }
                }
                .padding(.all, 50)
                .buttonStyle(.plain)
                Text(speechRecognizer.transcript.isEmpty ? "Transcript will be here!"
                     : "\(speechRecognizer.transcript)")
                .bold()
                .if(!speechRecognizer.transcript.isEmpty, transform: { view in
                    view.textSelection(.enabled)
                })
                .font(.title2)
            }
            .navigationTitle("Listen")
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
    ListenView()
}

#Preview ("Dark mode") {
    ListenView()
        .preferredColorScheme(.dark)
}
