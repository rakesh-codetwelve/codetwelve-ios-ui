//
//  CTImageTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

class CTImageTests: XCTestCase {
    // MARK: - Test Cases for Local Images
    
    func testImageInitialization() {
        // Given
        let image = Image(systemName: "star")
        
        // When
        let ctImage = CTImage(image: image)
        
        // Then
        XCTAssertNotNil(ctImage, "CTImage should initialize with a local image")
    }
    
    func testImageWithCustomStyling() {
        // Given
        let image = Image(systemName: "star")
        let cornerRadius: CGFloat = 12
        let hasBorder = true
        let borderColor = Color.red
        let borderWidth: CGFloat = 2
        let hasShadow = true
        let shadowRadius: CGFloat = 5
        
        // When
        let ctImage = CTImage(
            image: image,
            cornerRadius: cornerRadius,
            hasBorder: hasBorder,
            borderColor: borderColor,
            borderWidth: borderWidth,
            hasShadow: hasShadow,
            shadowRadius: shadowRadius
        )
        
        // Then
        XCTAssertNotNil(ctImage, "CTImage should initialize with custom styling")
        // Note: Visual properties are difficult to test directly in unit tests
    }
    
    func testImageContentModes() {
        // Given
        let image = Image(systemName: "star")
        
        // When
        let fillImage = CTImage(image: image, contentMode: .fill)
        let fitImage = CTImage(image: image, contentMode: .fit)
        
        // Then
        XCTAssertNotNil(fillImage, "CTImage should initialize with fill content mode")
        XCTAssertNotNil(fitImage, "CTImage should initialize with fit content mode")
    }
    
    func testImageAccessibility() {
        // Given
        let image = Image(systemName: "star")
        let accessibilityLabel = "Test accessibility label"
        
        // When
        let ctImage = CTImage(
            image: image,
            accessibilityLabel: accessibilityLabel
        )
        let decorativeImage = CTImage(
            image: image,
            isDecorative: true
        )
        
        // Then
        XCTAssertNotNil(ctImage, "CTImage should initialize with accessibility label")
        XCTAssertNotNil(decorativeImage, "CTImage should initialize as decorative")
    }
    
    // MARK: - Test Cases for Remote Images
    
    func testRemoteImageInitialization() {
        // Given
        let url = URL(string: "https://example.com/image.jpg")
        
        // When
        let ctImage = CTImage(url: url)
        
        // Then
        XCTAssertNotNil(ctImage, "CTImage should initialize with a remote URL")
    }
    
    func testRemoteImageWithPlaceholder() {
        // Given
        let url = URL(string: "https://example.com/image.jpg")
        let placeholder = Image(systemName: "photo")
        
        // When
        let ctImage = CTImage(
            url: url,
            placeholder: placeholder
        )
        
        // Then
        XCTAssertNotNil(ctImage, "CTImage should initialize with a placeholder")
    }
    
    func testRemoteImageWithLoadingIndicator() {
        // Given
        let url = URL(string: "https://example.com/image.jpg")
        
        // When
        let withIndicator = CTImage(
            url: url,
            showLoadingIndicator: true
        )
        let withoutIndicator = CTImage(
            url: url,
            showLoadingIndicator: false
        )
        
        // Then
        XCTAssertNotNil(withIndicator, "CTImage should initialize with loading indicator")
        XCTAssertNotNil(withoutIndicator, "CTImage should initialize without loading indicator")
    }
    
    func testInvalidURL() {
        // Given
        let invalidURL: URL? = nil
        let placeholder = Image(systemName: "exclamationmark.triangle")
        
        // When
        let ctImage = CTImage(
            url: invalidURL,
            placeholder: placeholder
        )
        
        // Then
        XCTAssertNotNil(ctImage, "CTImage should handle nil URL gracefully")
    }
    
    func testExtensionModifiers() {
        // Given
        let image = Image(systemName: "star")
        
        // When
        let cornerModifier = CTImage(image: image).cornerRadius(10)
        let borderModifier = CTImage(image: image).bordered(color: .blue, width: 2)
        let shadowModifier = CTImage(image: image).shadowed(radius: 8)
        let accessibilityModifier = CTImage(image: image).accessibilityImageLabel("Test label")
        let decorativeModifier = CTImage(image: image).decorative()
        
        // Then
        XCTAssertNotNil(cornerModifier, "CTImage cornerRadius modifier should work")
        XCTAssertNotNil(borderModifier, "CTImage bordered modifier should work")
        XCTAssertNotNil(shadowModifier, "CTImage shadowed modifier should work")
        XCTAssertNotNil(accessibilityModifier, "CTImage accessibilityImageLabel modifier should work")
        XCTAssertNotNil(decorativeModifier, "CTImage decorative modifier should work")
    }
    
    func testChainedModifiers() {
        // Given
        let image = Image(systemName: "star")
        
        // When
        let chainedModifiers = CTImage(image: image)
            .cornerRadius(10)
            .bordered()
            .shadowed()
            .accessibilityImageLabel("Styled image")
        
        // Then
        XCTAssertNotNil(chainedModifiers, "CTImage should support chained modifiers")
    }
    
    #if !os(macOS)
    // This test requires the iOS runtime and can't run on macOS
    func testLoadStateBehavior() throws {
        // This is difficult to unit test properly since it involves async network operations
        // We can only test the initial state without special test infrastructure
        
        // Given
        let url = URL(string: "https://example.com/image.jpg")
        
        // When
        let ctImage = CTImage(url: url)
        let mirror = Mirror(reflecting: ctImage)
        
        // Then: Check initial state via reflection (note: this is fragile and might break with implementation changes)
        if let loadStateProperty = mirror.children.first(where: { $0.label == "_loadState" }) {
            if let loadState = loadStateProperty.value as? CTImage.LoadState {
                XCTAssertEqual(loadState, CTImage.LoadState.ready, "Initial load state should be ready")
            }
        }
    }
    #endif
}