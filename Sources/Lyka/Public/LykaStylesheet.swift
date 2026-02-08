//
//  LykaStylesheet.swift
//  Lyka
//
//  Created by Cole Roberts on 2/4/26.
//

import SwiftUI

/// ``Lyka``
/// Prounced `Leica` - is a design system that surfaces themeable
/// UI components, like textfields, buttons, etc.
/// The top-level stylesheet supplies all design specifications for typography, colors, and
/// individual component UI. These are then relayed using the `Environment` object.
public struct LykaStylesheet: Sendable {

    // MARK: - Singleton

    public static let standard = LykaStylesheet()

    // MARK: - Properties

    /// The backing `Colors` style.
    public let colors: Colors

    /// The backing `Typography` style.
    public let typography: Typography

    /// The backing `Spacing` style.
    public let spacing: Spacing

    /// The backing `Borders` style.
    public let borders: Borders

    /// The backing `Radii` style.
    public let radii: Radii

    // MARK: - Init

    init(
        colors: Colors = .init(),
        typography: Typography = .init(),
        spacing: Spacing = .init(),
        borders: Borders = .init(),
        radii: Radii = .init()
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.borders = borders
        self.radii = radii
    }
}

// MARK: - LykaStylesheet+Colors

extension LykaStylesheet {
    public struct Colors: Sendable {
        public let primary: Color
        public let secondary: Color
        public let borderDefault: Color
        public let borderFocused: Color
        public let surfaceSystem: Color
        public let surfaceDark: Color

        public let success: Color
        public let warning: Color
        public let fail: Color

        init(
            primary: Color = .blue,
            secondary: Color = .red,
            borderDefault: Color = Color(UIColor.systemGray),
            borderFocused: Color = .black,
            surfaceSystem: Color = Color(UIColor.systemBackground),
            surfaceDark: Color = .black,
            success: Color = .green,
            fail: Color = .red,
            warning: Color = .yellow
        ) {
            self.primary = primary
            self.secondary = secondary
            self.borderDefault = borderDefault
            self.borderFocused = borderFocused
            self.surfaceSystem = surfaceSystem
            self.surfaceDark = surfaceDark
            self.success = success
            self.fail = fail
            self.warning = warning
        }
    }
}

// MARK: - LykaStylesheet+Typography

extension LykaStylesheet {
    public struct Typography: Sendable {
        /// `8.0`
        public let footnote: CGFloat

        /// `10.0`
        public let caption: CGFloat

        /// `12.0`
        public let caption2: CGFloat

        /// `14.0`
        public let body: CGFloat

        /// `16.0`
        public let head5: CGFloat

        /// `18.0`
        public let head4: CGFloat

        /// `21.0`
        public let head3: CGFloat

        /// `24.0`
        public let head2: CGFloat

        /// `28.0`
        public let head1: CGFloat

        init(
            footnote: CGFloat = 8.0,
            caption: CGFloat = 12.0,
            caption2: CGFloat = 10.0,
            body: CGFloat = 14.0,
            head5: CGFloat = 16.0,
            head4: CGFloat = 18.0,
            head3: CGFloat = 21.0,
            head2: CGFloat = 24.0,
            head1: CGFloat = 28.0
        ) {
            self.footnote = footnote
            self.caption = caption
            self.caption2 = caption2
            self.body = body
            self.head5 = head5
            self.head4 = head4
            self.head3 = head3
            self.head2 = head2
            self.head1 = head1
        }
    }
}

// MARK: - LykaStylesheet+Spacing

extension LykaStylesheet {
    public struct Spacing: Sendable {
        /// `2.0`
        public let xxs: CGFloat

        /// `4.0`
        public let xs: CGFloat

        /// `8.0`
        public let small: CGFloat

        /// `12.0`
        public let medium: CGFloat

        /// `16.0`
        public let large: CGFloat

        /// `20.0`
        public let xl: CGFloat

        /// `24.0`
        public let xxl: CGFloat

        /// `32.0`
        public let xxxl: CGFloat

        public init(
            xxs: CGFloat = 2.0,
            xs: CGFloat = 4.0,
            small: CGFloat = 8.0,
            medium: CGFloat = 12.0,
            large: CGFloat = 16.0,
            xl: CGFloat = 20.0,
            xxl: CGFloat = 24.0,
            xxxl: CGFloat = 32.0
        ) {
            self.xxs = xxs
            self.xs = xs
            self.small = small
            self.medium = medium
            self.large = large
            self.xl = xl
            self.xxl = xxl
            self.xxxl = xxxl
        }
    }
}

// MARK: - LykaStylesheet.Borders

extension LykaStylesheet {
    public struct Borders: Sendable {
        /// `1.0`
        public let thin: CGFloat

        /// `2.0`
        public let regular: CGFloat

        /// `3.0`
        public let thick: CGFloat

        public init(
            thin: CGFloat = 1.0,
            regular: CGFloat = 2.0,
            thick: CGFloat = 3.0
        ) {
            self.thin = thin
            self.regular = regular
            self.thick = thick
        }
    }
}

// MARK: - LykaStylesheet.Radii

extension LykaStylesheet {
    public struct Radii: Sendable {
        /// `4.0`
        public let small: CGFloat

        /// `8.0`
        public let medium: CGFloat

        /// `12.0`
        public let large: CGFloat

        /// `16.0`
        public let extraLarge: CGFloat

        /// `20.0`
        public let xxl: CGFloat

        /// `24.0`
        public let xxxl: CGFloat

        public init(
            small: CGFloat = 4.0,
            medium: CGFloat = 8.0,
            large: CGFloat = 12.0,
            extraLarge: CGFloat = 16.0,
            xxl: CGFloat = 20.0,
            xxxl: CGFloat = 24.0
        ) {
            self.small = small
            self.medium = medium
            self.large = large
            self.extraLarge = extraLarge
            self.xxl = xxl
            self.xxxl = xxxl
        }
    }
}
// MARK: - Environment

private struct LykaStylesheetKey: EnvironmentKey {
    static let defaultValue = LykaStylesheet.standard
}

extension EnvironmentValues {
    public var stylesheet: LykaStylesheet {
        get {
            self[LykaStylesheetKey.self]
        }
        set {
            self[LykaStylesheetKey.self] = newValue
        }
    }
}
