//
//  BindingWrapper.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import CoreData
import SwiftUI

public class BindingWrapper: NSObject {
    var boundSentence: Binding<String> = .constant("")
    init(_ string: String = "") {
        self.boundSentence = .constant(string)
    }
}
