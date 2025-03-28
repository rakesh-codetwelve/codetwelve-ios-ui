//
//  CTVideoTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
import AVFoundation
@testable import CodetwelveUI

final class CTVideoTests: XCTestCase {
    
    // MARK: - Test Properties
    
    var testURL: URL!
    
    // MARK: - Test Setup and Teardown
    
    override func setUp() {
        super.setUp()
        
        // Create a test URL for a local resource bundle
        testURL = Bundle.module.url(forResource: "test_video", withExtension: "mp4") ?? URL(string: "https://example.com/video.mp4")!
    }
    
    override func tearDown() {
        testURL = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testVideoInitialization() {
        // Test initialization with URL
        let videoView = CTVideo(url: testURL)
        
        // Verify the view has been created
        XCTAssertNotNil(videoView)
        
        // Create a test AVPlayer
        let player = AVPlayer(url: testURL)
        
        // Test initialization with AVPlayer
        let videoViewWithPlayer = CTVideo(player: player)
        
        // Verify the view has been created
        XCTAssertNotNil(videoViewWithPlayer)
    }
    
    func testVideoWithCustomConfiguration() {
        // Test with custom configuration
        let videoView = CTVideo(
            url: testURL,
            videoFit: .fill,
            autoPlay: true,
            loop: true,
            showControls: true,
            controlsStyle: .overlay,
            showsPlaybackProgress: true,
            aspectRatio: 16/9,
            muted: true,
            posterURL: URL(string: "https://example.com/poster.jpg")
        )
        
        // Verify the view has been created
        XCTAssertNotNil(videoView)
    }
    
    // MARK: - View Model Tests
    
    func testVideoViewModelInitialization() {
        // Create view model with URL
        let viewModel = CTVideoViewModel(
            url: testURL,
            autoPlay: true,
            loop: true,
            muted: true
        )
        
        // Verify initial state
        XCTAssertNotNil(viewModel.player)
        XCTAssertFalse(viewModel.isPlaying)
        XCTAssertEqual(viewModel.playbackState, .loading)
        XCTAssertEqual(viewModel.currentTime, 0)
        XCTAssertEqual(viewModel.duration, 0)
        XCTAssertTrue(viewModel.showControls)
        XCTAssertTrue(viewModel.isMuted)
        XCTAssertEqual(viewModel.bufferedProgress, 0)
        
        // Create a test AVPlayer
        let player = AVPlayer(url: testURL)
        
        // Create view model with AVPlayer
        let viewModelWithPlayer = CTVideoViewModel(player: player)
        
        // Verify initial state
        XCTAssertNotNil(viewModelWithPlayer.player)
        XCTAssertFalse(viewModelWithPlayer.isPlaying)
    }
    
    func testVideoPlaybackControls() {
        // Create view model
        let viewModel = CTVideoViewModel(url: testURL)
        
        // Test play/pause toggle
        viewModel.togglePlayPause()
        XCTAssertTrue(viewModel.isPlaying)
        XCTAssertEqual(viewModel.playbackState, .playing)
        
        viewModel.togglePlayPause()
        XCTAssertFalse(viewModel.isPlaying)
        XCTAssertEqual(viewModel.playbackState, .paused)
        
        // Test mute toggle
        let initialMuteState = viewModel.isMuted
        viewModel.toggleMute()
        XCTAssertNotEqual(initialMuteState, viewModel.isMuted)
        XCTAssertEqual(viewModel.player.isMuted, viewModel.isMuted)
        
        // Test fullscreen toggle
        let initialFullscreenState = viewModel.isFullscreen
        viewModel.toggleFullscreen()
        XCTAssertNotEqual(initialFullscreenState, viewModel.isFullscreen)
        
        // Test controls toggle
        let initialControlsState = viewModel.showControls
        viewModel.toggleControls()
        XCTAssertNotEqual(initialControlsState, viewModel.showControls)
    }
    
    func testVideoSeekFunctionality() {
        // Create view model with a mock duration
        let viewModel = CTVideoViewModel(url: testURL)
        
        // Manually set duration for testing purposes
        viewModel.duration = 100
        
        // Test scrubbing to specific progress
        viewModel.scrubToProgress(progress: 0.5)
        XCTAssertEqual(viewModel.currentTime, 50, accuracy: 0.01)
        
        // Test seeking by relative amount
        viewModel.seek(by: 10)
        // Note: seek operation is asynchronous, so we can't test the exact value
        
        // Test seeking to specific time
        viewModel.seek(to: 75)
        // Note: seek operation is asynchronous, so we can't test the exact value
    }
    
    func testTimeFormatting() {
        // Create view model
        let viewModel = CTVideoViewModel(url: testURL)
        
        // Manually set times for testing
        viewModel.currentTime = 65
        viewModel.duration = 3725
        
        // Test time formatting
        XCTAssertEqual(viewModel.currentTimeFormatted, "01:05")
        XCTAssertEqual(viewModel.durationFormatted, "01:02:05")
        
        // Test progress calculation
        XCTAssertEqual(viewModel.progress, 65 / 3725, accuracy: 0.001)
    }
    
    // MARK: - Accessibility Tests
    
    func testVideoAccessibility() {
        // Test video with custom accessibility labels
        let videoView = CTVideo(
            url: testURL,
            accessibilityLabel: "Test Video",
            accessibilityHint: "Test Hint"
        )
        
        // Verify accessibility properties (this is a simple check, more thorough testing would require UI testing)
        let view = videoView.body
        let mirror = Mirror(reflecting: view)
        
        // Look for accessibility modifiers in the view hierarchy
        let hasAccessibilityLabel = findAccessibilityLabel(in: mirror, matching: "Test Video")
        let hasAccessibilityHint = findAccessibilityHint(in: mirror, matching: "Test Hint")
        
        XCTAssertTrue(hasAccessibilityLabel || hasAccessibilityHint)
    }
    
    // MARK: - Helper Methods
    
    private func findAccessibilityLabel(in mirror: Mirror, matching label: String) -> Bool {
        if let accessibilityLabel = mirror.descendant("accessibilityLabel") as? String, accessibilityLabel == label {
            return true
        }
        
        for child in mirror.children {
            if let childMirror = Mirror(reflecting: child.value), findAccessibilityLabel(in: childMirror, matching: label) {
                return true
            }
        }
        
        return false
    }
    
    private func findAccessibilityHint(in mirror: Mirror, matching hint: String) -> Bool {
        if let accessibilityHint = mirror.descendant("accessibilityHint") as? String, accessibilityHint == hint {
            return true
        }
        
        for child in mirror.children {
            if let childMirror = Mirror(reflecting: child.value), findAccessibilityHint(in: childMirror, matching: hint) {
                return true
            }
        }
        
        return false
    }
}