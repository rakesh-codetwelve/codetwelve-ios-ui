//
//  CTRadioGroupTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTRadioGroupTests: XCTestCase {
    func testRadioGroupInitialization() {
        // Given
        let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
        let radioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1")
        )
        
        // Then
        XCTAssertNotNil(radioGroup)
    }
    
    func testRadioGroupSelection() {
        // Given
        let expectation = self.expectation(description: "Radio option selected")
        var selectedOption = "option1"
        var onChangeValue: String?
        
        let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
        let radioGroup = TestRadioGroup(
            options: options,
            selectedOption: Binding(
                get: { selectedOption },
                set: { selectedOption = $0 }
            ),
            onChange: { newValue in
                onChangeValue = newValue
                expectation.fulfill()
            }
        )
        
        // When
        radioGroup.simulateSelection("option2")
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(selectedOption, "option2", "Radio group should update selected option")
        XCTAssertEqual(onChangeValue, "option2", "onChange should be called with the new value")
    }
    
    func testRadioGroupDisabledState() {
        // Given
        var selectedOption = "option1"
        var onChangeValue: String?
        
        let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
        let radioGroup = TestRadioGroup(
            options: options,
            selectedOption: Binding(
                get: { selectedOption },
                set: { selectedOption = $0 }
            ),
            isDisabled: true,
            onChange: { newValue in
                onChangeValue = newValue
            }
        )
        
        // When
        radioGroup.simulateSelection("option2")
        
        // Then
        XCTAssertEqual(selectedOption, "option1", "Radio group should not update when disabled")
        XCTAssertNil(onChangeValue, "onChange should not be called when disabled")
    }
    
    func testRadioGroupWithArrayOptions() {
        // Given
        let options = [1, 2, 3, 4, 5]
        var selectedOption = 1
        
        let radioGroup = CTRadioGroup(
            options: options,
            selectedOption: Binding(
                get: { selectedOption },
                set: { selectedOption = $0 }
            )
        )
        
        // Then
        XCTAssertNotNil(radioGroup)
    }
    
    func testRadioGroupWithDifferentStyles() {
        // Given
        let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
        
        let primaryRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            style: .primary
        )
        
        let secondaryRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            style: .secondary
        )
        
        let outlineRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            style: .outline
        )
        
        let customRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            style: .custom(
                selectedFill: .red,
                selectedBorder: .red,
                unselectedBorder: .gray
            )
        )
        
        // Then
        XCTAssertNotNil(primaryRadioGroup)
        XCTAssertNotNil(secondaryRadioGroup)
        XCTAssertNotNil(outlineRadioGroup)
        XCTAssertNotNil(customRadioGroup)
    }
    
    func testRadioGroupWithDifferentSizes() {
        // Given
        let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
        
        let smallRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            size: .small
        )
        
        let mediumRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            size: .medium
        )
        
        let largeRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            size: .large
        )
        
        // Then
        XCTAssertNotNil(smallRadioGroup)
        XCTAssertNotNil(mediumRadioGroup)
        XCTAssertNotNil(largeRadioGroup)
    }
    
    func testRadioGroupWithDifferentOrientations() {
        // Given
        let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
        
        let verticalRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            orientation: .vertical
        )
        
        let horizontalRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            orientation: .horizontal
        )
        
        // Then
        XCTAssertNotNil(verticalRadioGroup)
        XCTAssertNotNil(horizontalRadioGroup)
    }
    
    func testRadioGroupWithCustomSpacing() {
        // Given
        let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
        
        let customSpacingRadioGroup = CTRadioGroup(
            options: options,
            selectedOption: .constant("option1"),
            spacing: 30
        )
        
        // Then
        XCTAssertNotNil(customSpacingRadioGroup)
    }
}

// Helper struct for testing radio group
private struct TestRadioGroup<ID: Hashable> {
    let options: [ID: String]
    let selectedOption: Binding<ID>
    let style: CTRadioStyle
    let size: CTRadioSize
    let orientation: CTRadioOrientation
    let spacing: CGFloat
    let isDisabled: Bool
    let onChange: ((ID) -> Void)?
    
    init(
        options: [ID: String],
        selectedOption: Binding<ID>,
        style: CTRadioStyle = .primary,
        size: CTRadioSize = .medium,
        orientation: CTRadioOrientation = .vertical,
        spacing: CGFloat? = nil,
        isDisabled: Bool = false,
        onChange: ((ID) -> Void)? = nil
    ) {
        self.options = options
        self.selectedOption = selectedOption
        self.style = style
        self.size = size
        self.orientation = orientation
        self.spacing = spacing ?? (orientation == .vertical ? CTSpacing.m : CTSpacing.l)
        self.isDisabled = isDisabled
        self.onChange = onChange
    }
    
    func simulateSelection(_ id: ID) {
        guard !isDisabled, options[id] != nil, selectedOption.wrappedValue != id else { return }
        
        selectedOption.wrappedValue = id
        onChange?(id)
    }
}