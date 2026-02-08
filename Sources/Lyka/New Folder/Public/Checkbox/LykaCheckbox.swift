//
//  LykaCheckbox.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import SwiftUI

public struct LykaCheckbox<Label: View>: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Properties

    public let isOn: Binding<Bool>
    public let label: Label

    // MARK: - Init

    public init(
        isOn: Binding<Bool>,
        @ViewBuilder _ label: () -> Label
    ) {
        self.isOn = isOn
        self.label = label()
    }

    // MARK: - UI

    public var body: some View {
        HStack(
            alignment: .top,
            spacing: stylesheet.spacing.medium
        ) {
            RoundedRectangle(
                cornerRadius: stylesheet.radii.small
            )
            .fill(
                isOn.wrappedValue ? stylesheet.colors.surfaceDark : stylesheet.colors.surfaceSystem
            )
            .strokeBorder(
                isOn.wrappedValue ? stylesheet.colors.borderFocused : stylesheet.colors.borderDefault,
                lineWidth: stylesheet.borders.thin
            )
            .frame(
                width: 24,
                height: 24
            )
            .overlay {
                Image(systemName: "checkmark")
                    .font(
                        .system(
                            size: stylesheet.typography.caption,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        .white
                    )
                    .opacity(
                        isOn.wrappedValue ? 1.0 : 0.0
                    )
            }
            .contentShape(
                .rect
            )

            label
        }
        .sensoryFeedback(
            .impact,
            trigger: isOn.wrappedValue
        )
        .contentShape(
            .rect
        )
        .onTapGesture {
            withAnimation(.snappy) {
                isOn.wrappedValue.toggle()
            }
        }
    }
}
