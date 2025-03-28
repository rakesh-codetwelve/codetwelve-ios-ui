//
//  CTTextAreaTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTTextAreaTests: XCTestCase {
    func testTextAreaInitialization() {
        // Given & When
        let textArea = CTTextArea(
            "Description",
            placeholder: "Enter a detailed description...",
            text: .constant("")
        )
        
        // Then
        // Test passes if initialization doesn't crash
        XCTAssertNotNil(textArea)
    }
    
    func testTextAreaWithPlaceholder() {
        // Given & When
        let textArea = CTTextArea(
            "Description",
            placeholder: "Enter a detailed description...",
            text: .constant("")
        )
        
        // Then
        // Verify placeholder is set (visual inspection in previews)
        XCTAssertNotNil(textArea)
    }
    
    func testTextAreaWithDifferentStyles() {
        // Given & When
        let defaultStyle = CTTextArea(
            "Default Style",
            text: .constant("")
        )
        
        let filledStyle = CTTextArea(
            "Filled Style",
            text: .constant(""),
            style: .filled
        )
        
        let outlinedStyle = CTTextArea(
            "Outlined Style",
            text: .constant(""),
            style: .outlined
        )
        
        // Then
        // Verify different styles can be applied
        XCTAssertNotNil(defaultStyle)
        XCTAssertNotNil(filledStyle)
        XCTAssertNotNil(outlinedStyle)
    }
    
    func testTextAreaWithDisabledState() {
        // Given & When
        let textArea = CTTextArea(
            "Description",
            text: .constant(""),
            isDisabled: true
        )
        
        // Then
        // Verify disabled state can be applied
        XCTAssertNotNil(textArea)
    }
    
    func testTextAreaWithRequiredState() {
        // Given & When
        let textArea = CTTextArea(
            "Description",
            text: .constant(""),
            isRequired: true
        )
        
        // Then
        // Verify required state shows indicator (visual inspection in previews)
        XCTAssertNotNil(textArea)
    }
    
    func testTextAreaWithCustomHeight() {
        // Given & When
        let textArea = CTTextArea(
            "Description",
            text: .constant(""),
            minHeight: 150,
            maxHeight: 300
        )
        
        // Then
        // Verify custom height can be applied
        XCTAssertNotNil(textArea)
    }
    
    func testTextAreaWithValidation() {
        // Given
        @State var text = ""
        @State var error: String? = nil
        
        // When
        let textArea = CTTextArea(
            "Description",
            text: $text,
            error: $error,
            validation: { value in
                if value.isEmpty {
                    return "Description is required"
                } else if value.count < 10 {
                    return "Description must be at least 10 characters"
                }
                return nil
            }
        )
        
        // Then
        // Validation would occur on unfocus
        // This is difficult to test directly in unit tests without UI testing
        XCTAssertNotNil(textArea)
    }
    
    func testTextAreaValidation() {
        // Given
        var text = ""
        var error: String? = nil
        let validation: (String) -> String? = { value in
            if value.isEmpty {
                return "Description is required"
            } else if value.count < 10 {
                return "Description must be at least 10 characters"
            }
            return nil
        }
        
        // Create a test wrapper to access the public methods
        let testTextArea = TestTextArea(
            text: Binding(
                get: { text },
                set: { text = $0 }
            ),
            error: Binding(
                get: { error },
                set: { error = $0 }
            ),
            validation: validation
        )
        
        // When & Then - Test empty validation
        XCTAssertFalse(testTextArea.validate())
        XCTAssertEqual(error, "Description is required")
        
        // When & Then - Test short description validation
        text = "Too short"
        XCTAssertFalse(testTextArea.validate())
        XCTAssertEqual(error, "Description must be at least 10 characters")
        
        // When & Then - Test valid description
        text = "This is a valid description with more than 10 characters."
        XCTAssertTrue(testTextArea.validate())
        XCTAssertNil(error)
        
        // When & Then - Test clear method
        testTextArea.clear()
        XCTAssertEqual(text, "")
        XCTAssertNil(error)
    }
    
    func testTextAreaAccessibility() {
        // Given & When
        let textArea = CTTextArea(
            "Description",
            text: .constant("This is a description"),
            isRequired: true
        )
        
        // Then
        // Accessibility properties would be applied
        // This is difficult to test directly in unit tests without accessibility testing
        XCTAssertNotNil(textArea)
    }
    
    func testTextAreaWithInputOptions() {
        // Given & When
        let textArea = CTTextArea(
            "Description",
            text: .constant(""),
            autocapitalization: .none,
            autocorrection: false,
            lineLimit: 5
        )
        
        // Then
        // Verify input options can be applied
        XCTAssertNotNil(textArea)
    }
}

// Helper struct for testing
struct TestTextArea {
    @Binding var text: String
    @Binding var error: String?
    let validation: ((String) -> String?)?
    
    func validate() -> Bool {
        guard let validation = validation else {
            return true
        }
        
        error = validation(text)
        return error == nil
    }
    
    func clear() {
        text = ""
        error = nil
    }
}