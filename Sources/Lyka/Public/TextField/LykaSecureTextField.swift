//
//  LykaSecureTextField.swift
//  Lyka
//
//  Created by Cole Roberts on 2/4/26.
//

import Foundation
import SwiftUI

public struct LykaSecureTextField: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Private Properties

    /// Whether the password is revealed in plaintext.
    @State
    private var showPassword: Bool = false

    @FocusState
    private var field: Field?

    /// The binding text.
    private let text: Binding<String>

    /// A placeholder to display, if any.
    private let placeholder: String

    /// The variant to use for styling.
    private let variant: LykaTextFieldVariant

    /// The backing `LkyaTextField.Configuration`.
    private let configuration: LykaTextFieldConfiguration

    // MARK: - Init

    public init(
        text: Binding<String>,
        placeholder: String,
        variant: LykaTextFieldVariant = .primary,
        configure: (inout LykaTextFieldConfiguration) -> Void = { _ in }
    ) {
        self.text = text
        self.placeholder = placeholder
        self.variant = variant
        var configuration = LykaTextFieldConfiguration()
        configure(&configuration)
        self.configuration = configuration
    }

    public var body: some View {
        LykaTextFieldCore(
            text: text,
            placeholder: placeholder,
            variant: variant,
            configure: {
                var copy = $0
                copy.textContentType = .password
                copy = configuration
            }
        ) {
            ZStack(alignment: .trailing) {
                TextField("", text: text)
                    .opacity(showPassword ? 1.0 : 0.0)
                    .focused($field, equals: .plain)

                SecureField("", text: text)
                    .opacity(!showPassword ? 1.0 : 0.0)
                    .focused($field, equals: .secure)

                Button {
                    showPassword.toggle()

                    if showPassword {
                        field = .plain
                    } else {
                        field = .secure
                    }
                } label: {
                    Image(
                        systemName: showPassword ? "eye" : "eye.slash" 
                    )
                    .offset(
                        x: -stylesheet.spacing.small
                    )
                    .tint(stylesheet.colors.borderFocused)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - LykaSecureTextField+Field

private extension LykaSecureTextField {
    enum Field {
        /// The plain text field.
        case plain

        /// The secure text field.
        case secure
    }
}
