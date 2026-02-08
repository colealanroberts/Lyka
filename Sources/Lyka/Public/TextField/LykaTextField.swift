//
//  LykaTextField.swift
//  Lyka
//
//  Created by Cole Roberts on 2/4/26.
//

import Foundation
import SwiftUI

public struct LykaTextField<TrailingContent: View>: View {

    // MARK: - Private Properties

    /// The binding text.
    private let text: Binding<String>

    /// A placeholder to display, if any.
    private let placeholder: String

    /// The variant to use for styling.
    private let variant: LykaTextFieldVariant

    /// The backing `LkyaTextFieldConfiguration`.
    private let configuration: LykaTextFieldConfiguration

    /// The trailing content, if any.
    private let trailingContent: TrailingContent

    // MARK: - Init

    public init(
        text: Binding<String>,
        placeholder: String,
        variant: LykaTextFieldVariant = .primary,
        @ViewBuilder trailingContent: () -> TrailingContent = { EmptyView() },
        configure: (inout LykaTextFieldConfiguration) -> Void = { _ in }
    ) {
        self.text = text
        self.placeholder = placeholder
        self.variant = variant
        var configuration = LykaTextFieldConfiguration()
        configure(&configuration)
        self.trailingContent = trailingContent()
        self.configuration = configuration
    }

    public var body: some View {
        LykaTextFieldCore(
            text: text,
            placeholder: placeholder,
            variant: variant,
            configure: { $0 = configuration }
        ) {
            HStack(alignment: .top) {
                TextField("", text: text)
                trailingContent
            }
        }
    }
}
