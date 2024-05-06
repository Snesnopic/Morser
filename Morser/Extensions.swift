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

extension String {
    func createAhapFile(_ withName: String = "temp") -> URL {
      let url = FileManager.default.temporaryDirectory
        .appendingPathComponent(withName)
        .appendingPathExtension("ahap")
      let string = self
      try? string.write(to: url, atomically: true, encoding: .utf8)
      return url
    }
  }
