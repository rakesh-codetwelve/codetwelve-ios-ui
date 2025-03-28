//
//  CTPopoverTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTPopoverTests: XCTestCase {
    func testPopoverInitialization() {
        let expectation = XCTestExpectation(description: "Popover initialization")
        
        let testView = TestPopoverView(
            style: .default,
            arrowPosition: .top,
            dismissOnBackgroundTap: true
        )
        
        let hostingController = UIHostingController(rootView: testView)
        XCTAssertNotNil(hostingController.view, "Hosting controller should create a view")
        
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPopoverPresentation() {
        let testView = TestPopoverView(
            style: .default,
            arrowPosition: .top,
            dismissOnBackgroundTap: true
        )
        
        let expectation = XCTestExpectation(description: "Popover presentation")
        
        DispatchQueue.main.async {
            testView.showPopover()
            
            XCTAssertTrue(testView.isPopoverPresented, "Popover should be presented")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPopoverDismissal() {
        let testView = TestPopoverView(
            style: .default,
            arrowPosition: .top,
            dismissOnBackgroundTap: true
        )
        
        let expectation = XCTestExpectation(description: "Popover dismissal")
        
        DispatchQueue.main.async {
            testView.showPopover()
            XCTAssertTrue(testView.isPopoverPresented, "Popover should be presented")
            
            testView.dismissPopover()
            XCTAssertFalse(testView.isPopoverPresented, "Popover should be dismissed")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPopoverStyles() {
        let styles: [CTPopover<AnyView>.CTPopoverStyle] = [
            .default,
            .modern,
            .minimal,
            .custom(
                backgroundColor: .blue,
                cornerRadius: 16,
                shadowRadius: 8,
                shadowOpacity: 0.3
            )
        ]
        
        for style in styles {
            let testView = TestPopoverView(
                style: style,
                arrowPosition: .top,
                dismissOnBackgroundTap: true
            )
            
            let expectation = XCTestExpectation(description: "Popover style test for \(style)")
            
            DispatchQueue.main.async {
                testView.showPopover()
                XCTAssertTrue(testView.isPopoverPresented, "Popover should be presented")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }
    }
    
    func testPopoverArrowPositions() {
        let arrowPositions: [CTPopover<AnyView>.CTPopoverArrowPosition] = [
            .top,
            .bottom,
            .leading,
            .trailing
        ]
        
        for position in arrowPositions {
            let testView = TestPopoverView(
                style: .default,
                arrowPosition: position,
                dismissOnBackgroundTap: true
            )
            
            let expectation = XCTestExpectation(description: "Popover arrow position test for \(position)")
            
            DispatchQueue.main.async {
                testView.showPopover()
                XCTAssertTrue(testView.isPopoverPresented, "Popover should be presented with arrow at \(position)")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }
    }
    
    func testPopoverBackgroundDismissal() {
        let testView = TestPopoverView(
            style: .default,
            arrowPosition: .top,
            dismissOnBackgroundTap: true
        )
        
        let expectation = XCTestExpectation(description: "Popover background tap dismissal")
        
        DispatchQueue.main.async {
            testView.showPopover()
            XCTAssertTrue(testView.isPopoverPresented, "Popover should be presented")
            
            testView.simulateBackgroundTap()
            XCTAssertFalse(testView.isPopoverPresented, "Popover should be dismissed by background tap")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPopoverNonDismissibleBackground() {
        let testView = TestPopoverView(
            style: .default,
            arrowPosition: .top,
            dismissOnBackgroundTap: false
        )
        
        let expectation = XCTestExpectation(description: "Popover non-dismissible background")
        
        DispatchQueue.main.async {
            testView.showPopover()
            XCTAssertTrue(testView.isPopoverPresented, "Popover should be presented")
            
            testView.simulateBackgroundTap()
            XCTAssertTrue(testView.isPopoverPresented, "Popover should not be dismissed when background tap is disabled")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPopoverAccessibility() {
        let testView = TestPopoverView(
            style: .default,
            arrowPosition: .top,
            dismissOnBackgroundTap: true
        )
        
        let expectation = XCTestExpectation(description: "Popover accessibility")
        
        DispatchQueue.main.async {
            testView.showPopover()
            
            // Find the popover view
            let popoverView = testView.findPopoverView()
            
            XCTAssertNotNil(popoverView, "Popover view should exist")
            XCTAssertTrue(popoverView?.accessibilityLabel == "Popover", "Popover should have correct accessibility label")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Test Helper Structs

struct TestPopoverView: View {
    @State private var isPopoverPresented = false
    
    let style: CTPopover<AnyView>.CTPopoverStyle
    let arrowPosition: CTPopover<AnyView>.CTPopoverArrowPosition
    let dismissOnBackgroundTap: Bool
    
    var body: some View {
        CTButton("Show Popover") {
            showPopover()
        }
        .ctPopover(
            isPresented: $isPopoverPresented,
            arrowPosition: arrowPosition,
            style: style,
            dismissOnBackgroundTap: dismissOnBackgroundTap
        ) {
            VStack {
                Text("Test Popover Content")
                CTButton("Dismiss") {
                    dismissPopover()
                }
            }
            .padding()
        }
    }
    
    func showPopover() {
        isPopoverPresented = true
    }
    
    func dismissPopover() {
        isPopoverPresented = false
    }
    
    func simulateBackgroundTap() {
        if dismissOnBackgroundTap {
            isPopoverPresented = false
        }
    }
    
    func findPopoverView() -> UIView? {
        // Helper method to find the popover view in the view hierarchy
        guard let rootView = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first?.rootViewController?.view else {
            return nil
        }
        
        return findView(in: rootView) { view in
            view.accessibilityLabel == "Popover"
        }
    }
    
    private func findView(in view: UIView, matching predicate: (UIView) -> Bool) -> UIView? {
        if predicate(view) {
            return view
        }
        
        for subview in view.subviews {
            if let matchingView = findView(in: subview, matching: predicate) {
                return matchingView
            }
        }
        
        return nil
    }
}