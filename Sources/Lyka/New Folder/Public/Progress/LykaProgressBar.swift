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

    /// The progress binding.
    private let progress: Binding<Double>

    /// The variant.
    /// - Note: See `LykaProgressBarVariant`.
    private let variant: LykaProgressBarVariant

    /// Animation state for indeterminate progress
    @State private var isAnimating = false

    // MARK: - Init

    public init(
        progress: Binding<Double>? = nil,
        variant: LykaProgressBarVariant
    ) {
        self.progress = progress ?? .constant(0)
        self.variant = variant
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
                        width: proxy.size.width * (max(0, min(100, progress.wrappedValue)) / 100)
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .animation(
                        .snappy,
                        value: progress.wrappedValue
                    )
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
            .fill(Color.blue)
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
