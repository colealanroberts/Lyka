//
//  LykaToggle.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import SwiftUI

public struct LykaToggle: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Properties

    private let isOn: Binding<Bool>

    // MARK: - Init

    public init(
        isOn: Binding<Bool>
    ) {
        self.isOn = isOn
    }

    // MARK: - UI

    public var body: some View {
        HStack {
            if isOn.wrappedValue {
                Spacer()
            }

            RoundedRectangle(cornerRadius: stylesheet.radii.small)
                .fill(stylesheet.colors.toggleKnob)
                .frame(width: 26, height: 26)
                .padding(4)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.system(size: stylesheet.typography.footnote))
                        .fontWeight(.bold)
                        .opacity(isOn.wrappedValue ? 1.0 : 0.0)
                }

            if !isOn.wrappedValue {
                Spacer()
            }
        }
        .sensoryFeedback(
            .decrease,
            trigger: isOn.wrappedValue == false
        )
        .sensoryFeedback(
            .increase,
            trigger: isOn.wrappedValue == true
        )
        .frame(
            width: 64,
            height: 32
        )
        .background(
            RoundedRectangle(cornerRadius: stylesheet.radii.small)
                .fill(isOn.wrappedValue ? stylesheet.colors.primary : stylesheet.colors.borderDefault)
        )
        .contentShape(
            .rect
        )
        .onTapGesture {
            withAnimation(.spring(duration: 0.25)) {
                isOn.wrappedValue.toggle()
            }
        }
    }
}
