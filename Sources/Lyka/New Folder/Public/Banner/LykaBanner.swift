//
//  LykaBanner.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import SwiftUI

public struct LykaBanner: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Private Properties

    /// The title of the banner.
    private let title: String

    /// The variant of the banner.
    /// - Note: See `LykaBannerVariant`.
    private let variant: LykaBannerVariant

    /// The actions associated with a banner.
    private let actions: [Action]

    public init(
        title: String,
        variant: LykaBannerVariant,
        actions: Action...
    ) {
        self.init(
            title: title,
            variant: variant,
            actions: actions
        )
    }

    public init(
        title: String,
        variant: LykaBannerVariant,
        actions: [Action] = []
    ) {
        self.title = title
        self.variant = variant
        self.actions = actions
    }

    public var body: some View {
        let style: LykaBanner.Style = variant.materialized(stylesheet: stylesheet)

        ViewThatFits(in: .horizontal) {
            // Inline
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.system(size: stylesheet.typography.body))

                if !actions.isEmpty {
                    Spacer(minLength: stylesheet.spacing.medium)
                    HStack(spacing: stylesheet.spacing.small) {
                        ForEach(actions, id: \.id) { action in
                            Button(action: action.execute) {
                                Text(action.title)
                                    .font(.system(size: stylesheet.typography.caption))
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )

            VStack(
                alignment: .trailing,
                spacing: stylesheet.spacing.large
            ) {
                Text(title)
                    .font(.system(size: stylesheet.typography.body))
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !actions.isEmpty {
                    HStack(spacing: stylesheet.spacing.small) {
                        ForEach(actions, id: \.id) { action in
                            Button(action: action.execute) {
                                Text(action.title)
                                    .font(.system(size: stylesheet.typography.caption))
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
        }
        .padding(stylesheet.spacing.large)
        .foregroundStyle(style.foregroundColor)
        .background(
            RoundedRectangle(cornerRadius: stylesheet.radii.medium)
                .fill(style.backgroundColor)
        )
    }
}

// MARK: - LykaBanner+Action

extension LykaBanner {
    public struct Action: Identifiable {
        /// A unique identifier for the action.
        public let id = UUID()

        /// The title of the action.
        let title: String

        /// The closure to execute when tapped.
        let execute: () -> Void

        public init(
            title: String,
            execute: @escaping () -> Void
        ) {
            self.title = title
            self.execute = execute
        }
    }
}

// MARK: - LykaBanner+Style

extension LykaBanner {
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

        static func success(
            stylesheet: LykaStylesheet
        ) -> Self {
            .init(
                foregroundColor: .white,
                backgroundColor: stylesheet.colors.success
            )
        }

        static func warning(
            stylesheet: LykaStylesheet
        ) -> Self {
            .init(
                foregroundColor: .white,
                backgroundColor: stylesheet.colors.warning
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
