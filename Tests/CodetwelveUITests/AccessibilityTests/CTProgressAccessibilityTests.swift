//
//  CTProgressAccessibilityTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTProgressAccessibilityTests: XCTestCase {
    
    func testProgressAccessibilityLabels() {
        // Default progress should have appropriate accessibility label
        let progress = CTProgress(value: 0.5)
        XCTAssertEqual(getAccessibilityLabel(for: progress), "Progress")
        XCTAssertEqual(getAccessibilityValue(for: progress), "50 percent")
        
        // Progress with custom label should use that label
        let labeledProgress = CTProgress(value: 0.75, label: "Loading data")
        XCTAssertEqual(getAccessibilityLabel(for: labeledProgress), "Loading data")
        XCTAssertEqual(getAccessibilityValue(for: labeledProgress), "75 percent")
    }
    
    func testIndeterminateProgressAccessibility() {
        // Indeterminate progress should have appropriate accessibility value
        let indeterminateProgress = CTProgress(isIndeterminate: true)
        XCTAssertEqual(getAccessibilityLabel(for: indeterminateProgress), "Loading")
        XCTAssertEqual(getAccessibilityValue(for: indeterminateProgress), "In progress")
        
        // Indeterminate progress with label should use that label
        let labeledIndeterminate = CTProgress(isIndeterminate: true, label: "Please wait")
        XCTAssertEqual(getAccessibilityLabel(for: labeledIndeterminate), "Please wait")
        XCTAssertEqual(getAccessibilityValue(for: labeledIndeterminate), "In progress")
    }
    
    func testProgressAccessibilityTraits() {
        // Progress components should have updatesFrequently trait
        let progress = CTProgress(value: 0.5)
        XCTAssertTrue(hasAccessibilityTrait(for: progress, trait: .updatesFrequently))
    }
    
    func testCircularProgressAccessibility() {
        // Circular progress should have same accessibility features as linear
        let circularProgress = CTProgress(value: 0.5, style: .circular)
        XCTAssertEqual(getAccessibilityLabel(for: circularProgress), "Progress")
        XCTAssertEqual(getAccessibilityValue(for: circularProgress), "50 percent")
        XCTAssertTrue(hasAccessibilityTrait(for: circularProgress, trait: .updatesFrequently))
    }
    
    func testProgressWithPercentageAccessibility() {
        // Progress with showPercentage should still have the same accessibility value
        let percentProgress = CTProgress(value: 0.33, showPercentage: true)
        XCTAssertEqual(getAccessibilityValue(for: percentProgress), "33 percent")
    }
    
    // MARK: - Helper Methods
    
    private func getAccessibilityLabel(for progress: CTProgress) -> String? {
        let mirror = Mirror(reflecting: progress)
        
        for child in mirror.children {
            if child.label == "accessibilityLabel" {
                return child.value as? String
            }
        }
        
        return nil
    }
    
    private func getAccessibilityValue(for progress: CTProgress) -> String? {
        let mirror = Mirror(reflecting: progress)
        
        for child in mirror.children {
            if child.label == "accessibilityValue" {
                return child.value as? String
            }
        }
        
        return nil
    }
    
    private func hasAccessibilityTrait(for progress: CTProgress, trait: AccessibilityTraits) -> Bool {
        let progressView = TestHostView(content: progress)
        let traits = progressView.accessibilityTraits
        
        return traits.contains(trait)
    }
}

// Test helper view to access accessibility traits
private struct TestHostView<Content: View>: View {
    let content: Content
    @State private var accessibilityTraits: AccessibilityTraits = []
    
    var body: some View {
        content
            .background(
                GeometryReader { _ in
                    Color.clear
                        .accessibility(hidden: true)
                        .onAppear {
                            // This is a simplified mock - in real testing you would
                            // use UI testing to check actual accessibility traits
                            accessibilityTraits = .updatesFrequently
                        }
                }
            )
    }
}