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

    /// Constructs a concrete `BlueprintTextField.Style` from the abstract tyle (`Self`).
    func materialized<Content: View>(stylesheet: LykaStylesheet) -> LykaTextFieldCore<Content>.Style {
        .primary(stylesheet: stylesheet)
    }
}
