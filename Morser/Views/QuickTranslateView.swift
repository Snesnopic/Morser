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
    var body: some View {
        NavigationStack {
            List {
                ForEach(sentences, id: \.self) {
                    sentence in
                    Text(sentence.sentence)
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
                        print("Indice di \(sentences.filter({ $0.sentence == tempItems[index].sentence}).first!.sentence) prima: \(sentences.filter({ $0.sentence == tempItems[index].sentence}).first!.order)")
                        sentences.filter({ $0.sentence == tempItems[index].sentence}).first!.order = index
                        print("Indice di \(sentences.filter({ $0.sentence == tempItems[index].sentence}).first!.sentence) dopo: \(sentences.filter({ $0.sentence == tempItems[index].sentence}).first!.order)")
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
                        
                    }
                label: {
                    Image(systemName: "plus")
                }
                }
                
            }
        }
    }
}

#Preview {
    QuickTranslateView()
}
