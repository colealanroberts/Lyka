//
//  LykaButtonConfiguration.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import Foundation
import SwiftUI

public struct LykaButtonConfiguration {
    /// Whether the button is disabled.
    /// - Note: The default value is `false`.
    public var isDisabled: Bool

    /// The loading state of the button.
    /// - Note: The default value is `false`.
    public var isLoading: Bool

    /// Whether the button should expand to fill available width.
    /// - Note: The default value is `false`.
    public var fullWidth: Bool

    public init(
        isDisabled: Bool = false,
        isLoading: Bool = false,
        fullWidth: Bool = false
    ) {
        self.isDisabled = isDisabled
        self.isLoading = isLoading
        self.fullWidth = fullWidth
    }
}
