//
//  ListenView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI

struct ListenView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var isRecording:Bool = false
    @State private var circleAnimationAmount:Double = 1.005
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    if isRecording {
                        stopTranscribing()
                    }
                    else {
                        startTranscribing()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.accentColor.opacity(0.5))
                            .scaleEffect(circleAnimationAmount)
                            .onAppear{
                                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                    circleAnimationAmount *= 1.2
                                }
                            }
                            .onDisappear{
                                circleAnimationAmount = 1.0
                            }
                            .padding()
                        Circle()
                            .foregroundStyle(Color.accentColor)
                            .padding()
                        VStack {
                            Image(systemName: "mic.fill")
                            Text((isRecording ? "Stop" : "Start") + " listening")
                        }
                        .bold()
                        .font(.title)
                        .foregroundStyle(.background)
                    }
                }
                .padding(.all, 50)
                .buttonStyle(.plain)
                Text(speechRecognizer.transcript.isEmpty ? "Transcript will be here!" : "\(speechRecognizer.transcript)")
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
