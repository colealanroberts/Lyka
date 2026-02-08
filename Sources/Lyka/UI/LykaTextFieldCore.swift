//
//  LykaTextFieldCore.swift
//  Lyka
//
//  Created by Cole Roberts on 2/4/26.
//

import Foundation
import SwiftUI

public struct LykaTextFieldCore<Content: View>: View {

    // MARK: - Environment | Binding

    @Environment(\.stylesheet)
    private var stylesheet

    /// Focus state for the field.
    @FocusState
    private var isFocused: Bool

    // MARK: - Private Properties

    /// The binding text.
    private let text: Binding<String>

    /// A placeholder to display, if any.
    private let placeholder: String?

    /// The variant to use for styling.
    private let variant: Variant

    /// The backing `LkyaTextField.Configuration`.
    private let configuration: Configuration

    /// The field content builder (`TextField` or `SecureField`).
    private let content: Content

    /// Computed property to determine if placeholder should be at top of the field.
    private var shouldMovePlaceholder: Bool {
        isFocused || !text.wrappedValue.isEmpty
    }

    public init(
        text: Binding<String>,
        placeholder: String?,
        variant: Variant,
        configure: (inout Configuration) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.text = text
        self.placeholder = placeholder
        self.variant = variant
        var configuration = Configuration()
        configure(&configuration)
        self.configuration = configuration
        self.content = content()
    }

    // MARK: - UI

    public var body: some View {
        let style = variant.materialized(stylesheet: stylesheet)

        ZStack(alignment: .leading) {
            if let placeholder {
                Text(placeholder)
                    .font(.caption)
                    .fontWeight(
                        shouldMovePlaceholder ? .semibold  : .regular
                    )
                    .foregroundStyle(
                        isFocused ? style.borderColorFocused : style.borderColor
                    )
                    .offset(
                        x: stylesheet.spacing.small,
                        y: shouldMovePlaceholder ? -stylesheet.spacing.medium : 0
                    )
            }

            content
                .focused($isFocused)
                .padding(.top, stylesheet.spacing.xxxl)
                .padding(.leading, stylesheet.spacing.small)
                .padding(.bottom, stylesheet.spacing.small)
                .textInputAutocapitalization(configuration.textInputAutocapitalization)
                .keyboardType(configuration.keyboardType)
                .textContentType(configuration.textContentType)
                .autocorrectionDisabled(configuration.autocorrectionDisabled)
        }
        .background(
            RoundedRectangle(
                cornerRadius: style.borderRadius
            )
            .strokeBorder(
                isFocused ? style.borderColorFocused : style.borderColor,
                lineWidth: isFocused ? style.borderWidthFocused : style.borderWidth
            )
        )
        .animation(
            .snappy,
            value: shouldMovePlaceholder
        )
        .contentShape(
            .rect
        )
        .onTapGesture {
            isFocused = true
        }
    }
}

// MARK: - LykaTextField.Variant

extension LykaTextField {
    public enum Variant {
        /// The primary variant.
        case primary

        /// Constructs a concrete `BlueprintTextField.Style` from the abstract tyle (`Self`).
        func materialized(stylesheet: LykaStylesheet) -> LykaTextField.Style {
            .primary(stylesheet: stylesheet)
        }
    }
}

// MARK: - LykaTextField+Configuration

extension LykaTextField {
    public struct Configuration {
        /// The capitalization strategy for a textfield, if any.
        /// - Note: The default value is `nil`.
        public var textInputAutocapitalization: TextInputAutocapitalization?

        /// The type of keyboard.
        /// - Note: The default value is `.default`.
        public var keyboardType: UIKeyboardType

        /// The text content type, if any.
        /// - Note: The default value is `nil`.
        public var textContentType: UITextContentType?

        /// Whether autocorrect is disabled.
        /// - Note: The default value is `false`.
        public var autocorrectionDisabled: Bool

        public init(
            textInputAutocapitalization: TextInputAutocapitalization? = nil,
            keyboardType: UIKeyboardType = .default,
            textContentType: UITextContentType? = nil,
            autocorrectionDisabled: Bool = false
        ) {
            self.textInputAutocapitalization = textInputAutocapitalization
            self.keyboardType = keyboardType
            self.textContentType = textContentType
            self.autocorrectionDisabled = autocorrectionDisabled
        }
    }
}

// MARK: - LykaTextField+Style

extension LykaTextField {
    public struct Style {
        /// The background color of the textfield, if any.
        let backgroundColor: Color?

        /// The border color of the textfield when unfocused.
        let borderColor: Color

        /// The border color of the textfield when focused.
        let borderColorFocused: Color

        /// The border line width when unfocused.
        let borderWidth: CGFloat

        /// The border line width when focused.
        let borderWidthFocused: CGFloat

        /// The border radius for the style.
        let borderRadius: CGFloat

        // MARK: - Initializer

        public init(
            backgroundColor: Color?,
            borderColor: Color,
            borderColorFocused: Color,
            borderWidth: CGFloat,
            borderWidthFocused: CGFloat,
            borderRadius: CGFloat
        ) {
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.borderColorFocused = borderColorFocused
            self.borderWidthFocused = borderWidthFocused
            self.borderWidth = borderWidth
            self.borderRadius = borderRadius
        }

        // MARK: - Utility

        public static func primary(
            stylesheet: LykaStylesheet
        ) -> Self {
            .init(
                backgroundColor: stylesheet.colors.surfaceDefault,
                borderColor: stylesheet.colors.borderDefault,
                borderColorFocused: stylesheet.colors.borderFocused,
                borderWidth: stylesheet.borders.thin,
                borderWidthFocused: stylesheet.borders.regular,
                borderRadius: stylesheet.radii.medium
            )
        }
    }
}

// MARK: - LykaTextField+Convenience

extension LykaTextField where Content == TextField<Text> {
    /// Creates a standard text field.
    public init(
        text: Binding<String>,
        placeholder: String?,
        variant: Variant,
        configure: (inout Configuration) -> Void = { _ in }
    ) {
        self.init(
            text: text,
            placeholder: placeholder,
            variant: variant,
            configure: configure,
            content: {
                TextField("", text: text)
            }
        )
    }
}

extension LykaTextField where Content == SecureField<Text> {
    /// Creates a secure text field.
    public init(
        text: Binding<String>,
        placeholder: String?,
        variant: Variant,
        configure: (inout Configuration) -> Void = { _ in }
    ) {
        self.init(
            text: text,
            placeholder: placeholder,
            variant: variant,
            content: {
                SecureField(
                    "",
                    text: text
                )
            }
        )
    }
}
