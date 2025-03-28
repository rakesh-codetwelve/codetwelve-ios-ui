//
//  CTVideo.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI
import AVFoundation
import Combine

/// A customizable video player component.
///
/// `CTVideo` provides a consistent video player interface throughout your application
/// with support for different controls, sizes, and customization options.
///
/// # Example
///
/// ```swift
/// // Basic usage with a URL
/// CTVideo(url: URL(string: "https://example.com/video.mp4")!)
///
/// // With custom controls and auto-play
/// CTVideo(
///     url: URL(string: "https://example.com/video.mp4")!,
///     autoPlay: true,
///     showControls: true,
///     controlsStyle: .overlay
/// )
/// ```
public struct CTVideo: View {
    // MARK: - Public Properties
    
    /// The style of video player controls.
    public enum ControlsStyle {
        /// Controls overlay on top of the video.
        case overlay
        /// Controls at the bottom of the video.
        case bottom
        /// Minimal controls with just essential buttons.
        case minimal
        /// Custom controls layout.
        case custom
    }
    
    /// The fit mode for the video.
    public enum VideoFit {
        /// Fill the available space, potentially cropping the video.
        case fill
        /// Fit within the available space, potentially showing letterbox.
        case fit
    }
    
    /// The current state of the video playback.
    public enum PlaybackState: Equatable {
        /// Video is loading.
        case loading
        /// Video is playing.
        case playing
        /// Video is paused.
        case paused
        /// Video has ended.
        case ended
        /// An error occurred during playback.
        case error(Error)
        
        public static func == (lhs: CTVideo.PlaybackState, rhs: CTVideo.PlaybackState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading), (.playing, .playing), (.paused, .paused), (.ended, .ended):
                return true
            case (.error(let lhsError), .error(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let url: URL?
    private let assetResourceLoaderDelegate: AVAssetResourceLoaderDelegate?
    private let videoFit: VideoFit
    private let autoPlay: Bool
    private let loop: Bool
    private let showControls: Bool
    private let controlsStyle: ControlsStyle
    private let showsPlaybackProgress: Bool
    private let aspectRatio: CGFloat?
    private let muted: Bool
    private let posterURL: URL?
    private let onPlaybackStateChanged: ((PlaybackState) -> Void)?
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    
    /// The video player view model.
    @StateObject private var viewModel: CTVideoViewModel
    
    /// The current theme from the environment.
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a video player with a URL.
    /// - Parameters:
    ///   - url: The URL of the video to play.
    ///   - assetResourceLoaderDelegate: Optional delegate for custom resource loading.
    ///   - videoFit: How the video should fit in the available space.
    ///   - autoPlay: Whether to automatically start playing when the view appears.
    ///   - loop: Whether to loop the video when it ends.
    ///   - showControls: Whether to show playback controls.
    ///   - controlsStyle: The style of the playback controls.
    ///   - showsPlaybackProgress: Whether to show a progress bar.
    ///   - aspectRatio: Optional fixed aspect ratio for the video container.
    ///   - muted: Whether the video should be muted.
    ///   - posterURL: Optional URL for a poster image to show before playback begins.
    ///   - onPlaybackStateChanged: Optional callback for when the playback state changes.
    ///   - accessibilityLabel: Optional accessibility label.
    ///   - accessibilityHint: Optional accessibility hint.
    public init(
        url: URL,
        assetResourceLoaderDelegate: AVAssetResourceLoaderDelegate? = nil,
        videoFit: VideoFit = .fit,
        autoPlay: Bool = false,
        loop: Bool = false,
        showControls: Bool = true,
        controlsStyle: ControlsStyle = .overlay,
        showsPlaybackProgress: Bool = true,
        aspectRatio: CGFloat? = nil,
        muted: Bool = false,
        posterURL: URL? = nil,
        onPlaybackStateChanged: ((PlaybackState) -> Void)? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil
    ) {
        self.url = url
        self.assetResourceLoaderDelegate = assetResourceLoaderDelegate
        self.videoFit = videoFit
        self.autoPlay = autoPlay
        self.loop = loop
        self.showControls = showControls
        self.controlsStyle = controlsStyle
        self.showsPlaybackProgress = showsPlaybackProgress
        self.aspectRatio = aspectRatio
        self.muted = muted
        self.posterURL = posterURL
        self.onPlaybackStateChanged = onPlaybackStateChanged
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        
        // Initialize view model
        _viewModel = StateObject(wrappedValue: CTVideoViewModel(
            url: url,
            assetResourceLoaderDelegate: assetResourceLoaderDelegate,
            autoPlay: autoPlay,
            loop: loop,
            muted: muted
        ))
    }
    
    /// Initialize a video player with an AVPlayer.
    /// - Parameters:
    ///   - player: The AVPlayer instance to use.
    ///   - videoFit: How the video should fit in the available space.
    ///   - showControls: Whether to show playback controls.
    ///   - controlsStyle: The style of the playback controls.
    ///   - showsPlaybackProgress: Whether to show a progress bar.
    ///   - aspectRatio: Optional fixed aspect ratio for the video container.
    ///   - onPlaybackStateChanged: Optional callback for when the playback state changes.
    ///   - accessibilityLabel: Optional accessibility label.
    ///   - accessibilityHint: Optional accessibility hint.
    public init(
        player: AVPlayer,
        videoFit: VideoFit = .fit,
        showControls: Bool = true,
        controlsStyle: ControlsStyle = .overlay,
        showsPlaybackProgress: Bool = true,
        aspectRatio: CGFloat? = nil,
        onPlaybackStateChanged: ((PlaybackState) -> Void)? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil
    ) {
        self.url = nil
        self.assetResourceLoaderDelegate = nil
        self.videoFit = videoFit
        self.autoPlay = false
        self.loop = false
        self.showControls = showControls
        self.controlsStyle = controlsStyle
        self.showsPlaybackProgress = showsPlaybackProgress
        self.aspectRatio = aspectRatio
        self.muted = player.isMuted
        self.posterURL = nil
        self.onPlaybackStateChanged = onPlaybackStateChanged
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        
        // Initialize view model with existing player
        _viewModel = StateObject(wrappedValue: CTVideoViewModel(player: player))
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            mainContent
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .background(Color.black)
                .modifier(AspectRatioModifier(aspectRatio: aspectRatio, videoFit: videoFit))
                .onAppear {
                    viewModel.onAppear()
                }
                .onDisappear {
                    viewModel.onDisappear()
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(accessibilityLabel ?? "Video player")
                .accessibilityHint(accessibilityHint ?? "Double tap to play or pause")
                .accessibilityAddTraits(.startsMediaSession)
                .accessibilityAddTraits(.allowsDirectInteraction)
        }
    }
    
    // MARK: - Private Views
    
    private var mainContent: some View {
        ZStack {
            // Video player
            videoPlayerView
            
            // Poster image (shown before playback starts)
            if let posterURL = posterURL, viewModel.playbackState == .loading {
                posterImageView
            }
            
            // Loading indicator
            if viewModel.isBuffering && !isErrorState(viewModel.playbackState) {
                loadingView
            }
            
            // Controls
            if showControls {
                controlsView
            }
            
            // Error overlay
            if case .error = viewModel.playbackState {
                errorView
            }
        }
    }
    
    @ViewBuilder
    private var videoPlayerView: some View {
        CTVideoPlayerView(player: viewModel.player)
            .aspectRatio(contentMode: videoFit == .fill ? .fill : .fit)
            .ctAnimation(.easeInOut(duration: 0.3), value: viewModel.player)
    }
    
    @ViewBuilder
    private var posterImageView: some View {
        CTImage(url: posterURL, contentMode: videoFit == .fill ? .fill : .fit)
            .opacity(viewModel.isBuffering ? 0 : 1)
            .ctAnimation(.easeInOut(duration: 0.3), value: viewModel.isBuffering)
    }
    
    @ViewBuilder
    private var loadingView: some View {
        ZStack {
            Color.black.opacity(0.3)
            CTProgress(style: .circular, color: .white)
        }
    }
    
    @ViewBuilder
    private var controlsView: some View {
        Group {
            switch controlsStyle {
            case .overlay:
                overlayControlsView
            case .bottom:
                bottomControlsView
            case .minimal:
                minimalControlsView
            case .custom:
                customControlsView
            }
        }
        .opacity(viewModel.showControls ? 1 : 0)
        .ctAnimation(.easeInOut(duration: 0.2), value: viewModel.showControls)
    }
    
    @ViewBuilder
    private var overlayControlsView: some View {
        ZStack {
            // Background gradient for better text visibility
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.7),
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack {
                Spacer()
                
                // Bottom controls bar
                HStack {
                    // Play/Pause Button
                    Button(action: viewModel.togglePlayPause) {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 18))
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .foregroundColor(.white)
                    .accessibilityLabel(viewModel.isPlaying ? "Pause" : "Play")
                    
                    // Current time
                    if showsPlaybackProgress {
                        Text(viewModel.currentTimeFormatted)
                            .font(.caption)
                            .foregroundColor(.white)
                            .monospacedDigit()
                        
                        // Progress slider
                        Slider(
                            value: $viewModel.currentTime,
                            in: 0...max(viewModel.duration, 1),
                            onEditingChanged: viewModel.progressSliderChanged
                        )
                        .accentColor(.white)
                        .accessibilityLabel("Playback position")
                        
                        // Duration
                        Text(viewModel.durationFormatted)
                            .font(.caption)
                            .foregroundColor(.white)
                            .monospacedDigit()
                    }
                    
                    // Mute Button
                    Button(action: viewModel.toggleMute) {
                        Image(systemName: viewModel.isMuted ? "speaker.slash.fill" : "speaker.fill")
                            .font(.system(size: 18))
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .foregroundColor(.white)
                    .accessibilityLabel(viewModel.isMuted ? "Unmute" : "Mute")
                    
                    // Fullscreen Button
                    Button(action: viewModel.toggleFullscreen) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.system(size: 18))
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .foregroundColor(.white)
                    .accessibilityLabel("Toggle fullscreen")
                }
                .padding()
                .background(Color.black.opacity(0.4))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleControls()
        }
    }
    
    @ViewBuilder
    private var bottomControlsView: some View {
        VStack {
            Spacer()
            
            // Bottom controls bar
            VStack(spacing: CTSpacing.xs) {
                // Progress bar
                if showsPlaybackProgress {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 4)
                            
                            // Buffered progress
                            Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: geometry.size.width * viewModel.bufferedProgress, height: 4)
                            
                            // Playback progress
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * viewModel.progress, height: 4)
                            
                            // Drag handle
                            Circle()
                                .fill(Color.white)
                                .frame(width: 12, height: 12)
                                .offset(x: max(0, min(geometry.size.width * viewModel.progress - 6, geometry.size.width - 12)))
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let progress = value.location.x / geometry.size.width
                                    viewModel.scrubToProgress(progress: max(0, min(1, progress)))
                                }
                                .onEnded { _ in
                                    viewModel.finishScrubbing()
                                }
                        )
                    }
                    .frame(height: 24)
                    .padding(.horizontal)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Playback progress")
                    .accessibilityValue("\(Int(viewModel.progress * 100))%")
                }
                
                // Time and controls
                HStack {
                    // Current time
                    if showsPlaybackProgress {
                        Text(viewModel.currentTimeFormatted)
                            .font(.caption)
                            .foregroundColor(.white)
                            .monospacedDigit()
                            .frame(width: 45, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    // Rewind 10s
                    Button(action: { viewModel.seek(by: -10) }) {
                        Image(systemName: "gobackward.10")
                            .font(.system(size: 18))
                            .frame(width: 40, height: 40)
                            .contentShape(Rectangle())
                    }
                    .foregroundColor(.white)
                    .accessibilityLabel("Rewind 10 seconds")
                    
                    // Play/Pause
                    Button(action: viewModel.togglePlayPause) {
                        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 40))
                            .frame(width: 50, height: 50)
                            .contentShape(Rectangle())
                    }
                    .foregroundColor(.white)
                    .accessibilityLabel(viewModel.isPlaying ? "Pause" : "Play")
                    
                    // Forward 10s
                    Button(action: { viewModel.seek(by: 10) }) {
                        Image(systemName: "goforward.10")
                            .font(.system(size: 18))
                            .frame(width: 40, height: 40)
                            .contentShape(Rectangle())
                    }
                    .foregroundColor(.white)
                    .accessibilityLabel("Forward 10 seconds")
                    
                    Spacer()
                    
                    // Duration
                    if showsPlaybackProgress {
                        Text(viewModel.durationFormatted)
                            .font(.caption)
                            .foregroundColor(.white)
                            .monospacedDigit()
                            .frame(width: 45, alignment: .trailing)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, CTSpacing.s)
            }
            .background(Color.black.opacity(0.6))
            .cornerRadius(CTSpacing.xs)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleControls()
        }
    }
    
    @ViewBuilder
    private var minimalControlsView: some View {
        // Large play/pause button in the center
        Button(action: viewModel.togglePlayPause) {
            Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.system(size: 72))
                .opacity(viewModel.isPlaying ? 0.7 : 1.0)
        }
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
        .accessibilityLabel(viewModel.isPlaying ? "Pause" : "Play")
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleControls()
        }
    }
    
    @ViewBuilder
    private var customControlsView: some View {
        // Placeholder for custom controls
        // In a real implementation, this would be customizable via a viewBuilder parameter
        overlayControlsView
    }
    
    @ViewBuilder
    private var errorView: some View {
        VStack(spacing: CTSpacing.m) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
            
            if case let .error(error) = viewModel.playbackState {
                Text("Error: \(error.localizedDescription)")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
            } else {
                Text("An error occurred during playback")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
            }
            
            Button("Retry") {
                viewModel.retry()
            }
            .foregroundColor(.white)
            .padding(.horizontal, CTSpacing.m)
            .padding(.vertical, CTSpacing.s)
            .background(Color.gray.opacity(0.6))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(16)
    }
    
    // Helper to check if state is error
    private func isErrorState(_ state: CTVideo.PlaybackState) -> Bool {
        if case .error = state {
            return true
        }
        return false
    }
}

// MARK: - Video Player View

/// A SwiftUI wrapper for AVPlayerLayer.
private struct CTVideoPlayerView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.player = player
            playerLayer.frame = uiView.bounds
        }
    }
}

// MARK: - Video Player ViewModel

/// The view model for the video player component.
class CTVideoViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// The current player instance.
    @Published var player: AVPlayer
    
    /// Whether the video is currently playing.
    @Published var isPlaying: Bool = false
    
    /// Whether the video is currently buffering.
    @Published var isBuffering: Bool = false
    
    /// The current playback state.
    @Published var playbackState: CTVideo.PlaybackState = .loading
    
    /// The current playback time in seconds.
    @Published var currentTime: Double = 0
    
    /// The total duration of the video in seconds.
    @Published var duration: Double = 0
    
    /// Whether the controls are currently visible.
    @Published var showControls: Bool = true
    
    /// Whether the video is muted.
    @Published var isMuted: Bool = false
    
    /// Whether the video is in fullscreen mode.
    @Published var isFullscreen: Bool = false
    
    /// The buffered progress of the video (0.0 to 1.0).
    @Published var bufferedProgress: Double = 0
    
    // MARK: - Private Properties
    
    private var playerItemContext = 0
    private var timeObserver: Any?
    private var statusObserver: NSKeyValueObservation?
    private var bufferObserver: NSKeyValueObservation?
    private var isSeekInProgress = false
    private var hideControlsTask: DispatchWorkItem?
    private var url: URL?
    private var shouldAutoPlay: Bool
    private var shouldLoop: Bool
    private var cancellables = Set<AnyCancellable>()
    private var assetResourceLoaderDelegate: AVAssetResourceLoaderDelegate?
    
    // MARK: - Computed Properties
    
    /// The formatted current time string.
    var currentTimeFormatted: String {
        formatTime(seconds: currentTime)
    }
    
    /// The formatted duration string.
    var durationFormatted: String {
        formatTime(seconds: duration)
    }
    
    /// The playback progress as a fraction (0.0 to 1.0).
    var progress: Double {
        duration > 0 ? currentTime / duration : 0
    }
    
    // MARK: - Initialization
    
    /// Initialize with a URL.
    /// - Parameters:
    ///   - url: The URL of the video to play.
    ///   - assetResourceLoaderDelegate: Optional delegate for custom resource loading.
    ///   - autoPlay: Whether to automatically start playing when the view appears.
    ///   - loop: Whether to loop the video when it ends.
    ///   - muted: Whether the video should be muted.
    init(
        url: URL,
        assetResourceLoaderDelegate: AVAssetResourceLoaderDelegate? = nil,
        autoPlay: Bool = false,
        loop: Bool = false,
        muted: Bool = false
    ) {
        self.url = url
        self.assetResourceLoaderDelegate = assetResourceLoaderDelegate
        self.shouldAutoPlay = autoPlay
        self.shouldLoop = loop
        
        // Create an AVPlayer with the URL
        let asset = AVURLAsset(url: url)
        if let delegate = assetResourceLoaderDelegate {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if let scheme = components?.scheme, scheme == "streaming" {
                // Custom scheme requires resource loader delegate
                asset.resourceLoader.setDelegate(delegate, queue: DispatchQueue.main)
            }
        }
        
        let playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        self.player.isMuted = muted
        self.isMuted = muted
        
        setupObservers()
    }
    
    /// Initialize with an existing AVPlayer.
    /// - Parameter player: The AVPlayer instance to use.
    init(player: AVPlayer) {
        self.player = player
        self.shouldAutoPlay = false
        self.shouldLoop = false
        self.isMuted = player.isMuted
        
        setupObservers()
    }
    
    deinit {
        cleanup()
    }
    
    // MARK: - Public Methods
    
    /// Called when the view appears.
    func onAppear() {
        resetHideControlsTimer()
        
        if shouldAutoPlay {
            play()
        }
    }
    
    /// Called when the view disappears.
    func onDisappear() {
        pause()
        cleanup()
    }
    
    /// Toggle play/pause.
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
        resetHideControlsTimer()
    }
    
    /// Toggle mute.
    func toggleMute() {
        isMuted.toggle()
        player.isMuted = isMuted
        resetHideControlsTimer()
    }
    
    /// Toggle fullscreen.
    func toggleFullscreen() {
        isFullscreen.toggle()
        resetHideControlsTimer()
    }
    
    /// Toggle controls visibility.
    func toggleControls() {
        showControls.toggle()
        resetHideControlsTimer()
    }
    
    /// Seek to a specific progress (0.0 to 1.0).
    /// - Parameter progress: The progress to seek to.
    func scrubToProgress(progress: Double) {
        isSeekInProgress = true
        let targetTime = duration * progress
        currentTime = targetTime
        resetHideControlsTimer()
    }
    
    /// Called when the user finishes dragging the progress slider.
    func finishScrubbing() {
        seek(to: currentTime)
        isSeekInProgress = false
    }
    
    /// Called when the user changes the progress slider.
    /// - Parameter isEditing: Whether the user is currently editing the slider.
    func progressSliderChanged(isEditing: Bool) {
        if !isEditing {
            finishScrubbing()
        }
        resetHideControlsTimer()
    }
    
    /// Seek to a specific time.
    /// - Parameter time: The time in seconds to seek to.
    func seek(to time: Double) {
        let targetTime = CMTime(seconds: max(0, min(time, duration)), preferredTimescale: 600)
        player.seek(to: targetTime) { [weak self] finished in
            if finished {
                self?.isSeekInProgress = false
            }
        }
        resetHideControlsTimer()
    }
    
    /// Seek by a relative amount of time.
    /// - Parameter seconds: The number of seconds to seek by (negative to rewind).
    func seek(by seconds: Double) {
        let targetTime = currentTime + seconds
        seek(to: targetTime)
    }
    
    /// Retry playback after an error.
    func retry() {
        guard let url = url else { return }
        
        // Recreate the player
        let asset = AVURLAsset(url: url)
        if let delegate = assetResourceLoaderDelegate {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if let scheme = components?.scheme, scheme == "streaming" {
                asset.resourceLoader.setDelegate(delegate, queue: DispatchQueue.main)
            }
        }
        
        let playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
        
        // Reset state
        playbackState = .loading
        currentTime = 0
        duration = 0
        bufferedProgress = 0
        
        if shouldAutoPlay {
            play()
        }
    }
    
    // MARK: - Private Methods
    
    /// Play the video.
    private func play() {
        player.play()
        isPlaying = true
        playbackState = .playing
    }
    
    /// Pause the video.
    private func pause() {
        player.pause()
        isPlaying = false
        playbackState = .paused
    }
    
    /// Set up the necessary observers.
    private func setupObservers() {
        // Observe playback time
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self, !self.isSeekInProgress else { return }
            
            self.currentTime = time.seconds
            
            // Update duration if needed
            if self.duration == 0, let currentItem = self.player.currentItem, currentItem.status == .readyToPlay {
                self.duration = currentItem.duration.seconds
            }
            
            // Check if video has ended
            if self.currentTime >= self.duration && self.duration > 0 {
                self.handleVideoEnd()
            }
        }
        
        // Observe player item status
        statusObserver = player.currentItem?.observe(\.status, options: [.new]) { [weak self] playerItem, _ in
            guard let self = self else { return }
            
            switch playerItem.status {
            case .readyToPlay:
                self.duration = playerItem.duration.seconds
                self.isBuffering = false
                self.playbackState = self.isPlaying ? .playing : .paused
                
                // Start playing automatically if set
                if self.shouldAutoPlay && !self.isPlaying {
                    self.play()
                }
                
            case .failed:
                self.playbackState = .error(playerItem.error ?? NSError(domain: "CTVideo", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                self.isBuffering = false
                
            case .unknown:
                self.isBuffering = true
                self.playbackState = .loading
                
            @unknown default:
                break
            }
        }
        
        // Observe buffering
        bufferObserver = player.currentItem?.observe(\.loadedTimeRanges, options: [.new]) { [weak self] playerItem, _ in
            guard let self = self else { return }
            
            // Update buffered progress
            if let timeRange = playerItem.loadedTimeRanges.first?.timeRangeValue {
                let bufferedSeconds = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
                self.bufferedProgress = self.duration > 0 ? bufferedSeconds / self.duration : 0
            }
            
            // Check if buffering
            if playerItem.isPlaybackLikelyToKeepUp {
                self.isBuffering = false
            } else {
                self.isBuffering = true
            }
        }
        
        // Observe when item finishes playing
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                self?.handleVideoEnd()
            }
            .store(in: &cancellables)
    }
    
    /// Handle the end of video playback.
    private func handleVideoEnd() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isPlaying = false
            self.playbackState = .ended
            
            // Loop if needed
            if self.shouldLoop {
                self.seek(to: 0)
                self.play()
            }
        }
    }
    
    /// Clean up resources.
    private func cleanup() {
        // Remove time observer
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        
        // Remove status observer
        statusObserver?.invalidate()
        statusObserver = nil
        
        // Remove buffer observer
        bufferObserver?.invalidate()
        bufferObserver = nil
        
        // Cancel hide controls timer
        hideControlsTask?.cancel()
        hideControlsTask = nil
        
        // Cancel publishers
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    /// Format time in seconds to a string.
    /// - Parameter seconds: The time in seconds.
    /// - Returns: A formatted time string (e.g., "01:23").
    private func formatTime(seconds: Double) -> String {
        guard !seconds.isNaN, !seconds.isInfinite else { return "00:00" }
        
        let totalSeconds = Int(max(0, seconds))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    /// Reset the timer that hides controls after a period of inactivity.
    private func resetHideControlsTimer() {
        // Cancel existing timer
        hideControlsTask?.cancel()
        
        // Show controls
        showControls = true
        
        // Create new timer
        hideControlsTask = DispatchWorkItem { [weak self] in
            DispatchQueue.main.async {
                self?.showControls = false
            }
        }
        
        // Schedule timer
        if let task = hideControlsTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: task)
        }
    }
}

// MARK: - Supporting Types

private struct AspectRatioModifier: ViewModifier {
    let aspectRatio: CGFloat?
    let videoFit: CTVideo.VideoFit
    
    func body(content: Content) -> some View {
        if let ratio = aspectRatio {
            content.aspectRatio(ratio, contentMode: videoFit == .fill ? .fill : .fit)
        } else {
            content
        }
    }
}

// MARK: - Previews

struct CTVideo_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Note: These previews will not actually play videos in the canvas
            VStack {
                Text("Basic Video Player").ctHeading2()
                CTVideo(url: URL(string: "https://example.com/video.mp4")!)
                    .frame(height: 200)
            }
            .padding()
            .previewDisplayName("Basic Video")
            
            VStack {
                Text("Video with Controls").ctHeading2()
                CTVideo(
                    url: URL(string: "https://example.com/video.mp4")!,
                    videoFit: .fill,
                    autoPlay: true,
                    showControls: true,
                    controlsStyle: .overlay
                )
                .frame(height: 200)
            }
            .padding()
            .previewDisplayName("With Controls")
            
            VStack {
                Text("Video with Minimal Controls").ctHeading2()
                CTVideo(
                    url: URL(string: "https://example.com/video.mp4")!,
                    controlsStyle: .minimal
                )
                .frame(height: 200)
            }
            .padding()
            .previewDisplayName("Minimal Controls")
            
            VStack {
                Text("Video with Fixed Aspect Ratio").ctHeading2()
                CTVideo(
                    url: URL(string: "https://example.com/video.mp4")!,
                    aspectRatio: 16/9
                )
                .frame(height: 200)
            }
            .padding()
            .previewDisplayName("Fixed Aspect Ratio")
        }
    }
}