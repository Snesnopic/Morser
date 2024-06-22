//
//  CompatibilityNavigation.swift
//  Morser
//
//  Created by Giuseppe Francione on 22/06/24.
//

import SwiftUI

struct CompatibilityNavigation<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        if #available(iOS 16, macOS 13, *) {
            NavigationStack(root: content)
        } else {
            NavigationView(content: content)
        }
    }
}
