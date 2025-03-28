//
//  TextFieldExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases the CTTextField component with various configurations.
struct TextFieldExamples: View {
    // MARK: - State Properties
    
    @State private var basicText = ""
    @State private var emailText = ""
    @State private var emailError: String? = nil
    @State private var passwordText = ""
    @State private var passwordVisible = false
    @State private var phoneText = ""
    
    @State private var filledStyleText = ""
    @State private var outlinedStyleText = ""
    @State private var underlinedStyleText = ""
    
    @State private var requiredFieldText = ""
    @State private var disabledFieldText = "This field is disabled"
    
    @State private var showCode = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                stylesSection
                validationSection
                statesSection
                iconsSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Text Fields")
    }
    
    // MARK: - Basic Usage Section
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title2)
                .fontWeight(.bold)
            
            CTTextField(
                "Basic Text Field",
                placeholder: "Enter some text",
                text: $basicText
            )
            
            codeExample("""
            CTTextField(
                "Basic Text Field",
                placeholder: "Enter some text",
                text: $text
            )
            """)
        }
    }
    
    // MARK: - Styles Section
    
    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Styles")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Default Style")
                    .font(.headline)
                
                CTTextField(
                    "Default",
                    placeholder: "Default style",
                    text: $basicText
                )
            }
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Filled Style")
                    .font(.headline)
                
                CTTextField(
                    "Filled",
                    placeholder: "Filled style",
                    text: $filledStyleText,
                    style: .filled
                )
            }
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Outlined Style")
                    .font(.headline)
                
                CTTextField(
                    "Outlined",
                    placeholder: "Outlined style",
                    text: $outlinedStyleText,
                    style: .outlined
                )
            }
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Underlined Style")
                    .font(.headline)
                
                CTTextField(
                    "Underlined",
                    placeholder: "Underlined style",
                    text: $underlinedStyleText,
                    style: .underlined
                )
            }
            
            codeExample("""
            // Default style
            CTTextField(
                "Default",
                placeholder: "Default style",
                text: $text
            )
            
            // Filled style
            CTTextField(
                "Filled",
                placeholder: "Filled style",
                text: $text,
                style: .filled
            )
            
            // Outlined style
            CTTextField(
                "Outlined",
                placeholder: "Outlined style",
                text: $text,
                style: .outlined
            )
            
            // Underlined style
            CTTextField(
                "Underlined",
                placeholder: "Underlined style",
                text: $text,
                style: .underlined
            )
            """)
        }
    }
    
    // MARK: - Validation Section
    
    private var validationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Validation")
                .font(.title2)
                .fontWeight(.bold)
            
            CTTextField(
                "Email",
                placeholder: "Enter your email",
                text: $emailText,
                error: $emailError,
                leadingIcon: "envelope",
                keyboardType: .emailAddress,
                validation: { value in
                    if value.isEmpty {
                        return "Email is required"
                    }
                    
                    if !value.contains("@") || !value.contains(".") {
                        return "Please enter a valid email"
                    }
                    
                    return nil
                }
            )
            
            Button("Validate") {
                _ = validateEmail()
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, CTSpacing.s)
            
            codeExample("""
            @State private var emailText = ""
            @State private var emailError: String? = nil
            
            CTTextField(
                "Email",
                placeholder: "Enter your email",
                text: $emailText,
                error: $emailError,
                leadingIcon: "envelope",
                keyboardType: .emailAddress,
                validation: { value in
                    if value.isEmpty {
                        return "Email is required"
                    }
                    
                    if !value.contains("@") || !value.contains(".") {
                        return "Please enter a valid email"
                    }
                    
                    return nil
                }
            )
            
            // Validate the field
            textField.validate()
            """)
        }
    }
    
    // MARK: - States Section
    
    private var statesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("States")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Required Field")
                    .font(.headline)
                
                CTTextField(
                    "Full Name",
                    placeholder: "Enter your full name",
                    text: $requiredFieldText,
                    isRequired: true
                )
            }
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Disabled Field")
                    .font(.headline)
                
                CTTextField(
                    "Disabled",
                    placeholder: "This field is disabled",
                    text: $disabledFieldText,
                    isDisabled: true
                )
            }
            
            codeExample("""
            // Required field
            CTTextField(
                "Full Name",
                placeholder: "Enter your full name",
                text: $text,
                isRequired: true
            )
            
            // Disabled field
            CTTextField(
                "Disabled",
                placeholder: "This field is disabled",
                text: $text,
                isDisabled: true
            )
            """)
        }
    }
    
    // MARK: - Icons Section
    
    private var iconsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Icons & Secure Field")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("With Icons")
                    .font(.headline)
                
                CTTextField(
                    "Phone",
                    placeholder: "Enter your phone number",
                    text: $phoneText,
                    leadingIcon: "phone",
                    trailingIcon: "xmark.circle.fill",
                    trailingAction: {
                        phoneText = ""
                    },
                    keyboardType: .phonePad
                )
            }
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Secure Field")
                    .font(.headline)
                
                CTSecureField(
                    "Password",
                    placeholder: "Enter your password",
                    text: $passwordText,
                    leadingIcon: "lock",
                    isRequired: true,
                    showPasswordToggle: true
                )
            }
            
            codeExample("""
            // Field with icons
            CTTextField(
                "Phone",
                placeholder: "Enter your phone number",
                text: $phoneText,
                leadingIcon: "phone",
                trailingIcon: "xmark.circle.fill",
                trailingAction: {
                    phoneText = ""
                },
                keyboardType: .phonePad
            )
            
            // Secure field
            CTSecureField(
                "Password",
                placeholder: "Enter your password",
                text: $passwordText,
                leadingIcon: "lock",
                isRequired: true,
                showPasswordToggle: true
            )
            """)
        }
    }
    
    // MARK: - Interactive Section
    
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                // Contact form fields
                CTTextField(
                    "Full Name",
                    placeholder: "Enter your full name",
                    text: $requiredFieldText,
                    leadingIcon: "person.fill",
                    isRequired: true
                )
                
                CTTextField(
                    "Email",
                    placeholder: "Enter your email",
                    text: $emailText,
                    error: $emailError,
                    leadingIcon: "envelope.fill",
                    isRequired: true,
                    keyboardType: .emailAddress
                )
                
                CTTextField(
                    "Phone",
                    placeholder: "Enter your phone number",
                    text: $phoneText,
                    leadingIcon: "phone.fill",
                    keyboardType: .phonePad
                )
                
                CTSecureField(
                    "Password",
                    placeholder: "Enter your password",
                    text: $passwordText,
                    leadingIcon: "lock.fill",
                    isRequired: true,
                    showPasswordToggle: true
                )
                
                // Submit button
                CTButton("Submit Form", style: .primary, isDisabled: !isFormValid) {
                    validateForm()
                }
                .padding(.top, CTSpacing.s)
            }
            .padding()
            .background(Color.ctSurface)
            .cornerRadius(12)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Displays a code example with proper formatting
    private func codeExample(_ code: String) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Example Code")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    showCode.toggle()
                }) {
                    Text(showCode ? "Hide Code" : "Show Code")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if showCode {
                Text(code)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
    }
    
    /// Validates the email field
    private func validateEmail() -> Bool {
        if emailText.isEmpty {
            emailError = "Email is required"
            return false
        }
        
        if !emailText.contains("@") || !emailText.contains(".") {
            emailError = "Please enter a valid email"
            return false
        }
        
        emailError = nil
        return true
    }
    
    /// Validates the entire form
    private func validateForm() {
        let emailValid = validateEmail()
        
        let nameValid = !requiredFieldText.isEmpty
        let passwordValid = !passwordText.isEmpty
        
        if emailValid && nameValid && passwordValid {
            // Form is valid, handle submission
            print("Form is valid and ready for submission")
        } else {
            // Form is invalid
            print("Please fix the errors in the form")
        }
    }
    
    /// Checks if the form is valid for submission
    private var isFormValid: Bool {
        return !requiredFieldText.isEmpty &&
               !emailText.isEmpty && emailText.contains("@") &&
               !passwordText.isEmpty
    }
}

struct TextFieldExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TextFieldExamples()
        }
    }
}
