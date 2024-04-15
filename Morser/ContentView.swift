//
//  ContentView.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            EncodeView().tabItem{
                Label(
                    title: { Text("Encode") },
                    icon: { Image(systemName: "42.circle") }
                ) }
            QuickTranslateView().tabItem {
                Label(
                    title: { Text("Quick Translate") },
                    icon: { Image(systemName: "42.circle") }
                ) }
            ListenView().tabItem {
                Label(
                    title: { Text("Listen") },
                    icon: { Image(systemName: "42.circle") }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
