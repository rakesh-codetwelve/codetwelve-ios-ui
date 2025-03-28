//
//  CTToastTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTToastTests: XCTestCase {
    // MARK: - Toast Component Tests
    
    func testToastInitialization() {
        // Given
        let isShowing = Binding.constant(true)
        
        // When
        let toast = CTToast(
            message: "Test Message",
            type: .info,
            duration: 3.0,
            hasCloseButton: true,
            isShowing: isShowing
        )
        
        // Then
        XCTAssertNotNil(toast)
    }
    
    func testToastWithDifferentTypes() {
        // Given
        let isShowing = Binding.constant(true)
        
        // When
        let successToast = CTToast(message: "Success", type: .success, isShowing: isShowing)
        let errorToast = CTToast(message: "Error", type: .error, isShowing: isShowing)
        let warningToast = CTToast(message: "Warning", type: .warning, isShowing: isShowing)
        let infoToast = CTToast(message: "Info", type: .info, isShowing: isShowing)
        let customToast = CTToast(
            message: "Custom",
            type: .custom(
                icon: Image(systemName: "star.fill"),
                backgroundColor: .purple,
                textColor: .white
            ),
            isShowing: isShowing
        )
        
        // Then
        XCTAssertNotNil(successToast)
        XCTAssertNotNil(errorToast)
        XCTAssertNotNil(warningToast)
        XCTAssertNotNil(infoToast)
        XCTAssertNotNil(customToast)
    }
    
    func testToastAccessibilityProperties() {
        // When
        let successType = CTToastType.success
        let errorType = CTToastType.error
        let warningType = CTToastType.warning
        let infoType = CTToastType.info
        let customType = CTToastType.custom(
            icon: Image(systemName: "star.fill"),
            backgroundColor: .purple,
            textColor: .white
        )
        
        // Then
        XCTAssertEqual(successType.accessibilityLabel, "Success")
        XCTAssertEqual(errorType.accessibilityLabel, "Error")
        XCTAssertEqual(warningType.accessibilityLabel, "Warning")
        XCTAssertEqual(infoType.accessibilityLabel, "Information")
        XCTAssertEqual(customType.accessibilityLabel, "Notification")
    }
    
    func testToastDismissCallback() {
        // Given
        let expectation = self.expectation(description: "Toast dismiss callback should be called")
        let isShowing = Binding.constant(true)
        
        // Create toast with dismiss callback
        let toast = TestToast(
            message: "Test Message",
            isShowing: isShowing,
            onDismiss: {
                expectation.fulfill()
            }
        )
        
        // When
        toast.simulateDismiss()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Toast Manager Tests
    
    func testToastManagerShowMethod() {
        // Given
        let manager = CTToastManager.shared
        
        // When
        manager.show(message: "Test Message", type: .info, duration: 3.0)
        
        // Then
        XCTAssertNotNil(manager.currentToast)
        XCTAssertEqual(manager.currentToast?.message, "Test Message")
        XCTAssertTrue(manager.isShowingToast)
        
        // Cleanup
        manager.clearAll()
    }
    
    func testToastManagerConvenienceMethods() {
        // Given
        let manager = CTToastManager.shared
        
        // Test showSuccess
        manager.showSuccess(message: "Success Message")
        XCTAssertEqual(manager.currentToast?.message, "Success Message")
        XCTAssertEqual(manager.currentToast?.type, .success)
        manager.clearAll()
        
        // Test showError
        manager.showError(message: "Error Message")
        XCTAssertEqual(manager.currentToast?.message, "Error Message")
        XCTAssertEqual(manager.currentToast?.type, .error)
        manager.clearAll()
        
        // Test showWarning
        manager.showWarning(message: "Warning Message")
        XCTAssertEqual(manager.currentToast?.message, "Warning Message")
        XCTAssertEqual(manager.currentToast?.type, .warning)
        manager.clearAll()
        
        // Test showInfo
        manager.showInfo(message: "Info Message")
        XCTAssertEqual(manager.currentToast?.message, "Info Message")
        XCTAssertEqual(manager.currentToast?.type, .info)
        manager.clearAll()
    }
    
    func testToastManagerQueueing() {
        // Given
        let manager = CTToastManager.shared
        
        // When
        manager.show(message: "First Toast", type: .info, duration: 3.0)
        manager.show(message: "Second Toast", type: .success, duration: 3.0)
        manager.show(message: "Third Toast", type: .warning, duration: 3.0)
        
        // Then
        XCTAssertEqual(manager.currentToast?.message, "First Toast")
        XCTAssertTrue(manager.isShowingToast)
        
        // Cleanup
        manager.clearAll()
    }
    
    func testToastManagerClearAll() {
        // Given
        let manager = CTToastManager.shared
        
        // When
        manager.show(message: "Test Message", type: .info, duration: 3.0)
        manager.clearAll()
        
        // Then
        XCTAssertNil(manager.currentToast)
        XCTAssertFalse(manager.isShowingToast)
    }
}

// MARK: - Helper Types for Testing

struct TestToast {
    let message: String
    let isShowing: Binding<Bool>
    let onDismiss: (() -> Void)?
    
    init(
        message: String,
        isShowing: Binding<Bool>,
        onDismiss: (() -> Void)? = nil
    ) {
        self.message = message
        self.isShowing = isShowing
        self.onDismiss = onDismiss
    }
    
    func simulateDismiss() {
        isShowing.wrappedValue = false
        onDismiss?()
    }
}

// MARK: - CTToastType Equatable Extension for Testing

extension CTToastType: Equatable {
    public static func == (lhs: CTToastType, rhs: CTToastType) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.error, .error):
            return true
        case (.warning, .warning):
            return true
        case (.info, .info):
            return true
        case (.custom, .custom):
            // For testing purposes, we only check the type, not the associated values
            return true
        default:
            return false
        }
    }
}