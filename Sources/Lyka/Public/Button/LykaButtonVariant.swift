//
//  LykaButtonVariant.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import Foundation
import SwiftUI

// MARK: - LykaButtonVariant

public enum LykaButtonVariant {
    /// The primary variant.
    case primary

    /// A link button style.
    case link

    /// Constructs a concrete `LykaButtonCore.Style` from the abstract type (`Self`).
    func materialized<Content: View>(stylesheet: LykaStylesheet) -> LykaButtonCore<Content>.Style {
        switch self {
        case .primary:
            .primary(stylesheet: stylesheet)
        case .link:
            .link(stylesheet: stylesheet)
        }
    }
}
