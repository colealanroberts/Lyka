//
//  LykaProgress.swift
//  Lyka
//
//  Created by Cole Roberts on 2/6/26.
//

import SwiftUI

public struct LykaProgressBar: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Private Properties

    /// Animation state for indeterminate progress
    @State
    private var isAnimating = false

    /// The progress binding.
    private let progress: Binding<Double>

    /// The variant.
    /// - Note: See `LykaProgressBarVariant`.
    private let variant: LykaProgressBarVariant

    /// Whether updates are animated.
    private let animated: Bool

    // MARK: - Public Init

    /// The public API for binding progress updates.
    public init(
        progress: Binding<Double>? = nil,
        variant: LykaProgressBarVariant,
        animated: Bool = true
    ) {
        self.progress = progress ?? .constant(0)
        self.variant = variant
        self.animated = animated
    }

    // MARK: - UI

    public var body: some View {
        ZStack(alignment: .leading) {
            // Track
            Capsule()
                .fill(Color.black.opacity(0.1))

            // Progress
            Group {
                switch variant {
                case .determinate:
                    determinateProgress
                case .indeterminate:
                    indeterminateProgress
                }
            }
        }
        .frame(height: stylesheet.spacing.xs)
        .onAppear {
            if variant == .indeterminate {
                isAnimating = true
            }
        }
    }

    private var determinateProgress: some View {
        bar.mask(
            GeometryReader { proxy in
                Rectangle()
                    .frame(
                        width: proxy.size.width * (max(0, min(1.0, progress.wrappedValue)))
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .animation(animated ? .snappy : nil, value: progress.wrappedValue)
            }
        )
    }

    private var indeterminateProgress: some View {
        bar.mask(
            GeometryReader { proxy in
                Rectangle()
                    .frame(
                        width: isAnimating ? proxy.size.width * 0.1 : proxy.size.width * 0.4
                    )
                    .offset(
                        x: isAnimating ? proxy.size.width * 0.9 : -proxy.size.width * 0.4
                    )
                    .animation(
                        .easeInOut(duration: 1.25).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
        )
    }

    private var bar: some View {
        Capsule()
            .fill(stylesheet.colors.primary)
            .frame(maxWidth: .infinity)
    }
}
// MARK: - LykaProgressBarVariant

public enum LykaProgressBarVariant {
    /// The progress bar a determine style i.e. it progress from 0.0...100.0.
    case determinate

    /// The progress bar is nondeterminstic, i.e. infinite.
    case indeterminate
}
