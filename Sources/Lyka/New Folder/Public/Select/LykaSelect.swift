//
//  LykaSelect.swift
//  Lyka
//
//  Created by Cole Roberts on 2/5/26.
//

import SwiftUI

// MARK: - LykaSelect

public struct LykaSelect: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    @Bindable
    private var viewModel = ViewModel()

    // MARK: - Binding

    /// The binding text.
    private let selection: Binding<String>

    /// The placeholder to display.
    private let placeholder: String

    /// The available options.
    private let options: [Option]

    /// The current configuration.
    private let configuration: Configuration

    // MARK: - Computed

    private var sheetHeight: CGFloat {
        let searchHeight = 48.0
        return options.count > 8 ? (48.0 * 7.0) + searchHeight : 48.0 * CGFloat(options.count)
    }

    private var displayedOptions: [Option] {
        guard !viewModel.query.isEmpty else {
            return options.sorted(by: <)
        }

        return options.filter {
            $0.title.lowercased().contains(viewModel.query.lowercased())
        }
        .sorted(by: >)
    }

    // MARK: - Init

    public init(
        selection: Binding<String>,
        placeholder: String,
        options: [Option],
        configure: (inout Configuration) -> Void = { _ in }
    ) {
        self.selection = selection
        self.placeholder = placeholder
        self.options = options

        var configuration = Configuration()
        configure(&configuration)
        self.configuration = configuration
    }

    // MARK: - UI

    public var body: some View {
        ZStack {
            LykaTextField(
                text: selection,
                placeholder: placeholder,
            )
            .disabled(true)
        }
        .overlay(alignment: .trailing) {
            Image(systemName: "chevron.down")
                .font(.system(size: stylesheet.typography.caption))
                .fontWeight(.semibold)
                .rotationEffect(viewModel.isPresentingSheet ? .degrees(180) : .init(degrees: .zero))
                .padding(
                    .trailing,
                    stylesheet.spacing.medium
                )
                .animation(.smooth, value: viewModel.isPresentingSheet)
        }
        .sheet(isPresented: $viewModel.isPresentingSheet) {
            VStack(spacing: .zero) {
                VStack(spacing: .zero) {
                    Text(placeholder)
                        .padding(.top, stylesheet.spacing.xxl)
                        .padding(.horizontal, stylesheet.spacing.large)
                        .fontWeight(.semibold)

                    let search = LykaTextField(
                        text: $viewModel.query,
                        placeholder: "Search",
                        configure: { $0.displayClearOnTextEntry = true }
                    )
                    .padding(.top, stylesheet.spacing.medium)
                    .padding(.horizontal, stylesheet.spacing.medium)
                    .padding(.bottom, stylesheet.spacing.large)

                    switch configuration.searchVisibility {
                    case .always:
                        search
                    case .automatic:
                        if options.count > 6 {
                            search
                        }
                    case .never:
                        Spacer()
                            .frame(height: stylesheet.spacing.large)
                    }

                    Divider()
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(displayedOptions.enumerated()), id: \.element.id) { index, option in
                            let isSelected = selection.wrappedValue == option.title

                            Text(option.title)
                                .id(option.title)
                                .font(.system(size: stylesheet.typography.body))
                                .fontWeight(
                                    isSelected ? .semibold : .regular
                                )
                                .foregroundStyle(
                                    isSelected ? Color.blue : .black
                                )
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                .frame(
                                    height: 48.0
                                )
                                .contentShape(
                                    Rectangle()
                                )
                                .onTapGesture {
                                    selection.wrappedValue = option.title
                                    viewModel.isPresentingSheet = false
                                }
                                .padding(
                                    .horizontal,
                                    stylesheet.spacing.large
                                )

                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $viewModel.scrollID, anchor: .center)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .presentationDetents([.height(sheetHeight)])
            .presentationBackground(.regularMaterial)
            .presentationDragIndicator(.visible)
        }
        .contentShape(
            .rect
        )
        .onTapGesture {
            viewModel.isPresentingSheet = true
        }
    }
}

// MARK: - LykaSelect+Option

extension LykaSelect {
    public struct Option: Comparable, ExpressibleByStringLiteral {
        /// A unique identifier for the option.
        let id = UUID()

        /// The option title.
        public let title: String

        public init(
            title: String
        ) {
            self.title = title
        }

        public static func < (
            lhs: LykaSelect.Option,
            rhs: LykaSelect.Option
        ) -> Bool {
            lhs.title < rhs.title
        }

        public init(stringLiteral value: StringLiteralType) {
            self.title = value
        }
    }
}

// MARK: - LykaSelect+Configuration

extension LykaSelect {
    public struct Configuration {
        /// The current search visibility.
        /// - Note: The default value is `automatic`.
        public var searchVisibility: SearchVisibility

        public init(
            searchVisibility: SearchVisibility = .automatic
        ) {
            self.searchVisibility = searchVisibility
        }
    }
}

// MARK: - LykaSelect+SearchVisibility

extension LykaSelect {
    /// The current search visibility behavior.
    public enum SearchVisibility {
        /// The search bar is shown automatically, i.e.
        /// when the number of options is greater than 6.
        case automatic

        /// The search bar is always shown.
        case always

        /// The search bar is never shown.
        case never
    }
}

// MARK: - LykaSelect+ViewModel

private extension LykaSelect {
    /// The observable view model that drives each `LykaSelect` instance.
    @Observable
    final class ViewModel {
        /// Whether the primary sheet is being displayed.
        var isPresentingSheet: Bool = false

        /// The current search query.
        var query = ""

        /// The current scroll id - this is updated on scroll.
        var scrollID: String?
    }
}
