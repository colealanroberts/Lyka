//
//  LykaTextFieldConfiguration.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import Foundation
import SwiftUI

public struct LykaTextFieldConfiguration {
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

    /// Whether the clear button appears during text entr.y
    /// - Note: The default value is `false.`
    public var displayClearOnTextEntry: Bool

    public init(
        textInputAutocapitalization: TextInputAutocapitalization? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocorrectionDisabled: Bool = false,
        displayClearOnTextEntry: Bool = false
    ) {
        self.textInputAutocapitalization = textInputAutocapitalization
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocorrectionDisabled = autocorrectionDisabled
        self.displayClearOnTextEntry = displayClearOnTextEntry
    }
}
