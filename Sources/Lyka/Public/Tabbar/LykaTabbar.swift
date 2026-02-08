//
//  LykaTabbar.swift
//  Lyka
//
//  Created by Cole Roberts on 2/8/26.
//

import SwiftUI

// MARK: - LykaTabbar

public struct LykaTabbar: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Public Properties

    /// The current tabs.
    private let tabs: [Tab]

    /// The currently active tab.
    @State
    private var activeTab: Tab

    /// Namespace for matched geometry effect.
    @Namespace
    private var namespace

    // MARK: - Init

    public init(

        tabs: [Tab]
    ) {
        assert(!tabs.isEmpty)

        self.tabs = tabs
        self.activeTab = tabs[0]
    }

    // MARK: - UI

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.id) { tab in
                let isActive = activeTab == tab

                Button {
                    withAnimation(.spring(duration: 0.25)) {
                        activeTab = tab
                    }
                    tab.onTap()
                } label: {
                    tabLabel(for: tab, isActive: isActive)
                }
                .contentShape(Rectangle())
            }
        }
        .padding(
            stylesheet.spacing.small
        )
        .frame(
            maxWidth: .infinity
        )
        .background(
            RoundedRectangle(cornerRadius: stylesheet.radii.medium)
                .fill(.white)
                .shadow(radius: 1)
        )
        .padding(
            .horizontal,
            stylesheet.spacing.medium
        )
        .compositingGroup()
    }

    // MARK: - Helper Views

    @ViewBuilder
    private func tabLabel(for tab: Tab, isActive: Bool) -> some View {
        VStack(alignment: .center, spacing: stylesheet.spacing.xs) {
            tabIcon(for: tab, isActive: isActive)

            if let title = tab.title {
                tabTitle(title, isActive: isActive)
            }
        }
        .foregroundStyle(
            isActive ? stylesheet.colors.borderFocused : stylesheet.colors.borderDefault
        )
        .padding(.vertical, stylesheet.spacing.small)
        .frame(maxWidth: .infinity)
        .background {
            if isActive {
                activeTabBackground()
            }
        }
        .scaleEffect(isActive ? 1.05 : 1.0)
    }

    @ViewBuilder
    private func tabIcon(for tab: Tab, isActive: Bool) -> some View {
        Group {
            if isActive, let activeIcon = tab.activeIcon {
                activeIcon
            } else {
                tab.icon
            }
        }
        .foregroundStyle(isActive ? .white : stylesheet.colors.borderDefault)
    }

    @ViewBuilder
    private func tabTitle(_ title: String, isActive: Bool) -> some View {
        Text(title)
            .foregroundStyle(isActive ? .white : stylesheet.colors.borderDefault)
            .font(.system(size: stylesheet.typography.caption2))
            .fontWeight(isActive ? .semibold : .regular)
    }

    private func activeTabBackground() -> some View {
        RoundedRectangle(cornerRadius: stylesheet.radii.small)
            .fill(stylesheet.colors.surfaceDark)
            .matchedGeometryEffect(id: "activeTab", in: namespace)
    }
}

extension LykaTabbar {
    /// Defines the content that is displayed in the tabbarr.
    public struct Tab: Equatable & Identifiable {

        // MARK: - Public Properties

        /// The unique id of the tab.
        public let id = UUID()

        /// The tab title, if any.
        let title: String?

        /// The tab icon.
        let icon: Image

        /// The tab active icon, if any.
        /// - Note: When not set, the `icon` property is used.
        let activeIcon: Image?

        /// The accesibility label of the tab.
        public let accessibilityTitle: String?

        /// The action to execute when tapped.
        public let onTap: () -> Void

        // MARK: - Init

        public init(
            title: String?,
            icon: Image,
            activeIcon: Image? = nil,
            accessibilityTitle: String?,
            onTap: @escaping () -> Void
        ) {
            self.title = title
            self.icon = icon
            self.activeIcon = activeIcon
            self.accessibilityTitle = accessibilityTitle
            self.onTap = onTap
        }

        public static func == (
            lhs: LykaTabbar.Tab,
            rhs: LykaTabbar.Tab
        ) -> Bool {
            lhs.id == rhs.id
        }
    }
}
