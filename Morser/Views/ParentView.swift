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
            EncodeView()
                .tabItem {
                    Label("Encode", systemImage: "text.badge.plus")
                }
            QuickTranslateView()
                .tabItem {
                    Label("Quick Translate", systemImage: "list.bullet")
                }
            #if !os(watchOS)
            #if !os(macOS)
            SettingsView().tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            #endif
            #endif
        }
        #if os(macOS)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if #available(macOS 14.0, *) {
                    SettingsLink()
                }
            }
        }
        #endif
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
