//
//  LykaCard.swift
//  Lyka
//
//  Created by Cole Roberts on 2/7/26.
//

import AVKit
import SwiftUI

public struct LykaCard<Footer: View>: View {

    // MARK: - Environment

    @Environment(\.stylesheet)
    private var stylesheet

    // MARK: - Private Properties

    /// The media type.
    /// - Note: The default value is `Media.none`.
    private let media: Media

    /// The variant type.
    /// - Note: The default value is `Variant.default`.
    private let variant: Variant

    /// The title of the card.
    private let title: String

    /// The subtitle of the card.
    private let subtitle: String?

    /// The description of the card.
    private let description: String

    /// Custom content displayed below the description.
    private let footer: Footer

    /// The backing view model.
    @Bindable
    private var viewModel = ViewModel()

    // MARK: - Init

    public init(
        media: Media = .none,
        variant: Variant = .default,
        title: String,
        subtitle: String?,
        description: String,
        @ViewBuilder footer: () -> Footer
    ) {
        self.media = media
        self.variant = variant
        self.title = title
        self.subtitle = subtitle
        self.description =  description
        self.footer = footer()
    }

    // MARK: - UI

    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: .zero
        ) {
            switch media {
            case .none:
                EmptyView()
            case .image(let image):
                if variant == .default {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 200)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: stylesheet.radii.medium,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: stylesheet.radii.medium,
                                style: .continuous
                            )
                        )
                }
            case .images(let images):
                ScrollView(.horizontal) {
                    HStack(spacing: .zero) {
                        ForEach(images.indices, id: \.self) { index in
                            images[index]
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                                .containerRelativeFrame(.horizontal)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $viewModel.currentImageIndex)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: stylesheet.radii.medium,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: stylesheet.radii.medium,
                        style: .continuous
                    )
                )
                .overlay(alignment: .bottomTrailing) {
                    if let currentImageIndex = viewModel.currentImageIndex {
                        Text("\(currentImageIndex + 1) / \(images.count)")
                            .contentTransition(.numericText())
                            .animation(.spring, value: viewModel.currentImageIndex)
                            .font(.system(size: stylesheet.typography.caption2))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, stylesheet.spacing.small)
                            .padding(.vertical, stylesheet.spacing.xs)
                            .frame(minWidth: 40)
                            .background(
                                RoundedRectangle(cornerRadius: stylesheet.radii.small)
                                    .fill(.ultraThinMaterial)
                            )
                            .padding(stylesheet.spacing.medium)
                    }
                }
            case .video(let video):
                if let videoPlayer = viewModel.videoPlayer {
                    VideoPlayer(player: videoPlayer)
                        .allowsHitTesting(video.showPlaybackControls)
                        .frame(minHeight: 200)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: stylesheet.radii.medium,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: stylesheet.radii.medium,
                                style: .continuous
                            )
                        )
                }
            }

            VStack(
                alignment: .leading,
                spacing: .zero
            ) {
                Text(title)
                    .font(.system(size: stylesheet.typography.head3))
                    .fontWeight(.medium)
                    .padding(.bottom, stylesheet.spacing.xs)

                if let subtitle {
                    Text(subtitle)
                        .foregroundStyle(stylesheet.colors.borderDefault)
                        .font(.system(size: stylesheet.typography.head4))
                        .padding(.bottom, stylesheet.spacing.large)
                }

                Text(description)
                    .font(.system(size: stylesheet.typography.body))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(stylesheet.spacing.xs + stylesheet.spacing.xxs)

                footer
            }
            .padding(
                stylesheet.spacing.large
            )
        }
        .background(
            background
        )
        .task {
            if case .video(let video) = media {
                let player = AVPlayer(url: video.url)

                if video.autoplay {
                    player.play()
                }

                viewModel.videoPlayer = player
            }
        }
    }

    private var background: some View {
        RoundedRectangle(
            cornerRadius: stylesheet.radii.medium
        )
        .fill(.white)
        .shadow(
            color: stylesheet.colors.borderDefault.opacity(0.5),
            radius: 2.0
        )
    }
}

// MARK: - LykaCard+ViewModel

private extension LykaCard {
    @Observable
    final class ViewModel {
        var videoPlayer: AVPlayer?
        var currentImageIndex: Int? = 0
    }
}

// MARK: - LykaCard+Utility

extension LykaCard where Footer == EmptyView {
    public init(
        media: Media = .none,
        title: String,
        subtitle: String?,
        description: String
    ) {
        self.init(
            media: media,
            title: title,
            subtitle: subtitle,
            description: description,
            footer: { EmptyView() }
        )
    }
}


// MARK: - LykaCard+Variant

extension LykaCard {
    public enum Variant {
        /// The default card style.
        case `default`
    }
}

// MARK: - LykaCard.Media

extension LykaCard {
    /// The media type, if any.
    public enum Media {
        case none

        /// The card contains an image.
        case image(Image)

        /// The card contains multiple images.
        case images([Image])

        /// The card contains a video from a url.
        case video(Video)
    }
}

// MARK: - LykaCard.Media+Video

extension LykaCard.Media {
    /// The media type, if any.
    public struct Video {
        /// The video URL.
        let url: URL

        /// Whether video playback begins automatically.
        /// - Note: The default value is `true`.
        let autoplay: Bool

        /// Whether playback controls are visible.
        /// - Note: The default value is `true`.
        /// The card contains a video from a url.
        let showPlaybackControls: Bool

        public init(
            url: URL,
            autoplay: Bool = true,
            showPlaybackControls: Bool = true
        ) {
            self.url = url
            self.autoplay = autoplay
            self.showPlaybackControls = showPlaybackControls
        }
    }
}
