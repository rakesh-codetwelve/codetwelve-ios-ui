//
//  CTProgressTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTProgressTests: XCTestCase {
    
    func testProgressInitialization() {
        // Test with default parameters
        let progress = CTProgress(value: 0.5)
        XCTAssertNotNil(progress)
        
        // Test with custom parameters
        let customProgress = CTProgress(
            value: 0.75,
            style: .circular,
            size: .large,
            color: .red,
            trackColor: .gray.opacity(0.3),
            label: "Loading",
            showPercentage: true,
            labelPosition: .bottom,
            isIndeterminate: false
        )
        XCTAssertNotNil(customProgress)
    }
    
    func testProgressValues() {
        // Test valid values
        let progress1 = CTProgress(value: 0.5)
        XCTAssertNotNil(progress1)
        
        // Test value clamping (below 0)
        let progress2 = CTProgress(value: -0.2)
        XCTAssertNotNil(progress2)
        
        // Test value clamping (above 1)
        let progress3 = CTProgress(value: 1.5)
        XCTAssertNotNil(progress3)
    }
    
    func testProgressStyles() {
        // Test linear style
        let linearProgress = CTProgress(value: 0.5, style: .linear)
        XCTAssertNotNil(linearProgress)
        
        // Test circular style
        let circularProgress = CTProgress(value: 0.5, style: .circular)
        XCTAssertNotNil(circularProgress)
    }
    
    func testProgressSizes() {
        // Test small size
        let smallProgress = CTProgress(value: 0.5, size: .small)
        XCTAssertNotNil(smallProgress)
        
        // Test medium size
        let mediumProgress = CTProgress(value: 0.5, size: .medium)
        XCTAssertNotNil(mediumProgress)
        
        // Test large size
        let largeProgress = CTProgress(value: 0.5, size: .large)
        XCTAssertNotNil(largeProgress)
        
        // Test custom size
        let customProgress = CTProgress(
            value: 0.5,
            size: .custom(linearHeight: 10, circularDiameter: 60, circularLineWidth: 5, font: .caption)
        )
        XCTAssertNotNil(customProgress)
    }
    
    func testProgressLabels() {
        // Test with label
        let labeledProgress = CTProgress(value: 0.5, label: "Loading")
        XCTAssertNotNil(labeledProgress)
        
        // Test with label and percentage
        let labeledWithPercentage = CTProgress(value: 0.5, label: "Loading", showPercentage: true)
        XCTAssertNotNil(labeledWithPercentage)
        
        // Test label positions
        let topLabelProgress = CTProgress(value: 0.5, label: "Loading", labelPosition: .top)
        XCTAssertNotNil(topLabelProgress)
        
        let bottomLabelProgress = CTProgress(value: 0.5, label: "Loading", labelPosition: .bottom)
        XCTAssertNotNil(bottomLabelProgress)
        
        let centerLabelProgress = CTProgress(
            value: 0.5,
            style: .circular,
            label: "Loading",
            showPercentage: true,
            labelPosition: .center
        )
        XCTAssertNotNil(centerLabelProgress)
    }
    
    func testIndeterminateProgress() {
        // Test indeterminate linear progress
        let indeterminateLinear = CTProgress(isIndeterminate: true)
        XCTAssertNotNil(indeterminateLinear)
        
        // Test indeterminate circular progress
        let indeterminateCircular = CTProgress(
            style: .circular,
            isIndeterminate: true
        )
        XCTAssertNotNil(indeterminateCircular)
        
        // Test indeterminate with label
        let indeterminateWithLabel = CTProgress(
            label: "Loading...",
            isIndeterminate: true
        )
        XCTAssertNotNil(indeterminateWithLabel)
    }
    
    func testProgressCustomColors() {
        // Test with custom progress color
        let coloredProgress = CTProgress(
            value: 0.5,
            color: .green
        )
        XCTAssertNotNil(coloredProgress)
        
        // Test with custom track color
        let customTrackProgress = CTProgress(
            value: 0.5,
            color: .blue,
            trackColor: .gray.opacity(0.5)
        )
        XCTAssertNotNil(customTrackProgress)
    }
    
    func testProgressAccessibility() {
        // Create progress with no label
        let progress = CTProgress(value: 0.5)
        let accessibilityLabel = getAccessibilityLabel(for: progress)
        let accessibilityValue = getAccessibilityValue(for: progress)
        
        XCTAssertEqual(accessibilityLabel, "Progress")
        XCTAssertEqual(accessibilityValue, "50 percent")
        
        // Create progress with label
        let labeledProgress = CTProgress(value: 0.75, label: "Loading files")
        let labeledAccessibilityLabel = getAccessibilityLabel(for: labeledProgress)
        let labeledAccessibilityValue = getAccessibilityValue(for: labeledProgress)
        
        XCTAssertEqual(labeledAccessibilityLabel, "Loading files")
        XCTAssertEqual(labeledAccessibilityValue, "75 percent")
        
        // Create indeterminate progress
        let indeterminateProgress = CTProgress(isIndeterminate: true)
        let indeterminateAccessibilityLabel = getAccessibilityLabel(for: indeterminateProgress)
        let indeterminateAccessibilityValue = getAccessibilityValue(for: indeterminateProgress)
        
        XCTAssertEqual(indeterminateAccessibilityLabel, "Loading")
        XCTAssertEqual(indeterminateAccessibilityValue, "In progress")
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
}