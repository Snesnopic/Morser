//
//  ParentView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI
import SwiftData

struct ParentView: View {
    @Query private var sentences: [Sentence]
    @Environment(\.modelContext) private var modelContext: ModelContext
    var body: some View {
        TabView {
            EncodeView().tabItem{
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
        }
        .onAppear {
            if sentences.isEmpty {
                [
                    Sentence(sentence: String(localized: "Yes, I can guide you."), order: 0),
                    Sentence(sentence: String(localized: "I'm here to help."), order: 1),
                    Sentence(sentence: String(localized: "I understand, let me assist you."), order: 2),
                    Sentence(sentence: String(localized: "I'll write it down for you."), order: 3),
                    Sentence(sentence: String(localized: "I'll describe the menu options for you."), order: 4),
                    Sentence(sentence: String(localized: "I'll help you navigate through touch."), order: 5),
                    Sentence(sentence: String(localized: "I'm communicating with you through touch."), order: 6),
                    Sentence(sentence: String(localized: "I'll lead you to the bus stop."), order: 7),
                    Sentence(sentence: String(localized: "Let me describe the location to you."), order: 8),
                    Sentence(sentence: String(localized: "I'll tap your hand to get your attention."), order: 9)
                ].forEach { sentence in
                    modelContext.insert(sentence)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Sentence.self, configurations: config)
    
    return ParentView().modelContainer(container)
}
