//
//  ParentView.swift
//  MorserWatch Watch App
//
//  Created by Giuseppe Francione on 24/05/24.
//

import SwiftUI

struct ParentView: View {
    @State var currentSelection = 1
    var body: some View {
        TabView(selection: $currentSelection) {
            EncodeView().tabItem {
                Label(
                    title: { Text("Encode") },
                    icon: { Image(systemName: "text.badge.plus") }
                ) }
//            QuickTranslateView().tabItem {
//                Label(
//                    title: { Text("Quick Translate") },
//                    icon: { Image(systemName: "list.bullet") }
//                ) }
        }
    }
}

#Preview {
    ParentView()
}
