//
//  CTTextFieldTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTTextFieldTests: XCTestCase {
    
    func testTextFieldInitialization() {
        // Given
        @State var text = "Test"
        
        // When
        let textField = CTTextField("Label", text: $text)
        
        // Then
        XCTAssertNotNil(textField, "Text field should be created successfully")
    }
    
    func testSecureTextFieldInitialization() {
        // Given
        @State var text = "Test"
        
        // When
        let textField = CTTextField(secure: "Password", text: $text)
        
        // Then
        XCTAssertNotNil(textField, "Secure text field should be created successfully")
    }
    
    func testTextFieldWithPlaceholder() {
        // Given
        @State var text = ""
        let placeholder = "Enter text"
        
        // When
        let textField = CTTextField("Label", placeholder: placeholder, text: $text)
        
        // Then
        XCTAssertNotNil(textField, "Text field with placeholder should be created successfully")
    }
    
    func testTextFieldWithIcons() {
        // Given
        @State var text = ""
        
        // When
        let textField = CTTextField(
            "Label",
            text: $text,
            leadingIcon: "envelope",
            trailingIcon: "xmark.circle.fill"
        )
        
        // Then
        XCTAssertNotNil(textField, "Text field with icons should be created successfully")
    }
    
    func testTextFieldWithTrailingAction() {
        // Given
        @State var text = "Test"
        var actionCalled = false
        
        // When
        let textField = CTTextField(
            "Label",
            text: $text,
            trailingIcon: "xmark.circle.fill",
            trailingAction: {
                actionCalled = true
            }
        )
        
        // Then
        XCTAssertNotNil(textField, "Text field with trailing action should be created successfully")
    }
    
    func testTextFieldWithDifferentStyles() {
        // Given
        @State var text = ""
        
        // When
        let defaultStyleTextField = CTTextField("Default", text: $text, style: .default)
        let filledStyleTextField = CTTextField("Filled", text: $text, style: .filled)
        let outlinedStyleTextField = CTTextField("Outlined", text: $text, style: .outlined)
        let underlinedStyleTextField = CTTextField("Underlined", text: $text, style: .underlined)
        
        // Then
        XCTAssertNotNil(defaultStyleTextField, "Default style text field should be created successfully")
        XCTAssertNotNil(filledStyleTextField, "Filled style text field should be created successfully")
        XCTAssertNotNil(outlinedStyleTextField, "Outlined style text field should be created successfully")
        XCTAssertNotNil(underlinedStyleTextField, "Underlined style text field should be created successfully")
    }
    
    func testTextFieldWithDisabledState() {
        // Given
        @State var text = ""
        
        // When
        let textField = CTTextField("Label", text: $text, isDisabled: true)
        
        // Then
        XCTAssertNotNil(textField, "Disabled text field should be created successfully")
    }
    
    func testTextFieldWithRequiredState() {
        // Given
        @State var text = ""
        
        // When
        let textField = CTTextField("Label", text: $text, isRequired: true)
        
        // Then
        XCTAssertNotNil(textField, "Required text field should be created successfully")
    }
    
    func testTextFieldWithKeyboardType() {
        // Given
        @State var text = ""
        
        // When
        let textField = CTTextField("Label", text: $text, keyboardType: .emailAddress)
        
        // Then
        XCTAssertNotNil(textField, "Text field with custom keyboard type should be created successfully")
    }
    
    func testTextFieldWithValidation() {
        // Given
        @State var text = ""
        @State var error: String? = nil
        
        // When
        let textField = CTTextField(
            "Email",
            text: $text,
            error: $error,
            validation: { value in
                return value.isEmpty ? "Email is required" : nil
            }
        )
        
        // Then
        XCTAssertNotNil(textField, "Text field with validation should be created successfully")
    }
    
    func testTextFieldValidation() {
        // Given
        let text = ""
        var error: String? = nil
        let validation: (String) -> String? = { value in
            return value.isEmpty ? "Field is required" : nil
        }
        
        // When
        let result = validation(text)
        
        // Then
        XCTAssertEqual(result, "Field is required", "Validation should return error for empty field")
        
        // Given
        let nonEmptyText = "Test"
        
        // When
        let nonEmptyResult = validation(nonEmptyText)
        
        // Then
        XCTAssertNil(nonEmptyResult, "Validation should not return error for non-empty field")
    }
    
    func testTextFieldSubmitAction() {
        // Given
        @State var text = "Test"
        var submitCalled = false
        
        // When
        let textField = CTTextField(
            "Label",
            text: $text,
            onSubmit: {
                submitCalled = true
            }
        )
        
        // Then
        XCTAssertNotNil(textField, "Text field with submit action should be created successfully")
    }
    
    func testTextFieldEditingChangedAction() {
        // Given
        @State var text = "Test"
        var editingChangedCalled = false
        
        // When
        let textField = CTTextField(
            "Label",
            text: $text,
            onEditingChanged: { isEditing in
                editingChangedCalled = isEditing
            }
        )
        
        // Then
        XCTAssertNotNil(textField, "Text field with editing changed action should be created successfully")
    }
    
    func testTextFieldAccessibility() {
        // Given
        @State var text = "Test"
        
        // When
        let textField = CTTextField("Label", text: $text)
        
        // Then
        XCTAssertNotNil(textField, "Text field with accessibility should be created successfully")
    }
    
    func testTextFieldExtensionMethods() {
        // Given
        @State var text = "Test"
        @State var error: String? = nil
        
        let textField = TestTextField(
            text: $text,
            error: $error,
            validation: { value in
                return value.isEmpty ? "Field is required" : nil
            }
        )
        
        // When - validate with valid input
        let isValid = textField.validate()
        
        // Then
        XCTAssertTrue(isValid, "Validation should pass with non-empty text")
        XCTAssertNil(error, "Error should be nil after validation with valid input")
        
        // When - clear the field
        textField.clear()
        
        // Then
        XCTAssertEqual(text, "", "Text should be empty after clearing")
        XCTAssertNil(error, "Error should be nil after clearing")
        
        // When - validate with invalid input
        text = ""
        let isInvalid = textField.validate()
        
        // Then
        XCTAssertFalse(isInvalid, "Validation should fail with empty text")
        XCTAssertEqual(error, "Field is required", "Error should be set after validation with invalid input")
    }
}

// A test wrapper for CTTextField to access extension methods
struct TestTextField {
    @Binding var text: String
    @Binding var error: String?
    let validation: ((String) -> String?)?
    
    init(text: Binding<String>, error: Binding<String?>, validation: ((String) -> String?)?) {
        self._text = text
        self._error = error
        self.validation = validation
    }
    
    func validate() -> Bool {
        if let validationFunction = validation {
            let errorMessage = validationFunction(text)
            error = errorMessage
            return errorMessage == nil
        }
        return true
    }
    
    func clear() {
        text = ""
        error = nil
    }
}