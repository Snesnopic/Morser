//
//  ParentView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI
import CoreData

struct ParentView: View {
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
            #if !os(watchOS)
            SettingsView().tabItem {
                Label(
                    title: { Text("Settings") },
                    icon: { Image(systemName: "gearshape") }
                )
            }
            #endif
        }
    }
}

#Preview {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)]) var sentences: FetchedResults<Sentence>
    @StateObject var dataController = DataController()
    return ParentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
}

#Preview ("Dark mode") {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)]) var sentences: FetchedResults<Sentence>
    @StateObject var dataController = DataController()
    return ParentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .preferredColorScheme(.dark)
}
