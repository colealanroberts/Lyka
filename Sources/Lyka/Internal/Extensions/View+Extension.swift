//
//  View+Extension.swift
//  Lyka
//
//  Created by Cole Roberts on 2/4/26.
//

import SwiftUI

extension View {
    public func stylesheet(
        _ stylesheet: LykaStylesheet
    ) -> some View {
        environment(\.stylesheet, stylesheet)
    }
}
