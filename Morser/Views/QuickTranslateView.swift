//
//  QuickTranslateView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI
import SwiftData

struct QuickTranslateView: View {
    @State var temporaryString: String = ""
    @State var orderBeingChanged: Int32 = -2
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)]) private var sentences: FetchedResults<Sentence>
    @Environment(\.managedObjectContext) var moc
    @State private var mode:EditMode = .inactive
    @FocusState private var textFieldIsFocused:Bool
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    
    private func vibrate(_ sentence:Sentence) {
        if !vibrationEngine.isVibrating() {
            vibrationEngine.createEngine()
            vibrationEngine.readMorseCode(sentence: sentence)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sentences.toArray().sorted(by: { sent1, sent2 in
                    return sent1.order < sent2.order
                })) { sentence in
                    TextField("Insert a frequently used sentence",text:
                                orderBeingChanged != sentence.order ? sentence.bindingWrapper!.boundSentence : $temporaryString, onEditingChanged: { (changed) in
                        if changed {
                            temporaryString = sentence.bindingWrapper!.boundSentence.wrappedValue
                            orderBeingChanged = sentence.order
                        } else {
                            sentence.bindingWrapper = BindingWrapper(temporaryString)
                            temporaryString = ""
                            orderBeingChanged = -2
                        }
                    })
                    .if(!mode.isEditing && sentence.order != -1, transform: { view in
                        view
                            .disabled(true)
                            .overlay {
                                Color.white.opacity(0.0001)
                                    .onTapGesture {
                                        vibrate(sentence)
                                    }
                            }
                    })
                    .focused($textFieldIsFocused)
                    .onSubmit {
                        sentence.sentence = sentence.bindingWrapper!.boundSentence.wrappedValue
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
                        }
                        catch {
                            print("Error: \(error)")
                        }                    }
                    .if(vibrationEngine.isVibrating() && vibrationEngine.morseCodeString == MorseEncoder.encode(string: sentence.sentence!)) { view in
                        view.listRowBackground(Color.accentColor)
                    }
                    .if(vibrationEngine.isVibrating() && vibrationEngine.morseCodeString != MorseEncoder.encode(string: sentence.sentence!)) { view in
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
                            }
                            catch {
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
                            }
                            catch {
                                print("Error: \(error)")
                            }
                        })
                })
                
                
            }
            .listStyle(.plain)
            .navigationTitle("Quick Translate")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .disabled(vibrationEngine.isVibrating())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let newSentence = Sentence(entity: Sentence.entity(), insertInto: moc)
                        newSentence.order = -1
                        newSentence.sentence = ""
                        newSentence.bindingWrapper = BindingWrapper()
                        textFieldIsFocused = true
                    }
                label: {
                    Image(systemName: "plus")
                }
                .disabled(vibrationEngine.isVibrating())
                    
                }
                
            }
            .environment(\.editMode, $mode)
        }
    }
}
//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Sentence.self, configurations: config)
//    [
//        Sentence(sentence: "Yes, I can guide you.", order: 0),
//        Sentence(sentence: "I'm here to help.", order: 1),
//        Sentence(sentence: "I understand, let me assist you.", order: 2),
//        Sentence(sentence: "I'll write it down for you.", order: 3),
//        Sentence(sentence: "I'll describe the menu options for you.", order: 4),
//        Sentence(sentence: "I'll help you navigate through touch.", order: 5),
//        Sentence(sentence: "I'm communicating with you through touch.", order: 6),
//        Sentence(sentence: "I'll lead you to the bus stop.", order: 7),
//        Sentence(sentence: "Let me describe the location to you.", order: 8),
//        Sentence(sentence: "I'll tap your hand to get your attention.", order: 9)
//    ].forEach { sentence in
//        container.mainContext.insert(sentence)
//    }
//
//    return QuickTranslateView().modelContainer(container)
//}
//
//#Preview ("Dark mode") {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Sentence.self, configurations: config)
//    [
//        Sentence(sentence: "Yes, I can guide you.", order: 0),
//        Sentence(sentence: "I'm here to help.", order: 1),
//        Sentence(sentence: "I understand, let me assist you.", order: 2),
//        Sentence(sentence: "I'll write it down for you.", order: 3),
//        Sentence(sentence: "I'll describe the menu options for you.", order: 4),
//        Sentence(sentence: "I'll help you navigate through touch.", order: 5),
//        Sentence(sentence: "I'm communicating with you through touch.", order: 6),
//        Sentence(sentence: "I'll lead you to the bus stop.", order: 7),
//        Sentence(sentence: "Let me describe the location to you.", order: 8),
//        Sentence(sentence: "I'll tap your hand to get your attention.", order: 9)
//    ].forEach { sentence in
//        container.mainContext.insert(sentence)
//    }
//
//    return QuickTranslateView()
//        .modelContainer(container)
//        .preferredColorScheme(.dark)
//}
