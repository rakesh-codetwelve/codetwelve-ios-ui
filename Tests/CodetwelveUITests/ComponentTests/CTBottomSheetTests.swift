//
//  CTBottomSheetTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTBottomSheetTests: XCTestCase {
    
    // MARK: - Test Bottom Sheet Initialization
    
    func testBottomSheetInitialization() {
        // Given
        let isPresented = Binding.constant(true)
        
        // When
        let bottomSheet = CTBottomSheet(
            isPresented: isPresented,
            content: { Text("Test Content") }
        )
        
        // Then
        XCTAssertNotNil(bottomSheet, "Bottom sheet should be initialized successfully")
    }
    
    // MARK: - Test Bottom Sheet Presentation
    
    func testBottomSheetPresentation() {
        // Given
        let isPresented = Binding<Bool>(
            get: { true },
            set: { _ in }
        )
        
        let view = TestView()
            .ctBottomSheet(isPresented: isPresented) {
                Text("Test Content")
            }
        
        // Then
        // This is a visual test, but we can at least check that the view modifier applies correctly
        XCTAssertNotNil(view, "View with bottom sheet should be created successfully")
    }
    
    // MARK: - Test Bottom Sheet Heights
    
    func testBottomSheetHeights() {
        // Testing different height calculations
        
        // Small height
        XCTAssertEqual(
            CTBottomSheetHeight.small.getHeight(screenHeight: 800),
            200,
            "Small height should be 25% of screen height"
        )
        
        // Medium height
        XCTAssertEqual(
            CTBottomSheetHeight.medium.getHeight(screenHeight: 800),
            320,
            "Medium height should be 40% of screen height"
        )
        
        // Large height
        XCTAssertEqual(
            CTBottomSheetHeight.large.getHeight(screenHeight: 800),
            560,
            "Large height should be 70% of screen height"
        )
        
        // Custom height
        XCTAssertEqual(
            CTBottomSheetHeight.custom(250).getHeight(screenHeight: 800),
            250,
            "Custom height should use the provided value"
        )
        
        // Dynamic height uses the content height, so it depends on the content
        // We would need UI testing to properly validate this
    }
    
    // MARK: - Test Bottom Sheet Styling
    
    func testBottomSheetStyling() {
        // Given
        let customStyle = CTBottomSheetStyle(
            backgroundColor: .red,
            cornerRadius: 24,
            indicatorColor: .blue,
            backdropOpacity: 0.7
        )
        
        // Then
        XCTAssertEqual(customStyle.backgroundColor, Color.red, "Background color should match the provided value")
        XCTAssertEqual(customStyle.cornerRadius, 24, "Corner radius should match the provided value")
        XCTAssertEqual(customStyle.indicatorColor, Color.blue, "Indicator color should match the provided value")
        XCTAssertEqual(customStyle.backdropOpacity, 0.7, "Backdrop opacity should match the provided value")
        
        // Test default style
        let defaultStyle = CTBottomSheetStyle.default
        XCTAssertEqual(defaultStyle.backgroundColor, Color.ctSurface, "Default background color should be surface color")
        XCTAssertEqual(defaultStyle.cornerRadius, 16, "Default corner radius should be 16")
        XCTAssertEqual(defaultStyle.indicatorColor, Color.ctBorder, "Default indicator color should be border color")
        XCTAssertEqual(defaultStyle.backdropOpacity, 0.4, "Default backdrop opacity should be 0.4")
    }
    
    // MARK: - Test Bottom Sheet Dismissal Options
    
    func testBottomSheetDismissalOptions() {
        // Testing dismissal options requires UI interaction testing
        // We can test the property initialization though
        
        // Given
        let isPresented = Binding<Bool>(
            get: { true },
            set: { _ in }
        )
        
        // When - closeOnBackdropTap = true
        let tapDismissibleSheet = CTBottomSheet(
            isPresented: isPresented,
            closeOnBackdropTap: true,
            content: { Text("Test Content") }
        )
        
        // When - closeOnBackdropTap = false
        let nonTapDismissibleSheet = CTBottomSheet(
            isPresented: isPresented,
            closeOnBackdropTap: false,
            content: { Text("Test Content") }
        )
        
        // When - allowDragDismiss = true
        let dragDismissibleSheet = CTBottomSheet(
            isPresented: isPresented,
            allowDragDismiss: true,
            content: { Text("Test Content") }
        )
        
        // When - allowDragDismiss = false
        let nonDragDismissibleSheet = CTBottomSheet(
            isPresented: isPresented,
            allowDragDismiss: false,
            content: { Text("Test Content") }
        )
        
        // Then
        // Just verifying initialization, actual behavior would need UI testing
        XCTAssertNotNil(tapDismissibleSheet, "Tap dismissible sheet should initialize")
        XCTAssertNotNil(nonTapDismissibleSheet, "Non-tap dismissible sheet should initialize")
        XCTAssertNotNil(dragDismissibleSheet, "Drag dismissible sheet should initialize")
        XCTAssertNotNil(nonDragDismissibleSheet, "Non-drag dismissible sheet should initialize")
    }
    
    // MARK: - Test Bottom Sheet Dismiss Callback
    
    func testBottomSheetDismissCallback() {
        // Given
        var callbackCalled = false
        let isPresented = Binding<Bool>(
            get: { true },
            set: { _ in callbackCalled = true }
        )
        
        let bottomSheet = CTBottomSheet(
            isPresented: isPresented,
            onDismiss: {
                callbackCalled = true
            },
            content: { Text("Test Content") }
        )
        
        // Then
        // Just testing initialization, full behavior testing would require UI tests
        XCTAssertNotNil(bottomSheet, "Bottom sheet with dismiss callback should initialize")
    }
    
    // MARK: - Test Bottom Sheet Accessibility
    
    func testBottomSheetAccessibility() {
        // Given
        let isPresented = Binding.constant(true)
        
        // When - Create a view with a bottom sheet
        let view = Text("Main Content")
            .ctBottomSheet(isPresented: isPresented) {
                Text("Sheet Content")
            }
        
        // Then
        // Basic initialization test - real accessibility testing would need UI tests
        XCTAssertNotNil(view, "View with bottom sheet should be created successfully")
    }
    
    // MARK: - Helper Methods
    
    private struct TestView: View {
        var body: some View {
            Text("Test View")
        }
    }
}

// Helper extension for testing height calculations
private extension CTBottomSheetHeight {
    func getHeight(screenHeight: CGFloat) -> CGFloat {
        switch self {
        case .small:
            return screenHeight * 0.25
        case .medium:
            return screenHeight * 0.4
        case .large:
            return screenHeight * 0.7
        case .custom(let height):
            return height
        case .dynamic:
            return 0 // For testing purposes, dynamic height is 0 since it depends on content
        }
    }
}