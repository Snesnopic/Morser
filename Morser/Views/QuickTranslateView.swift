//
//  QuickTranslateView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI
import SwiftData

struct QuickTranslateView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)]) private var sentences: FetchedResults<Sentence>
    @Environment(\.managedObjectContext) var moc
    @State private var mode: EditMode = .inactive
    @FocusState private var textFieldIsFocused: Bool
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    var body: some View {
        NavigationView {
            List {
                ForEach(sentences.toArray().sorted(by: { sent1, sent2 in
                    return sent1.order < sent2.order
                })) { sentence in
                    TextField("Insert a frequently used sentence", text: Binding(get: {
                        sentence.sentence!
                    }, set: { newValue in
                        sentence.sentence! = newValue
                    }))
                    .if(!mode.isEditing && sentence.order != -1, transform: { view in
                        view
                            .disabled(true)
                            .overlay {
                                Color.white.opacity(0.0001)
                                    .onTapGesture {
                                        if !vibrationEngine.isVibrating() {
                                            vibrationEngine.createEngine()
                                            vibrationEngine.readMorseCode(morseCode: sentence.sentence!.morseCode())
                                        } else {
                                            vibrationEngine.stopReading()
                                        }
                                    }
                            }
                    })
                    .focused($textFieldIsFocused)
                    .onSubmit {
                        textFieldIsFocused = false
                        let tempItems = sentences.toArray()
                        tempItems.indices.forEach({ index in
                            sentences.filter({
                                $0.sentence! == tempItems[index].sentence!
                            }).first!.order = Int32(index)
                            sentences.filter({ $0.sentence == tempItems[index].sentence}).first!.order = Int32(index)
                        })
                        do {
                            try moc.save()
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                    .if(vibrationEngine.isVibrating() && vibrationEngine.morseCodeString == sentence.sentence!.morseCode()) { view in
                        view.listRowBackground(Color.accentColor)
                    }
                    .if((vibrationEngine.isVibrating() && vibrationEngine.morseCodeString != sentence.sentence!.morseCode()) || vibrationEngine.isListening) { view in
                        view
                            .disabled(true)
                            .foregroundStyle(Color.gray)
                    }
                }
                .if(!vibrationEngine.isVibrating(), transform: { view in
                    view
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                moc.delete(sentences[index])
                            }
                            do {
                                try moc.save()
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                        .onMove(perform: { source, destination in
                            var tempItems = sentences.toArray()
                            tempItems.move(fromOffsets: source, toOffset: destination)
                            tempItems.indices.forEach({ index in
                                sentences.filter({ $0.sentence! == tempItems[index].sentence!}).first!.order = Int32(index)
                            })
                            do {
                                try moc.save()
                            } catch {
                                print("Error: \(error)")
                            }
                        })
                })
            }
            .listStyle(.plain)
            .navigationTitle("Quick Translate")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                    .disabled(vibrationEngine.isListening || vibrationEngine.isVibrating())             
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let newSentence = Sentence(context: moc)
                        newSentence.order = -1
                        newSentence.sentence = ""
                        textFieldIsFocused = true
                    }
                label: {
                    Image(systemName: "plus")
                }
                .disabled(vibrationEngine.isListening || vibrationEngine.isVibrating())
                }
            }
            .onAppear {
                ensureSentencesExist(sentences, moc)
            }
            .environment(\.editMode, $mode)
        }
    }
}
#Preview {
    @StateObject var dataController = DataController()
    return QuickTranslateView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
}

#Preview ("Dark mode") {
    @StateObject var dataController = DataController()
    return QuickTranslateView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .preferredColorScheme(.dark)
}
