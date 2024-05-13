//
//  EncodeView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI

struct EncodeView: View {
    @State private var enteredText:String = ""
    @FocusState private var textFieldIsFocused:Bool
    @State private var circleAnimationAmount:Double = 1.005
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    fileprivate func tryReading() {
        textFieldIsFocused = false
        if !vibrationEngine.isVibrating() {
            vibrationEngine.createEngine()
            vibrationEngine.readMorseCode(morseCode: MorseEncoder.encode(string: enteredText))
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField("Sentence to encode", text: $enteredText, axis: .vertical)
                    .focused($textFieldIsFocused)
                    .onSubmit {
                        tryReading()
                    }
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .padding(.horizontal)
                if enteredText.isEmpty {
                    Text("Morse code will be here!")
                        .bold()
                }
                else {
                    if !vibrationEngine.isVibrating() {
                        Text(MorseEncoder.encode(string: enteredText))
                            .font(.title3)
                            .bold()
                            .padding()
                    }
                    else {
                        HStack {
                            Text(vibrationEngine.morseCodeString.prefix(vibrationEngine.morseCodeIndex - 1)) +
                            Text(String(vibrationEngine.morseCodeString.charAt(vibrationEngine.morseCodeIndex - 1)))
                                .font(.largeTitle) +
                            Text(vibrationEngine.morseCodeString.dropFirst(vibrationEngine.morseCodeIndex))
                        }
                        .bold()
                        .padding()
                        .font(.title3)
                    }
                }
                
                Spacer()
                
                Button {
                    tryReading()
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
                        Text("Play haptics")
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
}

#Preview {
    EncodeView()
}

#Preview ("Dark mode") {
    EncodeView()
        .preferredColorScheme(.dark)
}
