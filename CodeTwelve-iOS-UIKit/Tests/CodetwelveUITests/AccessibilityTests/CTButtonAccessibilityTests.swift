//
//  CTButtonAccessibilityTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTButtonAccessibilityTests: XCTestCase {
    
    func testButtonAccessibilityLabel() {
        // Given
        let button = CTButton("Test Button") {}
        
        // When
        let accessibilityLabel = button.accessibilityLabel
        
        // Then
        XCTAssertEqual(accessibilityLabel, "Test Button", "Button should have correct accessibility label")
    }
    
    func testButtonLoadingStateAccessibility() {
        // Given
        let button = CTButton("Test Button", isLoading: true) {}
        
        // When
        let accessibilityLabel = button.accessibilityLabel
        
        // Then
        XCTAssertEqual(accessibilityLabel, "Test Button, Loading", "Loading button should indicate loading state in accessibility label")
    }
    
    func testButtonDisabledStateAccessibility() {
        // Given
        let button = CTButton("Test Button", isDisabled: true) {}
        
        // When
        let accessibilityLabel = button.accessibilityLabel
        
        // Then
        XCTAssertEqual(accessibilityLabel, "Test Button, Disabled", "Disabled button should indicate disabled state in accessibility label")
    }
    
    func testButtonIconAccessibility() {
        // Given
        let buttonWithLeadingIcon = CTButton("Test Button", icon: "star") {}
        let buttonWithTrailingIcon = CTButton("Test Button", icon: "star", iconPosition: .trailing) {}
        
        // When & Then
        XCTAssertEqual(buttonWithLeadingIcon.accessibilityLabel, "Test Button", "Button with icon should have correct accessibility label")
        XCTAssertEqual(buttonWithTrailingIcon.accessibilityLabel, "Test Button", "Button with trailing icon should have correct accessibility label")
    }
    
    func testButtonAccessibilityLabels() {
        let styles: [ButtonStyle] = [.primary, .secondary, .destructive, .outline, .ghost, .link]
        
        for style in styles {
            let button = CTButton("Test Button", style: style) {}
            XCTAssertEqual(button.accessibilityLabel, "Test Button", "Button should have correct accessibility label")
        }
    }
}

// Extension for testing
extension CTButton {
    var accessibilityLabel: String {
        let mirror = Mirror(reflecting: self)
        let label = mirror.children.first(where: { $0.label == "label" })?.value as! String
        let isLoading = mirror.children.first(where: { $0.label == "isLoading" })?.value as? Bool ?? false
        let isDisabled = mirror.children.first(where: { $0.label == "isDisabled" })?.value as? Bool ?? false
        
        if isLoading {
            return "\(label), Loading"
        } else if isDisabled {
            return "\(label), Disabled"
        } else {
            return label
        }
    }
}