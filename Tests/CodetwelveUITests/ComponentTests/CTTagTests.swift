//
//  CTTagTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTTagTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testTagInitializationWithDefaultParameters() {
        let tag = CTTag("Test Tag")
        
        XCTAssertEqual(tag.text, "Test Tag")
        XCTAssertNil(tag.icon)
        XCTAssertEqual(tag.style, .default)
        XCTAssertEqual(tag.size, .medium)
        XCTAssertFalse(tag.isRemovable)
        XCTAssertNil(tag.onRemove)
    }
    
    func testTagInitializationWithCustomParameters() {
        var removeCallCount = 0
        let tag = CTTag(
            "Custom Tag",
            icon: "star.fill",
            style: .primary,
            size: .large,
            isRemovable: true
        ) {
            removeCallCount += 1
        }
        
        XCTAssertEqual(tag.text, "Custom Tag")
        XCTAssertEqual(tag.icon, "star.fill")
        XCTAssertEqual(tag.style, .primary)
        XCTAssertEqual(tag.size, .large)
        XCTAssertTrue(tag.isRemovable)
        
        // Test remove action
        tag.onRemove?()
        XCTAssertEqual(removeCallCount, 1)
    }
    
    // MARK: - Style Tests
    
    func testTagStyles() {
        let styles: [CTTag.Style] = [
            .default,
            .primary,
            .secondary,
            .success,
            .warning,
            .error,
            .custom(backgroundColor: .red, foregroundColor: .blue)
        ]
        
        styles.forEach { style in
            let tag = CTTag("Style Test", style: style)
            XCTAssertEqual(tag.style, style)
        }
    }
    
    // MARK: - Size Tests
    
    func testTagSizes() {
        let sizes: [CTTag.Size] = [.small, .medium, .large]
        
        sizes.forEach { size in
            let tag = CTTag("Size Test", size: size)
            XCTAssertEqual(tag.size, size)
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testTagAccessibility() {
        let tag = CTTag("Accessibility Tag")
        let accessibilityLabel = tag.accessibilityLabel
        
        XCTAssertEqual(accessibilityLabel, "Accessibility Tag")
    }
    
    func testRemovableTagAccessibility() {
        let tag = CTTag("Removable Tag", isRemovable: true)
        
        // Note: This would require more complex accessibility testing
        // that might need UI testing framework
        XCTAssertTrue(tag.isRemovable)
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyTagText() {
        let tag = CTTag("")
        
        XCTAssertEqual(tag.text, "")
    }
    
    func testTagWithOnlyIcon() {
        let tag = CTTag("", icon: "star.fill")
        
        XCTAssertEqual(tag.text, "")
        XCTAssertEqual(tag.icon, "star.fill")
    }
    
    // MARK: - Custom Style Tests
    
    func testCustomStyleTag() {
        let customBackgroundColor = Color.purple
        let customForegroundColor = Color.white
        
        let tag = CTTag(
            "Custom",
            style: .custom(
                backgroundColor: customBackgroundColor,
                foregroundColor: customForegroundColor
            )
        )
        
        XCTAssertEqual(tag.style, .custom(
            backgroundColor: customBackgroundColor,
            foregroundColor: customForegroundColor
        ))
    }
}