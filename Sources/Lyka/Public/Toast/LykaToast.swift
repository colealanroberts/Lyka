//
//  Toast.swift
//  Lyka
//
//  Created by Cole Roberts on 2/8/26.
//

import Combine
import Foundation
import SwiftUI

// MARK: - LykaToast

public struct LykaToast: Identifiable {
    /// The id  of the toast.
    public let id = UUID()

    /// The title of the toast.
    public let title: String

    /// The close action, if any.
    public internal(set) var closeAction: ((ID) -> Void)?

    // MARK: - Init

    public init(
        title: String,
        closeAction: ((ID) -> Void)? = nil
    ) {
        self.title = title
        self.closeAction = closeAction
    }
}

// MARK: - ObservableStorage

protocol ObservableStorage {
    /// The type of element to store.
    /// - Note: The usage of `Identifiable` ensures that the internal
    /// storage mechanism can insert `element.id` into a dictionary, later retrieiving it.
    /// For this reason, each `id` must be unique, considering using a `UUID`.
    associatedtype Element: Identifiable

    /// The backing storage array.
    var storage: [Element] { get set }

    /// Adds an element to storage.
    func add(_ element: Element)

    /// Removes an element from storage.
    func remove(_ id: Element.ID)
}

// MARK: - LykaToastPresenter

/// A class that manges lifetime and presentation of a `Toast`.

@Observable
public final class LykaToastPresenter: ObservableStorage {

    // MARK: - Public Properties

    public internal(set) var storage = [LykaToast]()

    // MARK: - Private Properties

    /// The maximm number of toasts to display at a given time.
    @ObservationIgnored
    private lazy var timers = [LykaToast.ID: AnyCancellable]()

    /// The associated configuration (`Configuration`).
    private let configuration: Configuration

    // MARK: - Init

    public init(
        configure: (inout Configuration) -> Void = { _ in }
    ) {
        var copy = Configuration()
        configure(&copy)
        self.configuration = copy
    }

    // MARK: - Public Methods

    func add(
        _ toast: LykaToast
    ) {
        removeFirstIfNecesssary()

        var copy = toast

        /// Modify our existing close action to include the removal from our
        /// backing storage when tapped, automatically trigger a SwiftUI render pass.
        copy.closeAction = { [weak self] id in
            toast.closeAction?(id)
            self?.remove(id)
        }

        withAnimation(.spring) { [weak self] in
            self?.storage.append(copy)
        }

        let timer = Timer.publish(
            every: 3.0,
            on: .main,
            in: .common
        )
        .autoconnect()
        .first()
        .sink { [weak self] _ in
            self?.remove(copy.id)
        }

        timers[copy.id] = timer
    }

    func remove(
        _ id: UUID
    ) {
        guard let index = storage.firstIndex(where: { $0.id == id }) else { return }

        let snackbar = storage[index]
        let timer = timers[id].take()
        timer?.cancel()

        withAnimation(.spring) { [weak self] in
            _ = self?.storage.remove(at: index)
        }
    }

    func transition(
        for toast: LykaToast
    ) -> AnyTransition {
        configuration.transition
    }

    // MARK: - Private Properties

    private func removeFirstIfNecesssary() {
        guard let first = storage.first else {
            return
        }

        withAnimation(.spring) {
            remove(first.id)
        }
    }
}

// MARK: - LykaToastPresenter+Configuration

extension LykaToastPresenter {
    public struct Configuration {
        /// The maximum number of snacks to display at a given time.
        /// - Note: Defaults to `1`
        public var limit: Int

        /// The default animation for snacks.
        /// - Note: The default transition is `.opacity` combined with `.move`.
        public var transition: AnyTransition

        public init(
            limit: Int = 1,
            transition: AnyTransition = .opacity.combined(with: .move(edge: .bottom))
        ) {
            self.limit = limit
            self.transition = transition
        }
    }
}

// MARK: - LykaToastPresenter+Util

extension LykaToastPresenter {
    /// A utility operator that allows a caller to write
    /// ```
    /// toastPresenter += Toast(...)
    /// ```
    public static func +=(presenter: LykaToastPresenter, toast: LykaToast) {
        presenter.add(toast)
    }
}
