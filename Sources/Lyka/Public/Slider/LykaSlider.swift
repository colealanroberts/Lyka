//
//  LykaSlider.swift
//  Lyka
//
//  Created by Cole Roberts on 2/9/26.
//

import SwiftUI

public struct LykaSlider: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Private Properties

    /// The backing view model.
    @Bindable
    private var viewModel: ViewModel

    // MARK: - Init

    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double>
    ) {
        self.viewModel = .init(
            progress: value,
            range: range
        )
    }

    // MARK: - UI

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                LykaProgressBar(
                    progress: .init(
                        get: { viewModel.normalizedProgress },
                        set: { _ in }
                    ),
                    variant: .determinate,
                    animated: false
                )
                .onAppear {
                    viewModel.maxOffset = proxy.size.width - stylesheet.spacing.xxl
                }

                track()
            }
        }
        .frame(height: 24)
    }

    @ViewBuilder
    private func track() -> some View {
        let gesture = DragGesture().onChanged {
                viewModel.onDrag(
                    x: $0.location.x,
                    stylesheet: stylesheet
                )
            }
            .onEnded { _ in
                viewModel.onEnded()
            }

        RoundedRectangle(cornerRadius: stylesheet.radii.medium)
            .fill(
                .white
            )
            .shadow(
                radius: 1
            )
            .offset(
                x: viewModel.xOffset
            )
            .gesture(
                gesture
            )
            .frame(
                width: stylesheet.spacing.xxl,
                height: stylesheet.spacing.xxl
            )
    }
}

// MARK: - LykaSlider+ViewModel

private extension LykaSlider {
    @Observable
    final class ViewModel {

        // MARK: - Properties

        /// The binding to the external value
        var progress: Binding<Double>

        /// The current drag x-position.
        var xOffset: CGFloat = .zero

        /// The max offset (width - thumb size).
        var maxOffset: CGFloat = .zero

        /// The current state.
        var state: DragState = .idle

        /// Normalized progress (0.0 to 1.0) for the progress bar.
        var normalizedProgress: Double {
            maxOffset > .zero ? xOffset / maxOffset : .zero
        }

        // MARK: - Private Properties

        /// The range of values.
        let range: ClosedRange<Double>

        init(
            progress: Binding<Double>,
            range: ClosedRange<Double>
        ) {
            self.progress = progress
            self.range = range
        }

        // MARK: - Methods

        func onDrag(
            x: CGFloat,
            stylesheet: LykaStylesheet
        ) {
            guard maxOffset > .zero else { return }

            state = .dragging
            xOffset = min(max(0, x - stylesheet.spacing.xxl / 2), maxOffset)

            let percentage = xOffset / maxOffset
            let delta = range.upperBound - range.lowerBound

            progress.wrappedValue = range.lowerBound + (percentage * delta)
        }

        func onEnded() {
            state = .idle
        }
    }
}

// MARK: - LykaSlider+DragState

private extension LykaSlider {
    enum DragState {
        /// The slider is idle
        case idle

        /// The slider is dragging
        case dragging
    }
}
