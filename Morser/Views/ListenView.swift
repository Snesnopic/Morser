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
    @State private var circleAnimationAmount: Double = 1.005

    var body: some View {
        NavigationView {
            VStack {
                Button {
                    if isRecording {
                        stopTranscribing()
                    } else {
                        startTranscribing()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.accentColor.opacity(0.5))
                            .scaleEffect(circleAnimationAmount)
                            .if(isRecording, transform: { view in
                                view
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                            circleAnimationAmount *= 1.2
                                        }
                                    }
                                    .onDisappear {
                                        circleAnimationAmount = 1.0
                                    }
                            })
                            .padding()
                        Circle()
                            .foregroundStyle(Color.accentColor)
                            .padding()
                        VStack {
                            Image(systemName: "mic.fill")
                            if isRecording {
                                Text("**Stop listening**")
                            } else {
                                Text("**Start listening**")
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
