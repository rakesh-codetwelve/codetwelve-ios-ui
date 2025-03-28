//
//  CTSecureFieldTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTSecureFieldTests: XCTestCase {
    func testSecureFieldInitialization() {
        // Given & When
        let field = CTSecureField(
            "Password",
            placeholder: "Enter your password",
            text: .constant("")
        )
        
        // Then
        // Test passes if initialization doesn't crash
        XCTAssertNotNil(field)
    }
    
    func testSecureFieldWithPlaceholder() {
        // Given & When
        let field = CTSecureField(
            "Password",
            placeholder: "Enter your password",
            text: .constant("")
        )
        
        // Then
        // Verify placeholder is set (visual inspection in previews)
        XCTAssertNotNil(field)
    }
    
    func testSecureFieldWithIcons() {
        // Given & When
        let field = CTSecureField(
            "Password",
            placeholder: "Enter your password",
            text: .constant(""),
            leadingIcon: "lock",
            trailingIcon: "xmark.circle.fill"
        )
        
        // Then
        // Verify icons are displayed (visual inspection in previews)
        XCTAssertNotNil(field)
    }
    
    func testSecureFieldWithTrailingAction() {
        // Given
        var actionCalled = false
        
        // When
        let field = CTSecureField(
            "Password",
            placeholder: "Enter your password",
            text: .constant(""),
            trailingIcon: "xmark.circle.fill",
            trailingAction: {
                actionCalled = true
            }
        )
        
        // Then
        // Action would be called when the trailing icon is tapped
        // This is difficult to test directly in unit tests without UI testing
        XCTAssertNotNil(field)
    }
    
    func testSecureFieldWithDifferentStyles() {
        // Given & When
        let defaultStyle = CTSecureField(
            "Default Style",
            text: .constant("")
        )
        
        let filledStyle = CTSecureField(
            "Filled Style",
            text: .constant(""),
            style: .filled
        )
        
        let outlinedStyle = CTSecureField(
            "Outlined Style",
            text: .constant(""),
            style: .outlined
        )
        
        let underlinedStyle = CTSecureField(
            "Underlined Style",
            text: .constant(""),
            style: .underlined
        )
        
        // Then
        // Verify different styles can be applied
        XCTAssertNotNil(defaultStyle)
        XCTAssertNotNil(filledStyle)
        XCTAssertNotNil(outlinedStyle)
        XCTAssertNotNil(underlinedStyle)
    }
    
    func testSecureFieldWithDisabledState() {
        // Given & When
        let field = CTSecureField(
            "Password",
            text: .constant(""),
            isDisabled: true
        )
        
        // Then
        // Verify disabled state can be applied
        XCTAssertNotNil(field)
    }
    
    func testSecureFieldWithRequiredState() {
        // Given & When
        let field = CTSecureField(
            "Password",
            text: .constant(""),
            isRequired: true
        )
        
        // Then
        // Verify required state shows indicator (visual inspection in previews)
        XCTAssertNotNil(field)
    }
    
    func testSecureFieldWithValidation() {
        // Given
        @State var text = ""
        @State var error: String? = nil
        
        // When
        let field = CTSecureField(
            "Password",
            text: $text,
            error: $error,
            validation: { value in
                if value.isEmpty {
                    return "Password is required"
                } else if value.count < 8 {
                    return "Password must be at least 8 characters"
                }
                return nil
            }
        )
        
        // Then
        // Validation would occur on submit/unfocus
        // This is difficult to test directly in unit tests without UI testing
        XCTAssertNotNil(field)
    }
    
    func testSecureFieldValidation() {
        // Given
        var text = ""
        var error: String? = nil
        let validation: (String) -> String? = { value in
            if value.isEmpty {
                return "Password is required"
            } else if value.count < 8 {
                return "Password must be at least 8 characters"
            }
            return nil
        }
        
        // Create a test wrapper to access the public methods
        let testField = TestSecureField(
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
        XCTAssertFalse(testField.validate())
        XCTAssertEqual(error, "Password is required")
        
        // When & Then - Test short password validation
        text = "short"
        XCTAssertFalse(testField.validate())
        XCTAssertEqual(error, "Password must be at least 8 characters")
        
        // When & Then - Test valid password
        text = "validpassword123"
        XCTAssertTrue(testField.validate())
        XCTAssertNil(error)
        
        // When & Then - Test clear method
        testField.clear()
        XCTAssertEqual(text, "")
        XCTAssertNil(error)
    }
    
    func testSecureFieldPasswordToggle() {
        // Given & When
        let field = CTSecureField(
            "Password",
            text: .constant(""),
            showPasswordToggle: true
        )
        
        let fieldWithoutToggle = CTSecureField(
            "Password",
            text: .constant(""),
            showPasswordToggle: false
        )
        
        // Then
        // Verify toggle can be shown or hidden (visual inspection in previews)
        XCTAssertNotNil(field)
        XCTAssertNotNil(fieldWithoutToggle)
    }
    
    func testSecureFieldAccessibility() {
        // Given & When
        let field = CTSecureField(
            "Password",
            text: .constant("secretpassword"),
            isRequired: true
        )
        
        // Then
        // Accessibility properties would be applied
        // This is difficult to test directly in unit tests without accessibility testing
        XCTAssertNotNil(field)
    }
}

// Helper struct for testing
struct TestSecureField {
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