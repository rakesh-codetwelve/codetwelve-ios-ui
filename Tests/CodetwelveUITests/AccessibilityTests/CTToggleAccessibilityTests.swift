//
//  CTToggleAccessibilityTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTToggleAccessibilityTests: XCTestCase {
    // MARK: - Label Tests
    
    func testToggleAccessibilityLabel() {
        // Given
        let label = "Notifications"
        let isOn = Binding<Bool>(wrappedValue: false)
        let toggle = CTToggle(label, isOn: isOn)
        
        // Then
        let accessibilityLabel = findAccessibilityLabel(for: toggle)
        XCTAssertEqual(accessibilityLabel, label, "Toggle should have correct accessibility label")
    }
    
    // MARK: - Value Tests
    
    func testToggleAccessibilityValue() {
        // Test toggle in off state
        let offToggle = CTToggle("Test", isOn: .constant(false))
        let offValue = findAccessibilityValue(for: offToggle)
        XCTAssertEqual(offValue, "Off", "Toggle in off state should have accessibility value 'Off'")
        
        // Test toggle in on state
        let onToggle = CTToggle("Test", isOn: .constant(true))
        let onValue = findAccessibilityValue(for: onToggle)
        XCTAssertEqual(onValue, "On", "Toggle in on state should have accessibility value 'On'")
    }
    
    // MARK: - Hint Tests
    
    func testToggleAccessibilityHint() {
        // Test toggle in off state
        let offToggle = CTToggle("Test", isOn: .constant(false))
        let offHint = findAccessibilityHint(for: offToggle)
        XCTAssertEqual(offHint, "Double tap to turn on", "Toggle in off state should have appropriate hint")
        
        // Test toggle in on state
        let onToggle = CTToggle("Test", isOn: .constant(true))
        let onHint = findAccessibilityHint(for: onToggle)
        XCTAssertEqual(onHint, "Double tap to turn off", "Toggle in on state should have appropriate hint")
    }
    
    // MARK: - Traits Tests
    
    func testToggleAccessibilityTraits() {
        // Given
        let isOn = Binding<Bool>(wrappedValue: false)
        let toggle = CTToggle("Test", isOn: isOn)
        
        // Then
        let traits = findAccessibilityTraits(for: toggle)
        XCTAssertTrue(traits.contains(.isButton), "Toggle should have 'isButton' accessibility trait")
    }
    
    // MARK: - Disabled State Tests
    
    func testToggleDisabledStateAccessibility() {
        // Given
        let isOn = Binding<Bool>(wrappedValue: false)
        let disabledToggle = CTToggle("Test", isOn: isOn, isDisabled: true)
        
        // Then
        let traits = findAccessibilityTraits(for: disabledToggle)
        XCTAssertTrue(traits.contains(.isButton), "Disabled toggle should retain 'isButton' trait")
        XCTAssertTrue(traits.contains(.notEnabled), "Disabled toggle should have 'notEnabled' trait")
    }
    
    // MARK: - Label Position Tests
    
    func testToggleLabelPositionAccessibility() {
        // Test with leading label position
        let leadingToggle = CTToggle("Leading", isOn: .constant(false), labelPosition: .leading)
        let leadingLabel = findAccessibilityLabel(for: leadingToggle)
        XCTAssertEqual(leadingLabel, "Leading", "Toggle with leading label should have correct accessibility label")
        
        // Test with trailing label position
        let trailingToggle = CTToggle("Trailing", isOn: .constant(false), labelPosition: .trailing)
        let trailingLabel = findAccessibilityLabel(for: trailingToggle)
        XCTAssertEqual(trailingLabel, "Trailing", "Toggle with trailing label should have correct accessibility label")
    }
    
    // MARK: - No Label Tests
    
    func testToggleWithoutLabelAccessibility() {
        // Given
        let isOn = Binding<Bool>(wrappedValue: false)
        let noLabelToggle = CTToggle(nil, isOn: isOn)
        
        // Then
        let value = findAccessibilityValue(for: noLabelToggle)
        XCTAssertEqual(value, "Off", "Toggle without label should still have accessibility value")
        
        let traits = findAccessibilityTraits(for: noLabelToggle)
        XCTAssertTrue(traits.contains(.isButton), "Toggle without label should have 'isButton' trait")
    }
    
    // MARK: - Helper Methods
    
    private func findAccessibilityLabel(for view: CTToggle) -> String? {
        return view.body.accessibilityLabel as? String
    }
    
    private func findAccessibilityValue(for view: CTToggle) -> String? {
        return view.body.accessibilityValue as? String
    }
    
    private func findAccessibilityHint(for view: CTToggle) -> String? {
        return view.body.accessibilityHint as? String
    }
    
    private func findAccessibilityTraits(for view: CTToggle) -> AccessibilityTraits {
        return view.body.accessibilityTraits
    }
}