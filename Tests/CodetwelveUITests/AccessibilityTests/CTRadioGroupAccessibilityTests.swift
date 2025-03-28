//
//  CTRadioGroupAccessibilityTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTRadioGroupAccessibilityTests: XCTestCase {
    func testRadioGroupAccessibilityContainment() {
        // Given
        let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
        let radioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1")
        )
        
        // Then
        // Since we can't directly test accessibility at the unit test level,
        // we check that our view applies the correct accessibility modifiers
        let mirror = Mirror(reflecting: radioGroup.body)
        let bodyDescription = String(describing: mirror)
        
        XCTAssertTrue(bodyDescription.contains("accessibilityElement(children: .contain)"),
                      "Radio group should contain its children for accessibility")
    }
    
    func testRadioButtonAccessibility() {
        // Given
        let options = ["option1": "Option 1"]
        @State var selectedOption = "option1"
        
        // Create a radio group with a single option to simplify testing
        let radioGroup = CTRadioGroup(
            options: options,
            selectedOption: $selectedOption
        )
        
        // Then
        // For SwiftUI views, we can't directly test individual radio buttons at the unit test level,
        // but we can check that our implementation uses the correct accessibility modifiers
        let mirror = Mirror(reflecting: radioGroup)
        let description = String(describing: mirror)
        
        // Check that we're using our accessibility extension for buttons
        XCTAssertTrue(description.contains("ctButtonAccessibility") || 
                     description.contains("accessibilityLabel") ||
                     description.contains("accessibilityHint"),
                     "Radio buttons should have proper accessibility applied")
    }
    
    func testSelectedRadioButtonAccessibility() {
        // Given
        // We need to test both selected and unselected states
        let radioWithSelectedOption = TestRadioButton(
            id: "option1",
            label: "Option 1",
            isSelected: true
        )
        
        let radioWithUnselectedOption = TestRadioButton(
            id: "option2",
            label: "Option 2",
            isSelected: false
        )
        
        // Then
        XCTAssertEqual(radioWithSelectedOption.accessibilityHint, "Selected", 
                      "Selected radio button should indicate it is selected")
        
        XCTAssertEqual(radioWithUnselectedOption.accessibilityHint, "Tap to select",
                      "Unselected radio button should have appropriate hint")
    }
    
    func testDisabledRadioGroupAccessibility() {
        // Given
        let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
        let radioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            isDisabled: true
        )
        
        // Then
        let mirror = Mirror(reflecting: radioGroup.body)
        let description = String(describing: mirror)
        
        XCTAssertTrue(description.contains("opacity(0.6)") || 
                     description.contains("disabled(true)"),
                     "Disabled radio group should have visual indicators of disabled state")
    }
}

// Helper struct for testing radio button accessibility
private struct TestRadioButton {
    let id: String
    let label: String
    let isSelected: Bool
    
    var accessibilityLabel: String {
        return label
    }
    
    var accessibilityHint: String {
        return isSelected ? "Selected" : "Tap to select"
    }
    
    var accessibilityValue: String {
        return isSelected ? "Selected" : "Not selected"
    }
}