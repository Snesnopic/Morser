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
                
                Button {
                    if !VibrationEngine.shared.isVibrating() {
                        VibrationEngine.shared.createEngine()
                        VibrationEngine.shared.readMorseCode(morseCode: MorseEncoder.encode(string: enteredText))
                    }
                } label: {
                    Text("Play haptics")
                }
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
