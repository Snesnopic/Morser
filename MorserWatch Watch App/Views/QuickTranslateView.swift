//
//  QuickTranslateView.swift
//  MorserWatch Watch App
//
//  Created by Giuseppe Francione on 26/05/24.
//

import SwiftUI

struct QuickTranslateView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)]) private var sentences: FetchedResults<Sentence>
    @Environment(\.managedObjectContext) var moc
    @ObservedObject private var vibrationEngine = VibrationEngine.shared
    var body: some View {
        NavigationView {
            List {
                ForEach(sentences.toArray().sorted(by: { sent1, sent2 in
                    return sent1.order < sent2.order
                })) { sentence in
                    Text(sentence.sentence!)
                        .onTapGesture {
                            if !vibrationEngine.isVibrating() {
                                WatchCommunicationManager.shared.sendVibrationRequest(sentence.sentence!)
                                vibrationEngine.readMorseCode(morseCode: sentence.sentence!.morseCode())
                            } else if vibrationEngine.morseCodeString == sentence.sentence!.morseCode() {
                                    vibrationEngine.stopReading()
                                }
                            }
                        .if(vibrationEngine.isVibrating() && vibrationEngine.morseCodeString == sentence.sentence!.morseCode()) { view in
                            view.listRowBackground(Color.blue)
                        }
                        .if((vibrationEngine.isVibrating() && vibrationEngine.morseCodeString != sentence.sentence!.morseCode())) { view in
                            view
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
            .onAppear {
                ensureSentencesExist(sentences, moc)
            }
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
