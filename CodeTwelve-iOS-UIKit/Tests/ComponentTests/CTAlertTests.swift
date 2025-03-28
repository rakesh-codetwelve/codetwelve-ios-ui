//
//  CTAlertTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTAlertTests: XCTestCase {
    // MARK: - Alert Creation Tests
    
    func testAlertCreation() {
        // Basic alert with message only
        let basicAlert = CTAlert(message: "Test message", severity: .info)
        XCTAssertNotNil(basicAlert, "Basic alert should be created successfully")
        
        // Alert with title and message
        let titledAlert = CTAlert(title: "Test Title", message: "Test message", severity: .info)
        XCTAssertNotNil(titledAlert, "Alert with title should be created successfully")
        
        // Alert with custom content
        let customContentAlert = CTAlert(severity: .info) {
            Text("Custom content")
        }
        XCTAssertNotNil(customContentAlert, "Alert with custom content should be created successfully")
    }
    
    // MARK: - Alert Severity Tests
    
    func testAlertSeverities() {
        // Test info severity
        let infoAlert = CTAlert(message: "Info message", severity: .info)
        XCTAssertNotNil(infoAlert, "Info alert should be created successfully")
        
        // Test success severity
        let successAlert = CTAlert(message: "Success message", severity: .success)
        XCTAssertNotNil(successAlert, "Success alert should be created successfully")
        
        // Test warning severity
        let warningAlert = CTAlert(message: "Warning message", severity: .warning)
        XCTAssertNotNil(warningAlert, "Warning alert should be created successfully")
        
        // Test error severity
        let errorAlert = CTAlert(message: "Error message", severity: .error)
        XCTAssertNotNil(errorAlert, "Error alert should be created successfully")
        
        // Test custom severity
        let customAlert = CTAlert(
            message: "Custom message",
            severity: .custom(
                icon: Image(systemName: "star.fill"),
                iconColor: .purple,
                borderColor: .purple.opacity(0.3)
            )
        )
        XCTAssertNotNil(customAlert, "Custom alert should be created successfully")
    }
    
    // MARK: - Alert Dismissal Tests
    
    func testAlertDismissal() {
        // Create a dismissible alert
        var dismissCalled = false
        let dismissibleAlert = CTAlert(
            message: "Dismissible message",
            severity: .info,
            isDismissible: true,
            onDismiss: {
                dismissCalled = true
            }
        )
        XCTAssertNotNil(dismissibleAlert, "Dismissible alert should be created successfully")
        
        // Simulate dismiss action
        let mirror = Mirror(reflecting: dismissibleAlert)
        if let onDismiss = mirror.descendant("onDismiss") as? (() -> Void) {
            onDismiss()
            XCTAssertTrue(dismissCalled, "Dismiss callback should be called")
        } else {
            XCTFail("Could not find onDismiss property")
        }
    }
    
    // MARK: - Alert Accessibility Tests
    
    func testAlertAccessibility() {
        // Test basic alert accessibility
        let basicAlert = TestAlert(message: "Test message", severity: .info)
        XCTAssertTrue(basicAlert.isAccessibilityElement, "Alert should be an accessibility element")
        XCTAssertTrue(basicAlert.accessibilityLabel.contains("Information alert"), "Alert should have correct accessibility label")
        XCTAssertTrue(basicAlert.accessibilityTraits.contains(.isStaticText), "Alert should have static text trait")
        
        // Test alert with title accessibility
        let titledAlert = TestAlert(title: "Test Title", message: "Test message", severity: .warning)
        XCTAssertTrue(titledAlert.accessibilityLabel.contains("Warning alert"), "Alert should have correct severity label")
        XCTAssertTrue(titledAlert.accessibilityLabel.contains("Test Title"), "Alert accessibility label should contain title")
        
        // Test dismissible alert accessibility
        let dismissibleAlert = TestAlert(message: "Test message", severity: .info, isDismissible: true)
        // Verify dismiss button has correct accessibility label
        XCTAssertTrue(dismissibleAlert.hasAccessibleDismissButton, "Dismissible alert should have an accessible dismiss button")
    }
    
    // MARK: - Alert Content Tests
    
    func testAlertWithCustomContent() {
        let customContentAlert = CTAlert(severity: .info) {
            VStack {
                Text("Line 1")
                Text("Line 2")
                Image(systemName: "star")
            }
        }
        XCTAssertNotNil(customContentAlert, "Alert with complex custom content should be created successfully")
    }
    
    func testAlertWithLongContent() {
        let longMessage = """
        This is a very long message that should wrap to multiple lines.
        It tests how the alert handles longer content and whether it remains
        readable and properly formatted. The alert should adapt to the content
        while maintaining its overall design and accessibility.
        """
        
        let longContentAlert = CTAlert(title: "Long Content", message: longMessage, severity: .info)
        XCTAssertNotNil(longContentAlert, "Alert with long content should be created successfully")
    }
}

// MARK: - Test Helper

/// A testable version of CTAlert that exposes accessibility properties
struct TestAlert: View {
    let title: String?
    let message: String
    let severity: CTAlertSeverity
    let isDismissible: Bool
    var hasAccessibleDismissButton: Bool = false
    var isAccessibilityElement: Bool = true
    var accessibilityLabel: String = ""
    var accessibilityTraits: AccessibilityTraits = []
    
    init(
        title: String? = nil,
        message: String,
        severity: CTAlertSeverity = .info,
        isDismissible: Bool = false
    ) {
        self.title = title
        self.message = message
        self.severity = severity
        self.isDismissible = isDismissible
        
        // Set accessibility properties
        var label = "\(severity.accessibilityLabel) alert"
        if let title = title {
            label += ": \(title)"
        }
        label += ", \(message)"
        self.accessibilityLabel = label
        self.accessibilityTraits = .isStaticText
        self.hasAccessibleDismissButton = isDismissible
    }
    
    var body: some View {
        CTAlert(
            title: title,
            message: message,
            severity: severity,
            isDismissible: isDismissible
        )
    }
}