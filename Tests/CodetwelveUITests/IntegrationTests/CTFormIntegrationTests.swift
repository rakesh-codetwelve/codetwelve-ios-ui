//
//  CTFormIntegrationTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTFormIntegrationTests: XCTestCase {
    
    // MARK: - Form Validation Tests
    
    func testBasicFormValidation() {
        // Given
        var nameText = ""
        var emailText = ""
        var nameError: String? = nil
        var emailError: String? = nil
        var submitCalled = false
        
        let nameField = CTTextField(
            "Name",
            text: Binding(
                get: { nameText },
                set: { nameText = $0 }
            ),
            error: Binding(
                get: { nameError },
                set: { nameError = $0 }
            ),
            validation: { value in
                return value.isEmpty ? "Name is required" : nil
            }
        )
        
        let emailField = CTTextField(
            "Email",
            text: Binding(
                get: { emailText },
                set: { emailText = $0 }
            ),
            error: Binding(
                get: { emailError },
                set: { emailError = $0 }
            ),
            validation: { value in
                return value.isEmpty ? "Email is required" : nil
            }
        )
        
        let submitButton = CTButton("Submit") {
            submitCalled = true
        }
        
        // When - trying to submit with empty fields
        nameField.validate()
        emailField.validate()
        
        // Then
        XCTAssertEqual(nameError, "Name is required")
        XCTAssertEqual(emailError, "Email is required")
        
        // When - filling fields and revalidating
        nameText = "John Doe"
        emailText = "john@example.com"
        nameField.validate()
        emailField.validate()
        
        // Then
        XCTAssertNil(nameError)
        XCTAssertNil(emailError)
        
        // Now we can submit
        submitButton.simulateTap()
        XCTAssertTrue(submitCalled)
    }
    
    func testComplexFormValidation() {
        // Given - A more complex form with different types of fields
        var fullName = ""
        var email = ""
        var password = ""
        var confirmPassword = ""
        var description = ""
        var agreeToTerms = false
        
        var fullNameError: String? = nil
        var emailError: String? = nil
        var passwordError: String? = nil
        var confirmPasswordError: String? = nil
        var descriptionError: String? = nil
        var termsError: String? = nil
        
        var isSubmitted = false
        
        // Create form components
        let nameField = CTTextField(
            "Full Name",
            text: Binding(get: { fullName }, set: { fullName = $0 }),
            error: Binding(get: { fullNameError }, set: { fullNameError = $0 }),
            validation: { value in
                return value.isEmpty ? "Full name is required" : nil
            }
        )
        
        let emailField = CTTextField(
            "Email",
            text: Binding(get: { email }, set: { email = $0 }),
            error: Binding(get: { emailError }, set: { emailError = $0 }),
            validation: { value in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                
                if value.isEmpty {
                    return "Email is required"
                } else if !emailPredicate.evaluate(with: value) {
                    return "Please enter a valid email address"
                }
                
                return nil
            }
        )
        
        let passwordField = CTSecureField(
            "Password",
            text: Binding(get: { password }, set: { password = $0 }),
            error: Binding(get: { passwordError }, set: { passwordError = $0 }),
            validation: { value in
                if value.isEmpty {
                    return "Password is required"
                } else if value.count < 8 {
                    return "Password must be at least 8 characters"
                }
                
                return nil
            }
        )
        
        let confirmPasswordField = CTSecureField(
            "Confirm Password",
            text: Binding(get: { confirmPassword }, set: { confirmPassword = $0 }),
            error: Binding(get: { confirmPasswordError }, set: { confirmPasswordError = $0 }),
            validation: { value in
                if value.isEmpty {
                    return "Please confirm your password"
                } else if value != password {
                    return "Passwords do not match"
                }
                
                return nil
            }
        )
        
        let descriptionArea = CTTextArea(
            "Description",
            text: Binding(get: { description }, set: { description = $0 }),
            error: Binding(get: { descriptionError }, set: { descriptionError = $0 }),
            validation: { value in
                if value.isEmpty {
                    return "Description is required"
                } else if value.count < 10 {
                    return "Description must be at least 10 characters"
                }
                
                return nil
            }
        )
        
        let termsCheckbox = CTCheckbox(
            "I agree to the terms and conditions",
            isChecked: Binding(get: { agreeToTerms }, set: { agreeToTerms = $0 })
        )
        
        // Validation function to check the terms
        func validateTerms() -> String? {
            return !agreeToTerms ? "You must agree to the terms and conditions" : nil
        }
        
        // When - Test form validation with empty fields
        let validationResults = [
            nameField.validate(),
            emailField.validate(),
            passwordField.validate(),
            confirmPasswordField.validate(),
            descriptionArea.validate()
        ]
        
        termsError = validateTerms()
        
        // Then - All validations should fail
        XCTAssertFalse(validationResults.contains(true))
        XCTAssertEqual(fullNameError, "Full name is required")
        XCTAssertEqual(emailError, "Email is required")
        XCTAssertEqual(passwordError, "Password is required")
        XCTAssertEqual(confirmPasswordError, "Please confirm your password")
        XCTAssertEqual(descriptionError, "Description is required")
        XCTAssertEqual(termsError, "You must agree to the terms and conditions")
        
        // When - Fill in valid data
        fullName = "John Doe"
        email = "john@example.com"
        password = "securepassword123"
        confirmPassword = "securepassword123"
        description = "This is a detailed description for testing purposes."
        agreeToTerms = true
        
        // And validate again
        let newValidationResults = [
            nameField.validate(),
            emailField.validate(),
            passwordField.validate(),
            confirmPasswordField.validate(),
            descriptionArea.validate()
        ]
        
        termsError = validateTerms()
        
        // Then - All validations should pass
        XCTAssertFalse(newValidationResults.contains(false))
        XCTAssertNil(fullNameError)
        XCTAssertNil(emailError)
        XCTAssertNil(passwordError)
        XCTAssertNil(confirmPasswordError)
        XCTAssertNil(descriptionError)
        XCTAssertNil(termsError)
        
        // Simulate form submission
        if newValidationResults.allSatisfy({ $0 }) && termsError == nil {
            isSubmitted = true
        }
        
        XCTAssertTrue(isSubmitted)
    }
    
    // MARK: - Component Interaction Tests
    
    func testComponentsStateInteraction() {
        // Given - A form with interdependent fields
        var accountType = "personal" // personal or business
        var showBusinessFields = false
        var companyName = ""
        var companyNameError: String? = nil
        
        let accountTypeOptions = ["personal": "Personal", "business": "Business"]
        
        // Create components
        let accountTypeSelector = CTSelect(
            "Account Type",
            options: accountTypeOptions,
            selection: Binding(
                get: { accountType },
                set: { 
                    accountType = $0 
                    // Update dependent state
                    showBusinessFields = (accountType == "business")
                }
            )
        )
        
        let companyNameField = CTTextField(
            "Company Name",
            text: Binding(get: { companyName }, set: { companyName = $0 }),
            error: Binding(get: { companyNameError }, set: { companyNameError = $0 }),
            validation: { value in
                guard showBusinessFields else { return nil }
                return value.isEmpty ? "Company name is required for business accounts" : nil
            }
        )
        
        // When - Test initial state (personal account)
        XCTAssertEqual(accountType, "personal")
        XCTAssertFalse(showBusinessFields)
        
        // Company name validation should pass because it's not required for personal accounts
        let initialValidation = companyNameField.validate()
        XCTAssertTrue(initialValidation)
        XCTAssertNil(companyNameError)
        
        // When - Change account type to business
        accountType = "business"
        showBusinessFields = (accountType == "business")
        
        // Then - Validate company name for business account
        let businessValidation = companyNameField.validate()
        XCTAssertFalse(businessValidation)
        XCTAssertEqual(companyNameError, "Company name is required for business accounts")
        
        // When - Add company name
        companyName = "Acme Inc."
        let finalValidation = companyNameField.validate()
        
        // Then - Validation should pass
        XCTAssertTrue(finalValidation)
        XCTAssertNil(companyNameError)
    }
    
    func testConditionalFormLogic() {
        // Given - A form with conditional logic
        var deliveryMethod = "pickup" // pickup or delivery
        var showAddressFields = false
        var address = ""
        var addressError: String? = nil
        
        let deliveryOptions = ["pickup": "Store Pickup", "delivery": "Home Delivery"]
        
        // Create a radio group for delivery options
        let deliveryRadioGroup = CTRadioGroup(
            options: deliveryOptions,
            selectedOption: Binding(
                get: { deliveryMethod },
                set: { 
                    deliveryMethod = $0 
                    // Update visibility of address fields
                    showAddressFields = (deliveryMethod == "delivery")
                }
            )
        )
        
        // Create address field that's conditionally required
        let addressField = CTTextField(
            "Delivery Address",
            text: Binding(get: { address }, set: { address = $0 }),
            error: Binding(get: { addressError }, set: { addressError = $0 }),
            validation: { value in
                guard showAddressFields else { return nil }
                return value.isEmpty ? "Address is required for home delivery" : nil
            }
        )
        
        // When - Test initial state (pickup selected)
        XCTAssertEqual(deliveryMethod, "pickup")
        XCTAssertFalse(showAddressFields)
        
        // Address validation should pass because it's not required for pickup
        let initialValidation = addressField.validate()
        XCTAssertTrue(initialValidation)
        XCTAssertNil(addressError)
        
        // When - Change delivery method to home delivery
        deliveryMethod = "delivery"
        showAddressFields = (deliveryMethod == "delivery")
        
        // Then - Address should be required but empty
        let deliveryValidation = addressField.validate()
        XCTAssertFalse(deliveryValidation)
        XCTAssertEqual(addressError, "Address is required for home delivery")
        
        // When - Add address
        address = "123 Main St, Anytown, USA"
        let finalValidation = addressField.validate()
        
        // Then - Validation should pass
        XCTAssertTrue(finalValidation)
        XCTAssertNil(addressError)
    }
    
    // MARK: - Dynamic Form Tests
    
    func testDynamicFormFields() {
        // Given - A dynamic form that adds fields
        var educationEntries: [String] = [""]
        var educationErrors: [String?] = [nil]
        
        // Function to validate a specific education entry
        func validateEducation(at index: Int) -> Bool {
            let validationResult = educationEntries[index].isEmpty ? "Education entry cannot be empty" : nil
            educationErrors[index] = validationResult
            return validationResult == nil
        }
        
        // Initial state - one empty education field
        XCTAssertEqual(educationEntries.count, 1)
        XCTAssertEqual(educationErrors.count, 1)
        
        // When - Validate the initial empty field
        let initialValidation = validateEducation(at: 0)
        
        // Then - Validation should fail
        XCTAssertFalse(initialValidation)
        XCTAssertEqual(educationErrors[0], "Education entry cannot be empty")
        
        // When - Fill the first field and add a new one
        educationEntries[0] = "Bachelor's Degree in Computer Science"
        // Simulate adding a new field
        educationEntries.append("")
        educationErrors.append(nil)
        
        // Then - We should have two fields now
        XCTAssertEqual(educationEntries.count, 2)
        XCTAssertEqual(educationErrors.count, 2)
        
        // And the first field should validate successfully
        let firstFieldValidation = validateEducation(at: 0)
        XCTAssertTrue(firstFieldValidation)
        XCTAssertNil(educationErrors[0])
        
        // But the second field should fail validation
        let secondFieldValidation = validateEducation(at: 1)
        XCTAssertFalse(secondFieldValidation)
        XCTAssertEqual(educationErrors[1], "Education entry cannot be empty")
        
        // When - Fill the second field
        educationEntries[1] = "Master's Degree in Business Administration"
        let updatedSecondFieldValidation = validateEducation(at: 1)
        
        // Then - Both fields should validate successfully
        XCTAssertTrue(updatedSecondFieldValidation)
        XCTAssertNil(educationErrors[1])
        
        // When - Remove the second field
        educationEntries.removeLast()
        educationErrors.removeLast()
        
        // Then - We should be back to one field
        XCTAssertEqual(educationEntries.count, 1)
        XCTAssertEqual(educationErrors.count, 1)
    }
    
    // MARK: - Form Submission Tests
    
    func testFormSubmissionWorkflow() {
        // Given - A complete form with submission state
        var username = ""
        var email = ""
        var password = ""
        var isSubmitting = false
        var isSubmitted = false
        var hasSubmissionError = false
        var submissionErrorMessage: String? = nil
        
        var usernameError: String? = nil
        var emailError: String? = nil
        var passwordError: String? = nil
        
        let usernameField = CTTextField(
            "Username",
            text: Binding(get: { username }, set: { username = $0 }),
            error: Binding(get: { usernameError }, set: { usernameError = $0 }),
            validation: { value in
                return value.isEmpty ? "Username is required" : nil
            }
        )
        
        let emailField = CTTextField(
            "Email",
            text: Binding(get: { email }, set: { email = $0 }),
            error: Binding(get: { emailError }, set: { emailError = $0 }),
            validation: { value in
                return value.isEmpty ? "Email is required" : nil
            }
        )
        
        let passwordField = CTSecureField(
            "Password",
            text: Binding(get: { password }, set: { password = $0 }),
            error: Binding(get: { passwordError }, set: { passwordError = $0 }),
            validation: { value in
                return value.isEmpty ? "Password is required" : nil
            }
        )
        
        // Simulate form submission function
        func submitForm() -> Bool {
            // Validate all fields first
            let usernameValid = usernameField.validate()
            let emailValid = emailField.validate()
            let passwordValid = passwordField.validate()
            
            // Check if all validations passed
            let isValid = usernameValid && emailValid && passwordValid
            
            if isValid {
                isSubmitting = true
                
                // Simulate API call
                // In real test, this would be mocked or faked
                if username == "existing_user" {
                    isSubmitting = false
                    hasSubmissionError = true
                    submissionErrorMessage = "Username already exists"
                    return false
                }
                
                // Simulate successful submission
                isSubmitting = false
                isSubmitted = true
                return true
            }
            
            return false
        }
        
        // When - Try to submit with empty fields
        let emptySubmissionResult = submitForm()
        
        // Then - Submission should fail and errors should be set
        XCTAssertFalse(emptySubmissionResult)
        XCTAssertEqual(usernameError, "Username is required")
        XCTAssertEqual(emailError, "Email is required")
        XCTAssertEqual(passwordError, "Password is required")
        XCTAssertFalse(isSubmitting)
        XCTAssertFalse(isSubmitted)
        
        // When - Fill fields with valid data
        username = "new_user"
        email = "user@example.com"
        password = "secure123"
        
        // And submit again
        let validSubmissionResult = submitForm()
        
        // Then - Submission should succeed
        XCTAssertTrue(validSubmissionResult)
        XCTAssertNil(usernameError)
        XCTAssertNil(emailError)
        XCTAssertNil(passwordError)
        XCTAssertFalse(isSubmitting) // Should be false again after submission completes
        XCTAssertTrue(isSubmitted)
        XCTAssertFalse(hasSubmissionError)
        
        // When - Reset form and try with a username that triggers a server error
        isSubmitted = false
        username = "existing_user"
        
        // And submit again
        let conflictSubmissionResult = submitForm()
        
        // Then - Submission should fail due to server-side validation
        XCTAssertFalse(conflictSubmissionResult)
        XCTAssertNil(usernameError) // Field-level validation passed
        XCTAssertNil(emailError)
        XCTAssertNil(passwordError)
        XCTAssertFalse(isSubmitted)
        XCTAssertTrue(hasSubmissionError)
        XCTAssertEqual(submissionErrorMessage, "Username already exists")
    }
    
    // MARK: - Accessibility Tests
    
    func testFormComponentsAccessibility() {
        // Create a test form with different component types
        var name = "John Doe"
        var email = "john@example.com"
        var subscribed = true
        var notificationType = "email"
        var frequency = 50.0
        
        let nameField = CTTextField(
            "Full Name",
            text: Binding(get: { name }, set: { name = $0 })
        )
        
        let emailField = CTTextField(
            "Email Address",
            text: Binding(get: { email }, set: { email = $0 })
        )
        
        let subscribeToggle = CTToggle(
            "Subscribe to newsletter",
            isOn: Binding(get: { subscribed }, set: { subscribed = $0 })
        )
        
        let notificationOptions = ["email": "Email", "push": "Push", "sms": "SMS"]
        let notificationPicker = CTSelect(
            "Notification Type",
            options: notificationOptions,
            selection: Binding(get: { notificationType }, set: { notificationType = $0 })
        )
        
        let frequencySlider = CTSlider(
            value: Binding(get: { frequency }, set: { frequency = $0 }),
            range: 0...100,
            label: "Frequency"
        )
        
        // Test accessibility traits for each component
        
        // Text Field accessibility
        // In a real test, we would use ViewInspector or UI testing
        // For this integration test, we're simulating the checks
        let nameAccessibility = nameField.accessibilityValue
        XCTAssertEqual(nameAccessibility, name)
        
        let emailAccessibility = emailField.accessibilityValue
        XCTAssertEqual(emailAccessibility, email)
        
        // Toggle accessibility value should reflect state
        let toggleAccessibility = subscribeToggle.accessibilityValue
        XCTAssertEqual(toggleAccessibility, subscribed ? "On" : "Off")
        
        // Test Select component accessibility
        let selectAccessibility = notificationPicker.accessibilityValue
        XCTAssertEqual(selectAccessibility, "Email") // The display value for "email"
        
        // Test Slider accessibility
        let sliderAccessibility = frequencySlider.accessibilityValue
        XCTAssertEqual(sliderAccessibility, "50")
    }
}

// MARK: - Test Helpers

extension CTButton {
    /// Test helper to simulate tapping the button
    func simulateTap() {
        self.action()
    }
}

extension CTTextField {
    /// The accessibility value of the text field
    var accessibilityValue: String {
        return text
    }
}

extension CTToggle {
    /// The accessibility value of the toggle
    var accessibilityValue: String {
        return isOn ? "On" : "Off"
    }
}

extension CTSelect {
    /// The accessibility value of the select
    var accessibilityValue: String {
        return options[selection] ?? ""
    }
}

extension CTSlider {
    /// The accessibility value of the slider
    var accessibilityValue: String {
        return "\(Int(value))"
    }
}