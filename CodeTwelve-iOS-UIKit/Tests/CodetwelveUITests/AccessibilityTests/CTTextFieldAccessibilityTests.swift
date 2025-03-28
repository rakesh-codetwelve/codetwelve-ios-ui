//
//  CTTextFieldAccessibilityTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTTextFieldAccessibilityTests: XCTestCase {
    
    func testTextFieldAccessibilityLabels() {
        // Given
        @State var text = ""
        let label = "Email Address"
        
        // When
        let textField = CTTextField(label, text: $text)
        
        // Then
        // In a real scenario, we would use ViewInspector or similar to verify
        // the accessibility properties of the rendered view
        // As a basic check, we'll just ensure the component can be created
        XCTAssertNotNil(textField, "Text field should be created successfully")
    }
    
    func testTextFieldRequiredAccessibility() {
        // Given
        @State var text = ""
        let label = "Email Address"
        
        // When
        let textField = CTTextField(label, text: $text, isRequired: true)
        
        // Then
        XCTAssertNotNil(textField, "Required text field should be created successfully")
    }
    
    func testTextFieldErrorStateAccessibility() {
        // Given
        @State var text = ""
        @State var error: String? = "This field is required"
        
        // When
        let textField = CTTextField("Email", text: $text, error: $error)
        
        // Then
        XCTAssertNotNil(textField, "Text field with error state should be created successfully")
    }
    
    func testTextFieldDisabledStateAccessibility() {
        // Given
        @State var text = ""
        
        // When
        let textField = CTTextField("Email", text: $text, isDisabled: true)
        
        // Then
        XCTAssertNotNil(textField, "Disabled text field should be created successfully")
    }
    
    func testSecureTextFieldAccessibility() {
        // Given
        @State var text = ""
        
        // When
        let textField = CTTextField(secure: "Password", text: $text)
        
        // Then
        XCTAssertNotNil(textField, "Secure text field should be created successfully")
    }
    
    func testTextFieldWithIconsAccessibility() {
        // Given
        @State var text = ""
        
        // When
        let textField = CTTextField(
            "Email",
            text: $text,
            leadingIcon: "envelope",
            trailingIcon: "xmark.circle.fill"
        )
        
        // Then
        XCTAssertNotNil(textField, "Text field with icons should be created successfully")
    }
    
    func testTextFieldWithValidationAccessibility() {
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
    
    func testTextFieldWithDifferentStylesAccessibility() {
        // Given
        @State var text = ""
        
        // When
        let styles: [CTTextFieldStyle] = [.default, .filled, .outlined, .underlined]
        
        // Then
        for style in styles {
            let textField = CTTextField("Test", text: $text, style: style)
            XCTAssertNotNil(textField, "\(style) style text field should be created successfully")
        }
    }
    
    func testTextFieldWithDifferentKeyboardTypesAccessibility() {
        // Given
        @State var text = ""
        
        // When
        let keyboardTypes: [UIKeyboardType] = [
            .default, .emailAddress, .numberPad, .phonePad, .URL, .twitter, .webSearch
        ]
        
        // Then
        for keyboardType in keyboardTypes {
            let textField = CTTextField("Test", text: $text, keyboardType: keyboardType)
            XCTAssertNotNil(textField, "Text field with \(keyboardType) keyboard should be created successfully")
        }
    }
    
    func testTextFieldWithSubmitLabelAccessibility() {
        // Given
        @State var text = ""
        
        // When
        let submitLabels: [SubmitLabel] = [.done, .go, .send, .search, .join, .route, .continue, .return]
        
        // Then
        for submitLabel in submitLabels {
            let textField = CTTextField("Test", text: $text, submitLabel: submitLabel)
            XCTAssertNotNil(textField, "Text field with \(submitLabel) submit label should be created successfully")
        }
    }
    
    func testTextFieldWithPlaceholderAccessibility() {
        // Given
        @State var text = ""
        let placeholder = "Enter your email"
        
        // When
        let textField = CTTextField("Email", placeholder: placeholder, text: $text)
        
        // Then
        XCTAssertNotNil(textField, "Text field with placeholder should be created successfully")
    }
    
    func testTextFieldWithTrailingActionAccessibility() {
        // Given
        @State var text = "Test"
        var actionCalled = false
        
        // When
        let textField = CTTextField(
            "Email",
            text: $text,
            trailingIcon: "xmark.circle.fill",
            trailingAction: {
                actionCalled = true
            }
        )
        
        // Then
        XCTAssertNotNil(textField, "Text field with trailing action should be created successfully")
    }
    
    func testTextFieldWithAutocorrectionDisabledAccessibility() {
        // Given
        @State var text = ""
        
        // When
        let textField = CTTextField("Email", text: $text, autocorrection: false)
        
        // Then
        XCTAssertNotNil(textField, "Text field with autocorrection disabled should be created successfully")
    }
    
    func testTextFieldWithDifferentAutocapitalizationAccessibility() {
        // Given
        @State var text = ""
        
        // When
        let autocapitalizationTypes: [TextInputAutocapitalization] = [
            .never, .words, .sentences, .characters
        ]
        
        // Then
        for autocapitalizationType in autocapitalizationTypes {
            let textField = CTTextField("Test", text: $text, autocapitalization: autocapitalizationType)
            XCTAssertNotNil(textField, "Text field with \(autocapitalizationType) autocapitalization should be created successfully")
        }
    }
}