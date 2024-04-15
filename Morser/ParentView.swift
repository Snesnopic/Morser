//
//  ParentView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI

struct ParentView: View {
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
    }
}

#Preview {
    ParentView()
}
