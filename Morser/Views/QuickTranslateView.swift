//
//  QuickTranslateView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI

struct QuickTranslateView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)]) private var sentences: FetchedResults<Sentence>
    @Environment(\.managedObjectContext) var moc
    @State private var mode: EditMode = .inactive
    @FocusState private var textFieldIsFocused: Bool
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    @ObservedObject private var torchEngine = TorchEngine.shared
    @AppStorage("softwareFlashlight") private var softwareFlashlight = true
    var body: some View {
        CompatibilityNavigation {
            List {
                ForEach(sentences.toArray().sorted(by: { sent1, sent2 in
                    return sent1.order < sent2.order
                })) { sentence in
                    Group {
                        if mode == .active {
                            TextField("Insert a frequently used sentence", text: Binding(get: {
                                sentence.sentence!
                            }, set: { newValue in
                                sentence.sentence! = newValue
                            }))
                            .focused($textFieldIsFocused)
                            .if(!mode.isEditing && sentence.order != -1, transform: { view in
                                view
                                    .disabled(true)
                                    #if !os(tvOS)
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
                                    #endif
                            })
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
#if os(iOS)
                                    WatchConnectivityProvider.sendSentencesToWatch()
#endif
                                } catch {
                                    print("Error: \(error)")
                                }
                            }
                        } else {
                            Button {
                                if !vibrationEngine.isVibrating() {
                                    vibrationEngine.createEngine()
                                    vibrationEngine.readMorseCode(morseCode: sentence.sentence!.morseCode())
                                } else {
                                    vibrationEngine.stopReading()
                                }
                            } label: {
                                Text(sentence.sentence!)
                            }
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
                    if #available(iOS 17.0, macOS 14.0, tvOS 17.0, *) {
                        if sentence.order == 0 {
                            TipView(SaveAndTapTip(), arrowEdge: .top)
                        }
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
#if os(iOS)
                                WatchConnectivityProvider.sendSentencesToWatch()
#endif
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
            .overlay {
                Color.white
                    .ignoresSafeArea()
                    .opacity(torchEngine.torchIsOn && softwareFlashlight ? 1 : 0)
                    .if(!torchEngine.torchIsOn) { view in
                        view
                            .animation(.easeOut(duration: vibrationEngine.dotDuration), value: torchEngine.torchIsOn)
                    }
            }
            .listStyle(.plain)
            .navigationTitle("Quick Translate")
            .toolbar {
#if os(iOS)
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
#else
                ToolbarItem(placement: .automatic) {
                    Button("Edit") {
                        mode.toggle()
                    }
                    .disabled(vibrationEngine.isListening || vibrationEngine.isVibrating())
                }
                ToolbarItem(placement: .automatic) {
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
#endif
            }
            .onAppear {
                ensureSentencesExist(sentences, moc)
#if !DEBUG
                WatchConnectivityProvider.sendSentencesToWatch()
#endif
            }
            .task {
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, *) {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
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

import TipKit

// Define your tip's content.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
struct SaveAndTapTip: Tip {
    var title: Text {
        Text("Save and listen")
    }

    var message: Text? {
        Text("Your saved sentences can be played with just a tap!")
    }

    var image: Image? {
        Image(systemName: "waveform")
    }
}
