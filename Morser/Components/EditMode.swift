//
//  EditMode.swift
//  Morser
//
//  Created by Giuseppe Francione on 22/06/24.
//

// Documentation comments are copied from the official documentation for iOS.

import SwiftUI

#if !os(iOS)
/// Reimplemenation of [EditMode](https://developer.apple.com/documentation/swiftui/editmode) for macOS.
public enum EditMode {

  /// The user can edit the view content.
  case active

  /// The user can’t edit the view content.
  case inactive

  /// The view is in a temporary edit mode.
  case transient
}

extension EditMode: Equatable {}
extension EditMode: Hashable {}

extension EditMode {

  /// Indicates whether a view is being edited.
  ///
  /// This property returns `true` if the mode is something other than inactive.
  public var isEditing: Bool {
    self != .inactive
  }
}

private struct EditModeEnvironmentKey: EnvironmentKey {
  static var defaultValue: Binding<EditMode>?
}

extension EnvironmentValues {

  /// An indication of whether the user can edit the contents of a view associated with this environment.
  public var editMode: Binding<EditMode>? {
    get {
      self[EditModeEnvironmentKey.self]
    }
    set {
      self[EditModeEnvironmentKey.self] = newValue
    }
  }
}
extension Optional where Wrapped == Binding<EditMode> {

  /// Convenience property so call sites can use a clean `editMode.isEditing` instead of the
  /// ugly boilerplate `editMode?.wrappedValue.isEditing == true`.
  public var isEditing: Bool {
    self?.wrappedValue.isEditing == true
  }
}
extension EditMode {

  /// Toggles the edit mode between `.inactive` and `.active`.
  public mutating func toggle() {
    switch self {
    case .inactive: self = .active
    case .active: self = .inactive
    case .transient: break
#if os(iOS)
    @unknown default: break
#endif
    }
  }
}
#endif
