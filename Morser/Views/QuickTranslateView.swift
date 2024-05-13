//
//  QuickTranslateView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI
import SwiftData

struct QuickTranslateView: View {
    @Query(sort: \Sentence.order) private var sentences: [Sentence]
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State private var mode:EditMode = .inactive
    @FocusState private var textFieldIsFocused:Bool
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    var body: some View {
        NavigationStack {
            List {
                ForEach(sentences) { sentence in
                    TextField("Insert a frequently used sentence",text: sentence.boundSentence)
                        .if(!mode.isEditing && sentence.order != -1, transform: { view in
                            view
                                .disabled(true)
                                .overlay {
                                    Color.white.opacity(0.0001)
                                        .onTapGesture {
                                            if !vibrationEngine.isVibrating() {
                                                vibrationEngine.createEngine()
                                                vibrationEngine.readMorseCode(morseCode: sentence.morseCode)
                                            }
                                        }
                                }
                            
                        })
                        .focused($textFieldIsFocused)
                        .onSubmit {
                            textFieldIsFocused = false
                            let tempItems = sentences
                            tempItems.indices.forEach({ index in
                                sentences.filter({ $0.sentence == tempItems[index].sentence}).first!.order = index
                            })
                            do {
                                try modelContext.save()
                            } catch {
                                print(error)
                            }
                        }
                        .if(vibrationEngine.morseCodeString == sentence.morseCode) { view in
                            view.listRowBackground(Color.accentColor)
                        }
                    
                }
                
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        modelContext.delete(sentences[index])
                    }
                }
                .onMove(perform: { source, destination in
                    var tempItems = sentences
                    tempItems.move(fromOffsets: source, toOffset: destination)
                    
                    tempItems.indices.forEach({ index in
                        sentences.filter({ $0.sentence == tempItems[index].sentence}).first!.order = index
                    })
                    do {
                        try modelContext.save()
                    }
                    catch {
                        print(error)
                    }
                })
                
            }
            .listStyle(.plain)
            .navigationTitle("Quick Translate")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        modelContext.insert(Sentence(sentence: "", order: -1))
                        textFieldIsFocused = true
                    }
                label: {
                    Image(systemName: "plus")
                }
                }
                
            }
            .environment(\.editMode, $mode)
        }
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Sentence.self, configurations: config)
    [
        Sentence(sentence: "Yes, I can guide you.", order: 0),
        Sentence(sentence: "I'm here to help.", order: 1),
        Sentence(sentence: "I understand, let me assist you.", order: 2),
        Sentence(sentence: "I'll write it down for you.", order: 3),
        Sentence(sentence: "I'll describe the menu options for you.", order: 4),
        Sentence(sentence: "I'll help you navigate through touch.", order: 5),
        Sentence(sentence: "I'm communicating with you through touch.", order: 6),
        Sentence(sentence: "I'll lead you to the bus stop.", order: 7),
        Sentence(sentence: "Let me describe the location to you.", order: 8),
        Sentence(sentence: "I'll tap your hand to get your attention.", order: 9)
    ].forEach { sentence in
        container.mainContext.insert(sentence)
    }
    
    return QuickTranslateView().modelContainer(container)
}

#Preview ("Dark mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Sentence.self, configurations: config)
    [
        Sentence(sentence: "Yes, I can guide you.", order: 0),
        Sentence(sentence: "I'm here to help.", order: 1),
        Sentence(sentence: "I understand, let me assist you.", order: 2),
        Sentence(sentence: "I'll write it down for you.", order: 3),
        Sentence(sentence: "I'll describe the menu options for you.", order: 4),
        Sentence(sentence: "I'll help you navigate through touch.", order: 5),
        Sentence(sentence: "I'm communicating with you through touch.", order: 6),
        Sentence(sentence: "I'll lead you to the bus stop.", order: 7),
        Sentence(sentence: "Let me describe the location to you.", order: 8),
        Sentence(sentence: "I'll tap your hand to get your attention.", order: 9)
    ].forEach { sentence in
        container.mainContext.insert(sentence)
    }
    
    return QuickTranslateView()
        .modelContainer(container)
        .preferredColorScheme(.dark)
}
