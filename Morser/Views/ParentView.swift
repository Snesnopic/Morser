//
//  ParentView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI
import CoreData

struct ParentView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)]) private var sentences: FetchedResults<Sentence>
    @Environment(\.managedObjectContext) var mocModelContext
    var body: some View {
        TabView {
            EncodeView().tabItem {
                Label(
                    title: { Text("Encode") },
                    icon: { Image(systemName: "text.badge.plus") }
                ) }
            QuickTranslateView().tabItem {
                Label(
                    title: { Text("Quick Translate") },
                    icon: { Image(systemName: "list.bullet") }
                ) }
            ListenView().tabItem {
                Label(
                    title: { Text("Listen") },
                    icon: { Image(systemName: "waveform") }
                )
            }
            SettingsView().tabItem {
                Label(
                    title: { Text("Settings") },
                    icon: { Image(systemName: "gearshape") }
                )
            }
        }
        .onAppear {
            if sentences.toArray().isEmpty {
                let strings = [
                    String(localized: "I'm here to help."),
                    String(localized: "Yes, I can guide you."),
                    String(localized: "I understand, let me assist you."),
                    String(localized: "I'll write it down for you."),
                    String(localized: "I'll describe the menu options for you."),
                    String(localized: "I'll help you navigate through touch."),
                    String(localized: "I'm communicating with you through touch."),
                    String(localized: "I'll lead you to the bus stop."),
                    String(localized: "Let me describe the location to you."),
                    String(localized: "I'll tap your hand to get your attention.")
                ]
                var array: [Sentence] = []
                var index: Int32 = 0
                strings.forEach { string in
                    let sentence = Sentence(entity: Sentence.entity(), insertInto: mocModelContext)
                    sentence.sentence = string
                    sentence.order = index
                    index += 1
                    array.append(sentence)
                }
            }
        }
    }
}

#Preview {
    //    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    //    let container = try! ModelContainer(for: Sentence.self, configurations: config)
    //
    return ParentView()
    //        .modelContainer(container)
}
