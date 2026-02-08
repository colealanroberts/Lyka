//
//  LykaStepper.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import SwiftUI

public struct LykaStepper<Value: Strideable, LeadingActionLabel: View, TrailingActionLabel: View>: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Properties

    public let axis: Axis

    /// The value to display, i.e. the count of something.
    public let value: Binding<Value>

    /// The leading action - i.e. the first action to display depending on axis.
    public let leadingAction: Action<LeadingActionLabel>

    /// The trailing action - i.e. the second action to display depending on axis.
    public let trailingAction: Action<TrailingActionLabel>

    // MARK: - Init

    public init(
        axis: Axis,
        value: Binding<Value>,
        leadingAction: Action<LeadingActionLabel>,
        trailingAction: Action<TrailingActionLabel>
    ) {
        self.axis = axis
        self.value = value
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
    }

    // MARK: - UI

    public var body: some View {
        Group {
            let leading = leadingAction
                .label
                .frame(
                    minWidth: 24,
                    minHeight: 24
                )
                .contentShape(
                    .rect
                )
                .onTapGesture {
                    withAnimation {
                        leadingAction.execute()
                    }
                }
                .sensoryFeedback(.decrease, trigger: value.wrappedValue)

            let trailing = trailingAction
                .label
                .frame(
                    minWidth: 24,
                    minHeight: 24
                )
                .contentShape(
                    .rect
                )
                .onTapGesture {
                    withAnimation {
                        trailingAction.execute()
                    }
                }
                .sensoryFeedback(.increase, trigger: value.wrappedValue)

            let text = Text("\(value.wrappedValue)")
                .font(.system(size: stylesheet.typography.body))
                .fontWeight(.bold)
                .contentTransition(.numericText())
                .frame(minWidth: stylesheet.spacing.xxxl)

            switch axis {
            case .horizontal:
                HStack(alignment: .center) {
                    leading
                    text
                    trailing
                }
            case .vertical:
                VStack(alignment: .center) {
                    trailing
                    text
                    leading
                }
            }
        }
        .padding(
            stylesheet.spacing.small
        )
        .foregroundStyle(
            .white
        )
        .background(
            RoundedRectangle(cornerRadius: stylesheet.radii.medium)
                .fill(stylesheet.colors.surfaceDark)
        )
    }
}

// MARK: - LykaStepper+Action

extension LykaStepper {
    public struct Action<Label: View> {
        /// The label for the action.
        public let label: Label

        /// The closure to execute when pressed.
        public let execute: () -> Void

        // MARK: - Init

        public init(
            label: Label,
            _ execute: @escaping () -> Void
        ) {
            self.label = label
            self.execute = execute
        }
    }
}

// MARK: - LykaStepper+Axis

extension LykaStepper {
    /// The axis that the stepper follows.
    public enum Axis {
        /// A vertical stepper.
        case vertical

        /// A horizontal stepper.
        case horizontal
    }
}
