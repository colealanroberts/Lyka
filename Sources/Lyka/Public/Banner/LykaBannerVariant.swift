//
//  LykaBannerVariant.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import SwiftUI

// MARK: - LykaBannerVariant

public enum LykaBannerVariant {
    case `default`
    case success
    case warning
    case critical

    /// Constructs a concrete `LykaBanner.Style` from the abtract type (`Self`).
    func materialized(stylesheet: LykaStylesheet) -> LykaBanner.Style {
        switch self {
        case .default:
            .default(stylesheet: stylesheet)
        case .success:
            .success(stylesheet: stylesheet)
        case .critical:
            .critical(stylesheet: stylesheet)
        case .warning:
            .warning(stylesheet: stylesheet)
        }
    }
}
