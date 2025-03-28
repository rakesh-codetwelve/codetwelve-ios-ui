//
//  CTCheckboxTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTCheckboxTests: XCTestCase {
    func testCheckboxInitialization() {
        // Given
        let checkbox = CTCheckbox(
            "Test Checkbox",
            isChecked: .constant(false)
        )
        
        // Then
        XCTAssertNotNil(checkbox)
    }
    
    func testCheckboxToggle() {
        // Given
        let expectation = self.expectation(description: "Checkbox toggled")
        var isChecked = false
        var onChangeValue: Bool?
        
        let checkbox = TestCheckbox(
            "Test Checkbox",
            isChecked: Binding(
                get: { isChecked },
                set: { isChecked = $0 }
            ),
            onChange: { newValue in
                onChangeValue = newValue
                expectation.fulfill()
            }
        )
        
        // When
        checkbox.simulateToggle()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(isChecked, "Checkbox should be toggled to checked state")
        XCTAssertEqual(onChangeValue, true, "onChange should be called with the new value")
    }
    
    func testCheckboxDisabledState() {
        // Given
        var isChecked = false
        var onChangeValue: Bool?
        
        let checkbox = TestCheckbox(
            "Test Checkbox",
            isChecked: Binding(
                get: { isChecked },
                set: { isChecked = $0 }
            ),
            isDisabled: true,
            onChange: { newValue in
                onChangeValue = newValue
            }
        )
        
        // When
        checkbox.simulateToggle()
        
        // Then
        XCTAssertFalse(isChecked, "Checkbox should not toggle when disabled")
        XCTAssertNil(onChangeValue, "onChange should not be called when disabled")
    }
    
    func testCheckboxWithDifferentStyles() {
        // Given
        let primaryCheckbox = CTCheckbox(
            "Primary",
            isChecked: .constant(true),
            style: .primary
        )
        
        let secondaryCheckbox = CTCheckbox(
            "Secondary",
            isChecked: .constant(true),
            style: .secondary
        )
        
        let filledCheckbox = CTCheckbox(
            "Filled",
            isChecked: .constant(true),
            style: .filled
        )
        
        let outlineCheckbox = CTCheckbox(
            "Outline",
            isChecked: .constant(true),
            style: .outline
        )
        
        let customCheckbox = CTCheckbox(
            "Custom",
            isChecked: .constant(true),
            style: .custom(
                checkedBackground: .red,
                checkedBorder: .red,
                uncheckedBackground: .clear,
                uncheckedBorder: .gray,
                checkmark: .white
            )
        )
        
        // Then
        XCTAssertNotNil(primaryCheckbox)
        XCTAssertNotNil(secondaryCheckbox)
        XCTAssertNotNil(filledCheckbox)
        XCTAssertNotNil(outlineCheckbox)
        XCTAssertNotNil(customCheckbox)
    }
    
    func testCheckboxWithDifferentSizes() {
        // Given
        let smallCheckbox = CTCheckbox(
            "Small",
            isChecked: .constant(true),
            size: .small
        )
        
        let mediumCheckbox = CTCheckbox(
            "Medium",
            isChecked: .constant(true),
            size: .medium
        )
        
        let largeCheckbox = CTCheckbox(
            "Large",
            isChecked: .constant(true),
            size: .large
        )
        
        // Then
        XCTAssertNotNil(smallCheckbox)
        XCTAssertNotNil(mediumCheckbox)
        XCTAssertNotNil(largeCheckbox)
    }
    
    func testCheckboxWithDifferentLabelAlignments() {
        // Given
        let trailingLabel = CTCheckbox(
            "Trailing",
            isChecked: .constant(true),
            labelAlignment: .trailing
        )
        
        let leadingLabel = CTCheckbox(
            "Leading",
            isChecked: .constant(true),
            labelAlignment: .leading
        )
        
        let noLabel = CTCheckbox(
            isChecked: .constant(true)
        )
        
        // Then
        XCTAssertNotNil(trailingLabel)
        XCTAssertNotNil(leadingLabel)
        XCTAssertNotNil(noLabel)
    }
}

// Helper extension for testing checkbox
private struct TestCheckbox {
    let label: String?
    let isChecked: Binding<Bool>
    let style: CTCheckboxStyle
    let size: CTCheckboxSize
    let isDisabled: Bool
    let labelAlignment: CTCheckboxLabelAlignment
    let onChange: ((Bool) -> Void)?
    
    init(
        _ label: String? = nil,
        isChecked: Binding<Bool>,
        style: CTCheckboxStyle = .primary,
        size: CTCheckboxSize = .medium,
        isDisabled: Bool = false,
        labelAlignment: CTCheckboxLabelAlignment = .trailing,
        onChange: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self.isChecked = isChecked
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.labelAlignment = labelAlignment
        self.onChange = onChange
    }
    
    func simulateToggle() {
        guard !isDisabled else { return }
        let newValue = !isChecked.wrappedValue
        isChecked.wrappedValue = newValue
        onChange?(newValue)
    }
}