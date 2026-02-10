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
    private let bottomOffset: CGFloat

    // MARK: - Init

    init(
        presenter: LykaToastPresenter,
        bottomOffset: CGFloat = .zero
    ) {
        self.presenter = presenter
        self.bottomOffset = bottomOffset
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
            .padding(.bottom, bottomOffset)
        }
    }
}

// MARK: - View+LykaToastViewModifier

extension View {
    /// A utility method that begins rendering toast content
    /// from an associated `LykaToastPresenter`.
    /// - Parameters:
    ///   - presenter: The toast presenter to use
    ///   - bottomOffset: Optional bottom padding to avoid overlapping with bottom UI elements (e.g., tab bars)
    public func xpresentingToasts(
        using presenter: LykaToastPresenter,
        bottomOffset: CGFloat = .zero
    ) -> some View {
        modifier(
            LykaToastViewModifier(
                presenter: presenter,
                bottomOffset: bottomOffset
            )
        )
    }
}
