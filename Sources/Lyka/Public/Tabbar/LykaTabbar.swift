//
//  LykaTabbar.swift
//  Lyka
//
//  Created by Cole Roberts on 2/8/26.
//

import SwiftUI

// MARK: - LykaTabbar

public struct LykaTabbar<
        TabA: View,
        TabB: View,
        TabC: View,
        TabD: View,
        TabE: View
>: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    /// Namespace for matched geometry effect.
    @Namespace
    private var namespace

    private let tabA: Tab<TabA>
    private let tabB: Tab<TabB>?
    private let tabC: Tab<TabC>?
    private let tabD: Tab<TabD>?
    private let tabE: Tab<TabE>?

    /// The currently active tab.
    @State
    private var activeTabID: UUID

    // MARK: - Init

    @_disfavoredOverload
    public init(
        first tabA: Tab<TabA>,
        second tabB: Tab<TabB>? = nil,
        third tabC: Tab<TabC>? = nil,
        fourth tabD: Tab<TabD>? = nil,
        fifth tabE: Tab<TabE>? = nil
    ) {
        self.tabA = tabA
        self.tabB = tabB
        self.tabC = tabC
        self.tabD = tabD
        self.tabE = tabE
        self._activeTabID = State(initialValue: tabA.id)
    }

    // MARK: - UI

    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTabID) {
                tabA.content
                    .tag(tabA.id)

                if let tabB {
                    tabB.content
                        .tag(tabB.id)
                }

                if let tabC {
                    tabC.content
                        .tag(tabC.id)
                }

                if let tabD {
                    tabD.content
                        .tag(tabD.id)
                }

                if let tabE {
                    tabE.content
                        .tag(tabE.id)
                }
            }
            .tabViewStyle(.automatic)

            VStack {
                Spacer()
                HStack(spacing: 0) {
                    tabButton(for: tabA)

                    if let tabB {
                        tabButton(for: tabB)
                    }

                    if let tabC {
                        tabButton(for: tabC)
                    }

                    if let tabD {
                        tabButton(for: tabD)
                    }

                    if let tabE {
                        tabButton(for: tabE)
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
                .padding(.bottom, 8)
                .compositingGroup()
            }
        }
        .ignoresSafeArea(.keyboard)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func tabButton<Content: View>(
        for tab: Tab<Content>
    ) -> some View {
        let isActive = activeTabID == tab.id

        Button {
            withAnimation(.spring(duration: 0.25)) {
                activeTabID = tab.id
            }
            tab.onTap()
        } label: {
            VStack(alignment: .center, spacing: stylesheet.spacing.xs) {
                Group {
                    if isActive, let activeIcon = tab.activeIcon {
                        activeIcon
                    } else {
                        tab.icon
                    }
                }
                .foregroundStyle(isActive ? .white : stylesheet.colors.borderDefault)

                if let title = tab.title {
                    Text(title)
                        .foregroundStyle(isActive ? .white : stylesheet.colors.borderDefault)
                        .font(.system(size: stylesheet.typography.caption2))
                        .fontWeight(isActive ? .semibold : .regular)
                }
            }
            .foregroundStyle(
                isActive ? stylesheet.colors.borderFocused : stylesheet.colors.borderDefault
            )
            .padding(.vertical, stylesheet.spacing.small)
            .frame(maxWidth: .infinity)
            .background {
                if isActive {
                    RoundedRectangle(cornerRadius: stylesheet.radii.small)
                        .fill(stylesheet.colors.surfaceDark)
                        .matchedGeometryEffect(id: "activeTab", in: namespace)
                }
            }
            .scaleEffect(isActive ? 1.05 : 1.0)
        }
        .contentShape(Rectangle())
    }
}

extension LykaTabbar {
    /// Defines the content that is displayed in the tabbarr.
    public struct Tab<Content: View>: Hashable & Identifiable {

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

        /// The backing view.
        public let content: Content

        /// The action to execute when tapped.
        public let onTap: () -> Void

        // MARK: - Init

        public init(
            title: String?,
            icon: Image,
            activeIcon: Image? = nil,
            accessibilityTitle: String?,
            onTap: @escaping () -> Void,
            @ViewBuilder content: @escaping () -> Content
        ) {
            self.title = title
            self.icon = icon
            self.activeIcon = activeIcon
            self.accessibilityTitle = accessibilityTitle
            self.onTap = onTap
            self.content = content()
        }

        public init(
            title: String?,
            iconSymbolName: String,
            activeIconSymbolName: String? = nil,
            accessibilityTitle: String?,
            onTap: @escaping () -> Void,
            @ViewBuilder content: @escaping () -> Content
        ) {
            var activeIcon: Image? {
                if let activeIconSymbolName {
                    Image(systemName: activeIconSymbolName)
                }

                return nil
            }

            self.init(
                title: title,
                icon: Image(systemName: iconSymbolName),
                activeIcon: activeIcon,
                accessibilityTitle: accessibilityTitle,
                onTap: onTap,
                content: content
            )
        }

        public static func == (
            lhs: LykaTabbar.Tab<Content>,
            rhs: LykaTabbar.Tab<Content>
        ) -> Bool {
            lhs.id == rhs.id
        }

        public func hash(
            into hasher: inout Hasher
        ) {
            hasher.combine(id)
            hasher.finalize()
        }
    }
}

// MARK: - LykaTabbar+Utility

// The following extensions exist purely out of convenience, this allows
// us to pass `nil` values where tabX is `EmptyView`, which makes composing
// a tabbar much simpler. Without this the callsite would need explicitly
// capture `{ EmptyView() }` which sucks.
extension LykaTabbar where TabB == EmptyView,
                            TabC == EmptyView,
                            TabD == EmptyView,
                            TabE == EmptyView {
    public init(
        first tabA: Tab<TabA>
    ) {
        self.init(
            first: tabA,
            second: nil,
            third: nil,
            fourth: nil,
            fifth: nil
        )
    }
}

extension LykaTabbar where TabC == EmptyView,
                            TabD == EmptyView,
                            TabE == EmptyView {
    public init(
        first tabA: Tab<TabA>,
        second tabB: Tab<TabB>
    ) {
        self.init(
            first: tabA,
            second: tabB,
            third: nil,
            fourth: nil,
            fifth: nil
        )
    }
}

extension LykaTabbar where TabD == EmptyView,
                           TabE == EmptyView {
    public init(
        first tabA: Tab<TabA>,
        second tabB: Tab<TabB>,
        third tabC: Tab<TabC>
    ) {
        self.init(
            first: tabA,
            second: tabB,
            third: tabC,
            fourth: nil,
            fifth: nil
        )
    }
}

extension LykaTabbar where TabE == EmptyView {
    public init(
        first tabA: Tab<TabA>,
        second tabB: Tab<TabB>,
        third tabC: Tab<TabC>,
        fourth tabD: Tab<TabD>
    ) {
        self.init(
            first: tabA,
            second: tabB,
            third: tabC,
            fourth: tabD,
            fifth: nil
        )
    }
}


