//
//  Extensions.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func `if`<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T: View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
