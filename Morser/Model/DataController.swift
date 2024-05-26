//
//  DataController.swift
//  Morser
//
//  Created by Giuseppe Francione on 16/05/24.
//

import Foundation
import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Sentence")
    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

func ensureSentencesExist(_ sentences: FetchedResults<Sentence>, _ mocModelContext: NSManagedObjectContext) {
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
