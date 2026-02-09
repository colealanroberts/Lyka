//
//  LykaButtonCore.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import Foundation
import SwiftUI

struct LykaButtonCore<Content: View>: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    @Environment(\.isEnabled)
    private var isEnabled

    // MARK: - Private Properties

    /// The action to perform when the button is tapped.
    private let action: () -> Void

    /// The variant to use for styling.
    private let variant: LykaButtonVariant

    /// The backing `LykaButtonConfiguration`.
    private let configuration: LykaButtonConfiguration

    /// The label content builder.
    private let content: Content

    private var isDisabled: Bool {
        !isEnabled || configuration.isDisabled
    }

    init(
        action: @escaping () -> Void,
        variant: LykaButtonVariant,
        configure: (inout LykaButtonConfiguration) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.action = action
        self.variant = variant
        var configuration = LykaButtonConfiguration()
        configure(&configuration)
        self.configuration = configuration
        self.content = content()
    }

    // MARK: - UI

    var body: some View {
        let style: LykaButtonCore<Content>.Style = variant.materialized(stylesheet: stylesheet)

        Button(action: action) {
            content
                .underline(
                    variant == .link
                )
                .frame(
                    maxWidth: configuration.fullWidth ? .infinity : nil
                )
                .padding(
                    .vertical,
                    stylesheet.spacing.medium
                )
                .padding(
                    .horizontal,
                    stylesheet.spacing.large
                )
                .foregroundStyle(
                    style.foregroundColor
                )
                .background(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .fill(style.backgroundColor)
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: style.cornerRadius
                    )
                    .strokeBorder(
                        isDisabled ? style.borderColor.opacity(0.5) : style.borderColor,
                        lineWidth: style.borderWidth
                    )
                )
        }
        .disabled(
            isDisabled
        )
        .opacity(
            isDisabled ? 0.5 : 1.0
        )
    }
}

// MARK: - LykaButtonCore+Style

extension LykaButtonCore {
    struct Style {
        /// The foreground color of the button (text/icon).
        let foregroundColor: Color

        /// The background color of the button.
        let backgroundColor: Color

        /// The border color of the button.
        let borderColor: Color

        /// The border line width.
        let borderWidth: CGFloat

        /// The corner radius for the style.
        let cornerRadius: CGFloat

        // MARK: - Initializer

        init(
            foregroundColor: Color,
            backgroundColor: Color,
            borderColor: Color,
            borderWidth: CGFloat,
            cornerRadius: CGFloat
        ) {
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.cornerRadius = cornerRadius
        }

        // MARK: - Utility

        static func primary(
            stylesheet: LykaStylesheet
        ) -> Self {
            .init(
                foregroundColor: stylesheet.colors.buttonPrimaryForeground,
                backgroundColor: stylesheet.colors.buttonPrimaryBackground,
                borderColor: stylesheet.colors.buttonPrimaryBackground,
                borderWidth: stylesheet.borders.thin,
                cornerRadius: stylesheet.radii.medium
            )
        }

        static func link(
            stylesheet: LykaStylesheet
        ) -> Self {
            .init(
                foregroundColor: stylesheet.colors.buttonLinkForeground,
                backgroundColor: .clear,
                borderColor: .clear,
                borderWidth: stylesheet.borders.thin,
                cornerRadius: stylesheet.radii.medium
            )
        }
    }
}
