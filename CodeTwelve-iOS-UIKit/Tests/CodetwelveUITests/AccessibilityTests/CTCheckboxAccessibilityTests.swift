//
//  CTCheckboxAccessibilityTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTCheckboxAccessibilityTests: XCTestCase {
    func testCheckboxAccessibilityLabel() {
        // Given
        let checkbox = CTCheckbox(
            "Accessibility Test",
            isChecked: .constant(false)
        )
        
        // Then - Using reflection to access the accessibilityLabel
        let mirror = Mirror(reflecting: checkbox)
        if let accessibilityLabel = mirror.descendant("accessibilityLabel") as? String {
            XCTAssertEqual(accessibilityLabel, "Accessibility Test")
        } else {
            XCTFail("Could not find accessibilityLabel property")
        }
    }
    
    func testCheckboxAccessibilityTraits() {
        // Given
        let checkbox = CTCheckbox(
            "Test Checkbox",
            isChecked: .constant(false)
        )
        
        // Then
        // For SwiftUI views, we can't directly test traits at the unit test level,
        // but we can check that our view applies the correct traits in the body
        let mirror = Mirror(reflecting: checkbox.body)
        let bodyDescription = String(describing: mirror)
        
        XCTAssertTrue(bodyDescription.contains("accessibilityAddTraits(.isButton)") || 
                     bodyDescription.contains("accessibilityTraits([.isButton])"),
                     "Checkbox should have button accessibility trait")
    }
    
    func testCheckboxAccessibilityValue() {
        // Given
        let uncheckedCheckbox = CTCheckbox(
            "Unchecked",
            isChecked: .constant(false)
        )
        
        let checkedCheckbox = CTCheckbox(
            "Checked",
            isChecked: .constant(true)
        )
        
        // Then
        // Since we can't directly access the accessibilityValue in a unit test,
        // we check our implementation indirectly
        let uncheckedMirror = Mirror(reflecting: uncheckedCheckbox.body)
        let uncheckedDescription = String(describing: uncheckedMirror)
        
        let checkedMirror = Mirror(reflecting: checkedCheckbox.body)
        let checkedDescription = String(describing: checkedMirror)
        
        XCTAssertTrue(uncheckedDescription.contains("accessibilityValue(\"unchecked\")"),
                     "Unchecked checkbox should have 'unchecked' accessibility value")
        
        XCTAssertTrue(checkedDescription.contains("accessibilityValue(\"checked\")"),
                     "Checked checkbox should have 'checked' accessibility value")
    }
    
    func testCheckboxAccessibilityHint() {
        // Given
        let uncheckedCheckbox = CTCheckbox(
            "Unchecked",
            isChecked: .constant(false)
        )
        
        let checkedCheckbox = CTCheckbox(
            "Checked",
            isChecked: .constant(true)
        )
        
        // Then
        let uncheckedMirror = Mirror(reflecting: uncheckedCheckbox.body)
        let uncheckedDescription = String(describing: uncheckedMirror)
        
        let checkedMirror = Mirror(reflecting: checkedCheckbox.body)
        let checkedDescription = String(describing: checkedMirror)
        
        XCTAssertTrue(uncheckedDescription.contains("Double tap to check"),
                     "Unchecked checkbox should have appropriate hint")
        
        XCTAssertTrue(checkedDescription.contains("Double tap to uncheck"),
                     "Checked checkbox should have appropriate hint")
    }
    
    func testCheckboxWithNoLabelAccessibility() {
        // Given
        let checkbox = CTCheckbox(
            isChecked: .constant(false)
        )
        
        // Then
        let mirror = Mirror(reflecting: checkbox)
        if let accessibilityLabel = mirror.descendant("accessibilityLabel") as? String {
            XCTAssertEqual(accessibilityLabel, "Checkbox", "Checkbox with no label should use default accessibility label")
        } else {
            XCTFail("Could not find accessibilityLabel property")
        }
    }
    
    func testDisabledCheckboxAccessibility() {
        // Given
        let checkbox = CTCheckbox(
            "Disabled Checkbox",
            isChecked: .constant(false),
            isDisabled: true
        )
        
        // Then
        // Since we can't directly test disabled state at unit test level,
        // we check that our view is configured with disabled = true
        let mirror = Mirror(reflecting: checkbox.body)
        let description = String(describing: mirror)
        
        XCTAssertTrue(description.contains("disabled(true)"),
                     "Disabled checkbox should have disabled modifier applied")
    }
}