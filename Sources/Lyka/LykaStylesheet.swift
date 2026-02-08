//
//  LykaStylesheet.swift
//  Lyka
//
//  Created by Cole Roberts on 2/4/26.
//

import SwiftUI

/// Blueprint is a design system that surfaces themeable
/// UI components, like textfields, buttons, etc.
///
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

        init(
            primary: Color = .blue,
            secondary: Color = .red,
            borderDefault: Color = .black,
            borderFocused: Color = .blue
        ) {
            self.primary = primary
            self.secondary = secondary
            self.borderDefault = borderDefault
            self.borderFocused = borderFocused
        }
    }
}

// MARK: - LykaStylesheet+Typography

extension LykaStylesheet {
    public struct Typography: Sendable {
        init() {}
    }
}

// MARK: - LykaStylesheet+Spacing

extension LykaStylesheet {
    public struct Spacing: Sendable {
        init() {}
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
        /// `2.0`
        public let xs: CGFloat

        /// `4.0`
        public let sm: CGFloat

        /// `8.0`
        public let md: CGFloat

        /// `12.0`
        public let lg: CGFloat

        /// `16.0`
        public let xl: CGFloat

        public init(
            xs: CGFloat = 2.0,
            sm: CGFloat = 4.0,
            md: CGFloat = 8.0,
            lg: CGFloat = 12.0,
            xl: CGFloat = 16.0,
        ) {
            self.xs = xs
            self.sm = sm
            self.md = md
            self.lg = lg
            self.xl = xl
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
