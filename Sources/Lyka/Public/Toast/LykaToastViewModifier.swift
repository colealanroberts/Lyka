//
//  LykaToastViewModifier.swift
//  Lyka
//
//  Created by Cole Roberts on 2/8/26.
//

import SwiftUI

struct LykaToastViewModifier: ViewModifier {

    // MARK: - Private Properties

    private let presenter = ToastPresenter()

    // MARK: - Body

    func body(
        content: Content
    ) -> some View {
        content.overlay {
            VStack {
                ForEach(presenter.storage) { toast in
                    LykaBan
                }
            }
        }
    }
}
