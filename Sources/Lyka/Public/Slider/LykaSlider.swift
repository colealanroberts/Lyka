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
    @State
    private var viewModel: ViewModel

    // MARK: - Init

    public init(
        value: Binding<Double>,
        range: ClosedRange<Double> = 0.0...1.0,
        step: Double = 0.01
    ) {
        self._viewModel = .init(
            wrappedValue: .init(
                progress: value,
                range: range,
                step: step
            )
        )
    }

    // MARK: - UI

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                LykaProgressBar(
                    progress: .init(
                        get: { viewModel.displayProgress },
                        set: { _ in }
                    ),
                    variant: .determinate,
                    animated: false
                )
                .onAppear {
                    viewModel.maxOffset = proxy.size.width - stylesheet.spacing.xxl
                }

                track
            }
            .sensoryFeedback(.selection, trigger: viewModel.hapticTrigger)
        }
    }

    @ViewBuilder
    private var track: some View {
        let gesture = DragGesture().onChanged {
            viewModel.onDrag(
                x: $0.location.x,
                width: stylesheet.spacing.xxl / 2
            )
        }
        .onEnded { _ in
            viewModel.onEnded()
        }

        RoundedRectangle(
            cornerRadius: stylesheet.radii.medium
        )
        .fill(
            .white
        )
        .shadow(
            radius: 1
        )
        .scaleEffect(
            viewModel.state == .dragging ? 1.2 : 1.0
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

        /// The progress displayed to the user.
        /// - Note: Note, this value is normalized using min-max normalization.
        var displayProgress: Double {
            normalize(
                value,
                min: range.lowerBound,
                max: range.upperBound
            )
        }

        /// The current drag x-position.
        var xOffset: CGFloat {
            guard maxOffset > .zero else {
                return .zero
            }

            return displayProgress * maxOffset
        }

        /// The max offset (width - thumb size).
        /// - Note: This is set `onAppear { ... }` using the width of the container.
        var maxOffset: CGFloat = .zero

        /// The current state.
        var state: DragState = .idle

        /// Triggers haptics when step boundary is exceeded.
        var hapticTrigger = false

        // MARK: - Private Properties

        /// The current value
        private var value: Double {
            didSet {
                progress.wrappedValue = value
            }
        }

        /// The range of values.
        private let range: ClosedRange<Double>

        /// The step increment.
        private let step: Double?

        /// The binding to the external value
        private let progress: Binding<Double>

        /// The range delta.
        private let delta: Double

        init(
            progress: Binding<Double>,
            range: ClosedRange<Double>,
            step: Double?
        ) {
            assert(range.lowerBound >= 0.0)
            assert(range.upperBound > 0.0)

            self.progress = progress
            self.range = range
            self.value = progress.wrappedValue
            self.step = step
            self.delta = range.upperBound - range.lowerBound
        }

        // MARK: - Methods

        func onDrag(
            x: CGFloat,
            width: CGFloat
        ) {
            guard maxOffset > .zero else { return }

            let drag = min(max(.zero, x - width), maxOffset)
            let percent = drag / maxOffset
            var next = range.lowerBound + (percent * delta)

            // Snap to step if configured.
            if let step {
                let prev = value
                next = (next / step).rounded() * step
                next = next.clamped(to: range)

                let prevStep = (prev / step).rounded()
                let nextStep = (next / step).rounded()

                if prevStep != nextStep {
                    hapticTrigger.toggle()
                }
            }

            value = next

            withAnimation(.snappy(duration: 0.2)) {
                state = .dragging
            }
        }

        func onEnded() {
            withAnimation(.snappy(duration: 0.2)) {
                state = .idle
            }
        }

        // MARK: - Private Properties

        private func normalize(
            _ value: Double,
            min: Double,
            max: Double
        ) -> Double {
            (value - min) / (max - min)
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

// MARK: - Double+Util

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
