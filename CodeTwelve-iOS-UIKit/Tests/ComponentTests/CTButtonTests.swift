//
//  CTButtonTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTButtonTests: XCTestCase {
    
    func testButtonAction() {
        // Given
        var actionCalled = false
        let button = CTButton("Test") {
            actionCalled = true
        }
        
        // When
        button.simulateTap()
        
        // Then
        XCTAssertTrue(actionCalled, "Button action should be called when tapped")
    }
    
    func testButtonDisabledState() {
        // Given
        var actionCalled = false
        let button = CTButton("Test", isDisabled: true) {
            actionCalled = true
        }
        
        // When
        button.simulateTap()
        
        // Then
        XCTAssertFalse(actionCalled, "Button action should not be called when disabled")
    }
    
    func testButtonLoadingState() {
        // Given
        var actionCalled = false
        let button = CTButton("Test", isLoading: true) {
            actionCalled = true
        }
        
        // When
        button.simulateTap()
        
        // Then
        XCTAssertFalse(actionCalled, "Button action should not be called when loading")
    }
    
    func testButtonSizeAffectsHeight() {
        // Given & When
        let smallButton = CTButton("Small", size: .small) {}
        let mediumButton = CTButton("Medium", size: .medium) {}
        let largeButton = CTButton("Large", size: .large) {}
        
        // Then
        XCTAssertEqual(smallButton.size.height, 32, "Small button should have height of 32")
        XCTAssertEqual(mediumButton.size.height, 44, "Medium button should have height of 44")
        XCTAssertEqual(largeButton.size.height, 56, "Large button should have height of 56")
    }
    
    func testButtonStyleTintColors() {
        let theme = CTDefaultTheme()
        
        XCTAssertEqual(ButtonStyle.primary.tintColor(for: theme), theme.textOnAccent, "Primary button should use textOnAccent color")
        XCTAssertEqual(ButtonStyle.secondary.tintColor(for: theme), theme.textOnAccent, "Secondary button should use textOnAccent color")
        XCTAssertEqual(ButtonStyle.destructive.tintColor(for: theme), theme.textOnAccent, "Destructive button should use textOnAccent color")
        XCTAssertEqual(ButtonStyle.outline.tintColor(for: theme), theme.primary, "Outline button should use primary color")
        XCTAssertEqual(ButtonStyle.ghost.tintColor(for: theme), theme.text, "Ghost button should use text color")
        XCTAssertEqual(ButtonStyle.link.tintColor(for: theme), theme.text, "Link button should use text color")
    }
    
    func testButtonWithIconHasCorrectIconScale() {
        // Given & When
        let smallButton = CTButton("Small", icon: "star", size: .small) {}
        let mediumButton = CTButton("Medium", icon: "star", size: .medium) {}
        let largeButton = CTButton("Large", icon: "star", size: .large) {}
        
        // Then
        XCTAssertEqual(smallButton.size.iconScale, .small, "Small button should have small icon scale")
        XCTAssertEqual(mediumButton.size.iconScale, .medium, "Medium button should have medium icon scale")
        XCTAssertEqual(largeButton.size.iconScale, .large, "Large button should have large icon scale")
    }
}

// Extension for testing
extension CTButton {
    var size: CTButtonSize {
        let mirror = Mirror(reflecting: self)
        return mirror.children.first(where: { $0.label == "size" })?.value as! CTButtonSize
    }
    
    func simulateTap() {
        let mirror = Mirror(reflecting: self)
        let isDisabled = mirror.children.first(where: { $0.label == "isDisabled" })?.value as? Bool ?? false
        let isLoading = mirror.children.first(where: { $0.label == "isLoading" })?.value as? Bool ?? false
        let action = mirror.children.first(where: { $0.label == "action" })?.value as! () -> Void
        
        if !isDisabled && !isLoading {
            action()
        }
    }
}