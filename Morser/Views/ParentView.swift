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
    }
}

#Preview {
    @StateObject var dataController = DataController()
    return ParentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
}

#Preview ("Dark mode") {
    @StateObject var dataController = DataController()
    return ParentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .preferredColorScheme(.dark)
}
