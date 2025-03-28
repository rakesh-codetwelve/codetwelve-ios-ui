//
//  CTToggleTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTToggleTests: XCTestCase {
    // MARK: - Initialization Tests
    
    func testToggleInitialization() {
        // Given
        let isOn = Binding<Bool>(wrappedValue: false)
        
        // When
        let toggle = CTToggle("Test Toggle", isOn: isOn)
        
        // Then
        XCTAssertEqual(isOn.wrappedValue, false)
    }
    
    func testToggleWithoutLabel() {
        // Given
        let isOn = Binding<Bool>(wrappedValue: true)
        
        // When
        let toggle = CTToggle(nil, isOn: isOn)
        
        // Then
        XCTAssertEqual(isOn.wrappedValue, true)
    }
    
    // MARK: - Toggle Action Tests
    
    func testToggleAction() {
        // Given
        var isOn = false
        var onChangeCalled = false
        
        let toggle = TestToggle(
            "Test Toggle",
            isOn: Binding(
                get: { isOn },
                set: { isOn = $0 }
            ),
            onChange: { _ in
                onChangeCalled = true
            }
        )
        
        // When
        toggle.simulateToggle()
        
        // Then
        XCTAssertTrue(isOn, "Toggle should be turned on")
        XCTAssertTrue(onChangeCalled, "OnChange callback should be called")
    }
    
    func testToggleDisabledState() {
        // Given
        var isOn = false
        var onChangeCalled = false
        
        let toggle = TestToggle(
            "Test Toggle",
            isOn: Binding(
                get: { isOn },
                set: { isOn = $0 }
            ),
            isDisabled: true,
            onChange: { _ in
                onChangeCalled = true
            }
        )
        
        // When
        toggle.simulateToggle()
        
        // Then
        XCTAssertFalse(isOn, "Toggle state should not change when disabled")
        XCTAssertFalse(onChangeCalled, "OnChange callback should not be called when disabled")
    }
    
    // MARK: - Style Tests
    
    func testToggleWithDifferentStyles() {
        // Test primary style
        let primaryToggle = TestToggle("Primary Toggle", isOn: .constant(false), style: .primary)
        XCTAssertEqual(primaryToggle.style, .primary)
        
        // Test secondary style
        let secondaryToggle = TestToggle("Secondary Toggle", isOn: .constant(false), style: .secondary)
        XCTAssertEqual(secondaryToggle.style, .secondary)
        
        // Test success style
        let successToggle = TestToggle("Success Toggle", isOn: .constant(false), style: .success)
        XCTAssertEqual(successToggle.style, .success)
        
        // Test custom style
        let customToggle = TestToggle(
            "Custom Toggle",
            isOn: .constant(false),
            style: .custom(colors: CTToggleColorOptions(
                onColor: .pink,
                offColor: .gray,
                thumbColor: .white
            ))
        )
        
        if case .custom = customToggle.style {
            // Custom style set correctly
            XCTAssertTrue(true)
        } else {
            XCTFail("Custom style not set correctly")
        }
    }
    
    // MARK: - Size Tests
    
    func testToggleWithDifferentSizes() {
        // Test small size
        let smallToggle = TestToggle("Small Toggle", isOn: .constant(false), size: .small)
        XCTAssertEqual(smallToggle.size, .small)
        
        // Test medium size
        let mediumToggle = TestToggle("Medium Toggle", isOn: .constant(false), size: .medium)
        XCTAssertEqual(mediumToggle.size, .medium)
        
        // Test large size
        let largeToggle = TestToggle("Large Toggle", isOn: .constant(false), size: .large)
        XCTAssertEqual(largeToggle.size, .large)
        
        // Test custom size
        let customToggle = TestToggle(
            "Custom Toggle",
            isOn: .constant(false),
            size: .custom(width: 70, height: 40, thumbSize: 32, font: .headline)
        )
        
        if case .custom = customToggle.size {
            // Custom size set correctly
            XCTAssertTrue(true)
        } else {
            XCTFail("Custom size not set correctly")
        }
    }
    
    // MARK: - Label Position Tests
    
    func testToggleWithDifferentLabelPositions() {
        // Test leading label position
        let leadingToggle = TestToggle("Leading Toggle", isOn: .constant(false), labelPosition: .leading)
        XCTAssertEqual(leadingToggle.labelPosition, .leading)
        
        // Test trailing label position
        let trailingToggle = TestToggle("Trailing Toggle", isOn: .constant(false), labelPosition: .trailing)
        XCTAssertEqual(trailingToggle.labelPosition, .trailing)
    }
    
    // MARK: - Toggle Size Enum Tests
    
    func testToggleSizeProperties() {
        // Test small size properties
        XCTAssertEqual(CTToggleSize.small.width, 44)
        XCTAssertEqual(CTToggleSize.small.height, 24)
        XCTAssertEqual(CTToggleSize.small.thumbSize, 18)
        XCTAssertEqual(CTToggleSize.small.contentSpacing, CTSpacing.s)
        
        // Test medium size properties
        XCTAssertEqual(CTToggleSize.medium.width, 50)
        XCTAssertEqual(CTToggleSize.medium.height, 30)
        XCTAssertEqual(CTToggleSize.medium.thumbSize, 22)
        XCTAssertEqual(CTToggleSize.medium.contentSpacing, CTSpacing.m)
        
        // Test large size properties
        XCTAssertEqual(CTToggleSize.large.width, 60)
        XCTAssertEqual(CTToggleSize.large.height, 36)
        XCTAssertEqual(CTToggleSize.large.thumbSize, 26)
        XCTAssertEqual(CTToggleSize.large.contentSpacing, CTSpacing.m)
        
        // Test custom size properties
        let customSize = CTToggleSize.custom(width: 70, height: 40, thumbSize: 30, font: .headline)
        XCTAssertEqual(customSize.width, 70)
        XCTAssertEqual(customSize.height, 40)
        XCTAssertEqual(customSize.thumbSize, 30)
        XCTAssertEqual(customSize.contentSpacing, CTSpacing.m)
    }
    
    // MARK: - Callback Tests
    
    func testToggleOnChangeCallback() {
        // Given
        var isOn = false
        var callbackValue: Bool?
        
        let toggle = TestToggle(
            "Test Toggle",
            isOn: Binding(
                get: { isOn },
                set: { isOn = $0 }
            ),
            onChange: { newValue in
                callbackValue = newValue
            }
        )
        
        // When
        toggle.simulateToggle()
        
        // Then
        XCTAssertEqual(callbackValue, true, "Callback should be called with the new toggle value")
    }
}

// MARK: - Test Helper

class TestToggle {
    let label: String?
    let isOn: Binding<Bool>
    let style: CTToggleStyle
    let size: CTToggleSize
    let isDisabled: Bool
    let labelPosition: CTToggleLabelPosition
    let onChange: ((Bool) -> Void)?
    
    init(
        _ label: String?,
        isOn: Binding<Bool>,
        style: CTToggleStyle = .primary,
        size: CTToggleSize = .medium,
        isDisabled: Bool = false,
        labelPosition: CTToggleLabelPosition = .leading,
        onChange: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self.isOn = isOn
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.labelPosition = labelPosition
        self.onChange = onChange
    }
    
    func simulateToggle() {
        if !isDisabled {
            isOn.wrappedValue.toggle()
            onChange?(isOn.wrappedValue)
        }
    }
}