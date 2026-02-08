//
//  LykaToastViewModifier.swift
//  Lyka
//
//  Created by Cole Roberts on 2/8/26.
//

import SwiftUI

struct LykaToastViewModifier: ViewModifier {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Private Properties

    private let presenter: LykaToastPresenter

    // MARK: - Init

    init(
        presenter: LykaToastPresenter
    ) {
        self.presenter = presenter
    }

    // MARK: - Body

    func body(
        content: Content
    ) -> some View {
        content.overlay(alignment: .bottom) {
            VStack {
                ForEach(presenter.storage) { toast in
                    LykaBanner(
                        title: toast.title,
                        variant: .default
                    )
                    .transition(
                        presenter.transition(for: toast)
                    )
                    .padding(
                        .horizontal,
                        stylesheet.spacing.xl
                    )
                    .padding(
                        .bottom,
                        stylesheet.spacing.large
                    )
                }
            }
        }
    }
}

// MARK: - View+LykaToastViewModifier

extension View {
    /// A utility method that begins rendering toast content
    /// from an associated `LykaToastPresenter`.
    public func presentingToasts(
        using presenter: LykaToastPresenter
    ) -> some View {
        modifier(
            LykaToastViewModifier(
                presenter: presenter
            )
        )
    }
}
