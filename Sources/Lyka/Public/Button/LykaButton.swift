//
//  LykaButton.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import Foundation
import SwiftUI

public struct LykaButton<Label: View>: View {

    // MARK: - Private Properties

    /// The action to perform when the button is tapped.
    private let action: () -> Void

    /// The variant to use for styling.
    private let variant: LykaButtonVariant

    /// The backing `LykaButtonConfiguration`.
    private let configuration: LykaButtonConfiguration

    /// The label content.
    private let label: Label

    // MARK: - Init

    public init(
        variant: LykaButtonVariant = .primary,
        configure: (inout LykaButtonConfiguration) -> Void = { _ in },
        @ViewBuilder label: () -> Label,
        _ action: @escaping () -> Void
    ) {
        self.action = action
        self.variant = variant
        var configuration = LykaButtonConfiguration()
        configure(&configuration)
        self.configuration = configuration
        self.label = label()
    }

    public var body: some View {
        LykaButtonCore(
            action: action,
            variant: variant,
            configure: { $0 = configuration }
        ) { label }
    }
}

// MARK: - Convenience

extension LykaButton where Label == Text {
    /// Convenience initializer for text-only buttons.
    public init(
        _ title: String,
        variant: LykaButtonVariant = .primary,
        configure: (inout LykaButtonConfiguration) -> Void = { _ in },
        _ action: @escaping () -> Void
    ) {
        self.init(
            variant: variant,
            configure: configure,
            label: { Text(title) },
            action
        )
    }
}
