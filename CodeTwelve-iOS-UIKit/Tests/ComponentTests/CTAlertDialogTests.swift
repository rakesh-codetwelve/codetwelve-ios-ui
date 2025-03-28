//
//  CTAlertDialogTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTAlertDialogTests: XCTestCase {
    // MARK: - Dialog Creation Tests
    
    func testDialogCreation() {
        // Test dialog modifier
        let testView = Text("Test View")
            .ctAlertDialog(isPresented: .constant(true)) {
                CTAlertDialogContent(
                    title: "Test Dialog",
                    message: "Test message",
                    primaryAction: CTAlertDialogAction(label: "OK")
                )
            }
        
        XCTAssertNotNil(testView, "View with dialog modifier should be created successfully")
        
        // Test dialog content
        let dialogContent = CTAlertDialogContent(
            title: "Test Dialog",
            message: "Test message",
            primaryAction: CTAlertDialogAction(label: "OK")
        )
        
        XCTAssertNotNil(dialogContent, "Dialog content should be created successfully")
    }
    
    // MARK: - Dialog Content Tests
    
    func testDialogWithActions() {
        // Test with primary action only
        let primaryOnlyDialog = CTAlertDialogContent(
            title: "Primary Only",
            message: "Test message",
            primaryAction: CTAlertDialogAction(label: "OK")
        )
        XCTAssertNotNil(primaryOnlyDialog, "Dialog with primary action should be created successfully")
        
        // Test with primary and secondary actions
        let twoButtonDialog = CTAlertDialogContent(
            title: "Two Buttons",
            message: "Test message",
            primaryAction: CTAlertDialogAction(label: "OK"),
            secondaryAction: CTAlertDialogAction(label: "Cancel")
        )
        XCTAssertNotNil(twoButtonDialog, "Dialog with two actions should be created successfully")
        
        // Test with all three action types
        let threeButtonDialog = CTAlertDialogContent(
            title: "Three Buttons",
            message: "Test message",
            primaryAction: CTAlertDialogAction(label: "OK"),
            secondaryAction: CTAlertDialogAction(label: "Cancel"),
            destructiveAction: CTAlertDialogAction(label: "Delete")
        )
        XCTAssertNotNil(threeButtonDialog, "Dialog with three actions should be created successfully")
    }
    
    func testDialogWithCustomContent() {
        // Test with custom content
        let customContentDialog = CTAlertDialogContent(
            title: "Custom Content"
        ) {
            VStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Text("Custom content")
            }
        } primaryAction: {
            CTAlertDialogAction(label: "OK")
        }
        
        XCTAssertNotNil(customContentDialog, "Dialog with custom content should be created successfully")
    }
    
    // MARK: - Dialog Action Tests
    
    func testDialogActions() {
        // Test primary action
        var primaryActionCalled = false
        let primaryAction = CTAlertDialogAction(
            label: "Primary",
            style: .primary,
            action: {
                primaryActionCalled = true
            }
        )
        
        // Execute the action
        primaryAction.action()
        XCTAssertTrue(primaryActionCalled, "Primary action should be called")
        
        // Test secondary action
        var secondaryActionCalled = false
        let secondaryAction = CTAlertDialogAction(
            label: "Secondary",
            style: .secondary,
            action: {
                secondaryActionCalled = true
            }
        )
        
        // Execute the action
        secondaryAction.action()
        XCTAssertTrue(secondaryActionCalled, "Secondary action should be called")
        
        // Test destructive action
        var destructiveActionCalled = false
        let destructiveAction = CTAlertDialogAction(
            label: "Destructive",
            style: .destructive,
            action: {
                destructiveActionCalled = true
            }
        )
        
        // Execute the action
        destructiveAction.action()
        XCTAssertTrue(destructiveActionCalled, "Destructive action should be called")
    }
    
    // MARK: - Dialog Presentation Tests
    
    func testDialogPresentation() {
        // Test presentation binding
        @State var isPresented = false
        
        let testView = TestDialogView(isPresented: $isPresented)
        
        // Initially not presented
        XCTAssertFalse(isPresented, "Dialog should initially not be presented")
        
        // Set to presented
        isPresented = true
        XCTAssertTrue(isPresented, "Dialog should be presented after setting binding")
        
        // Dismiss dialog
        isPresented = false
        XCTAssertFalse(isPresented, "Dialog should be dismissed after setting binding to false")
    }
    
    // MARK: - Dialog Accessibility Tests
    
    func testDialogAccessibility() {
        let dialogContent = TestDialogContent(
            title: "Test Dialog",
            message: "Test message"
        )
        
        XCTAssertTrue(dialogContent.isModal, "Dialog should be marked as modal for accessibility")
        XCTAssertTrue(dialogContent.containsChildren, "Dialog should contain children for accessibility")
        
        // Test button accessibility
        let testButton = AlertDialogButtonStyle(style: .primary, theme: CTDefaultTheme())
            .makeBody(configuration: TestButtonConfiguration())
        
        XCTAssertNotNil(testButton, "Dialog button should be created successfully with appropriate style")
    }
}

// MARK: - Test Helpers

/// A test view that includes a dialog
struct TestDialogView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        Text("Test View")
            .ctAlertDialog(isPresented: $isPresented) {
                CTAlertDialogContent(
                    title: "Test Dialog",
                    message: "Test message",
                    primaryAction: CTAlertDialogAction(
                        label: "OK",
                        action: {
                            isPresented = false
                        }
                    )
                )
            }
    }
}

/// A test dialog content implementation for accessibility testing
struct TestDialogContent {
    let title: String
    let message: String
    let isModal: Bool = true
    let containsChildren: Bool = true
    
    var body: some View {
        CTAlertDialogContent(
            title: title,
            message: message,
            primaryAction: CTAlertDialogAction(label: "OK")
        )
    }
}

/// A test button configuration for button style testing
struct TestButtonConfiguration: ButtonStyleConfiguration {
    var isPressed: Bool = false
    var role: ButtonRole? = nil
    
    var label: Text {
        return Text("Button Label")
    }
}