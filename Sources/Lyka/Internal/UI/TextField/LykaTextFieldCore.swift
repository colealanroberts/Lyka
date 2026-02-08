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
    private let placeholder: String

    /// The variant to use for styling.
    private let variant: LykaTextFieldVariant

    /// The backing `LkyaTextField.Configuration`.
    private let configuration: LykaTextFieldConfiguration

    /// The field content builder (`TextField` or `SecureField`).
    private let content: Content

    public init(
        text: Binding<String>,
        placeholder: String,
        variant: LykaTextFieldVariant,
        configure: (inout LykaTextFieldConfiguration) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.text = text
        self.placeholder = placeholder
        self.variant = variant
        var configuration = LykaTextFieldConfiguration()
        configure(&configuration)
        self.configuration = configuration
        self.content = content()
    }

    // MARK: - UI

    public var body: some View {
        let style: LykaTextFieldStyle = variant.materialized(stylesheet: stylesheet)

        VStack(alignment: .leading) {
            Text(placeholder)
                .font(.caption)
                .fontWeight(
                    .semibold
                )
                .foregroundStyle(
                    isFocused ? style.borderColorFocused : style.borderColor
                )
                .offset(
                    x: stylesheet.spacing.small,
                    y: stylesheet.spacing.small
                )

            content
                .focused($isFocused)
                .padding(.top, stylesheet.spacing.xs)
                .padding(.horizontal, stylesheet.spacing.small)
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
        .contentShape(
            .rect
        )
        .onTapGesture {
            isFocused = true
        }
    }
}

// MARK: - LykaTextFieldStyle

public struct LykaTextFieldStyle {
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
            backgroundColor: stylesheet.colors.surfaceDark,
            borderColor: stylesheet.colors.borderDefault,
            borderColorFocused: stylesheet.colors.borderFocused,
            borderWidth: stylesheet.borders.thin,
            borderWidthFocused: stylesheet.borders.regular,
            borderRadius: stylesheet.radii.medium
        )
    }
}

// MARK: - LykaTextField+Convenience

extension LykaTextFieldCore where Content == TextField<Text> {
    /// Creates a standard text field.
    public init(
        text: Binding<String>,
        placeholder: String,
        variant: LykaTextFieldVariant,
        configure: (inout LykaTextFieldConfiguration) -> Void = { _ in }
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

extension LykaTextFieldCore where Content == SecureField<Text> {
    /// Creates a secure text field.
    public init(
        text: Binding<String>,
        placeholder: String,
        variant: LykaTextFieldVariant,
        configure: (inout LykaTextFieldConfiguration) -> Void = { _ in }
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
