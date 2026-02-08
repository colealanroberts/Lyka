//
//  LykaBadge.swift
//  Lyka
//
//  Created by Cole Roberts on 2/6/26.
//

import SwiftUI

public struct LykaBadge: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    /// The current value - i.e. `42`.
    private let value: Binding<String>

    private let variant : Variant

    // MARK: - Init

    public init(
        _ value: Binding<String>,
        variant: Variant
    ) {
        self.value = value
        self.variant = variant
    }

    public init(
        _ value: String,
        variant: Variant
    ) {
        self.value = .constant(value)
        self.variant = variant
    }

    // MARK: - UI

    public var body: some View {
        let style = variant.materialized(stylesheet: stylesheet)

        Text(value.wrappedValue)
            .padding(
                .horizontal,
                stylesheet.spacing.medium
            )
            .padding(
                .vertical,
                stylesheet.spacing.xxs
            )
            .font(
                .system(
                    size: stylesheet.typography.body
                )
            )
            .fontWeight(
                .semibold
            )
            .foregroundStyle(
                style.foregroundColor
            )
            .background(
                Capsule()
                    .fill(style.backgroundColor)
            )
    }
}

// MARK: - LykaBadge+Variant

extension LykaBadge {
    public enum Variant {
        case `default`
        case success
        case warning
        case critical

        /// Constructs a concrete `LykaBadge.Style` from the abstract type (`Self`).
        func materialized(
            stylesheet: LykaStylesheet
        ) -> LykaBadge.Style {
            switch self {
            case .default:
                .init(
                    foregroundColor: .white,
                    backgroundColor: stylesheet.colors.surfaceDark
                )
            case .success:
                .init(
                    foregroundColor: .white,
                    backgroundColor: stylesheet.colors.success
                )
            case .critical:
                .init(
                    foregroundColor: .white,
                    backgroundColor: stylesheet.colors.fail
                )
            case .warning:
                .init(
                    foregroundColor: .white,
                    backgroundColor: stylesheet.colors.warning
                )
            }
        }
    }
}

// MARK: LykaBadge+Style

extension LykaBadge {
    struct Style {
        /// The foreground (text) color of the banner.
        let foregroundColor: Color

        /// The background (fill) color.
        let backgroundColor: Color

        // MARK: - Utility

        static func `default`(
            stylesheet: LykaStylesheet
        ) -> Self {
            .init(
                foregroundColor: .white,
                backgroundColor: stylesheet.colors.surfaceDark
            )
        }

        static func critical(
            stylesheet: LykaStylesheet
        ) -> Self {
            .init(
                foregroundColor: .white,
                backgroundColor: stylesheet.colors.fail
            )
        }
    }
}
