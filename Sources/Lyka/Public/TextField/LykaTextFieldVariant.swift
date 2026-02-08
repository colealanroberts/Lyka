//
//  LykaTextFieldVariant.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import Foundation
import SwiftUI

// MARK: - LykaTextFieldVariant

public enum LykaTextFieldVariant {
    /// The primary variant.
    case primary

    /// Constructs a concrete `LykaTextFieldStyle` from the abstract type (`Self`).
    func materialized(stylesheet: LykaStylesheet) -> LykaTextFieldStyle {
        .primary(stylesheet: stylesheet)
    }
}
