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
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField(text: $enteredText, prompt: Text("Sentence to encode")) {
                    
                }
                .focused($textFieldIsFocused)
                .onSubmit {
                }
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .padding(.horizontal)
                
                
                Text(enteredText.isEmpty ? "Morse code will be here!" : MorseEncoder.encode(string: enteredText))
                Spacer()
                
                Button(action: {
                    if !VibrationEngine.shared.isVibrating() {
                        VibrationEngine.shared.createEngine()
                        VibrationEngine.shared.readMorseCode(morseCode: MorseEncoder.encode(string: enteredText))
                    }
                }, label: {
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
                            .foregroundStyle(.background)
                    }
                })
                .padding(.all, 50)
                .buttonStyle(.plain)
                .buttonStyle(BorderedProminentButtonStyle())

                
                Spacer()
            }
            .navigationTitle("Encode")
        }
        
    }
}

#Preview {
    EncodeView()
}
