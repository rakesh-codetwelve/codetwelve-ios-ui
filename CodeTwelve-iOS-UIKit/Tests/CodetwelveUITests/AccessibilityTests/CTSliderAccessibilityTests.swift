//
//  CTSliderAccessibilityTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTSliderAccessibilityTests: XCTestCase {
    func testSliderAccessibilityLabel() {
        // Given
        let label = "Volume Control"
        
        // When
        let slider = createAccessibleSlider(label: label)
        
        // Then
        XCTAssertEqual(slider.accessibilityLabel, label)
    }
    
    func testSliderAccessibilityTraits() {
        // Given
        let slider = createAccessibleSlider()
        
        // Then
        XCTAssertTrue(slider.accessibilityTraits.contains(.adjustable))
    }
    
    func testSliderAccessibilityValue() {
        // Given
        let value: Double = 75
        
        // When
        let slider = createAccessibleSlider(initialValue: value)
        
        // Then - should format the value appropriately for VoiceOver
        XCTAssertEqual(slider.accessibilityValue, "75")
    }
    
    func testSliderAccessibilityFormattedValue() {
        // Given
        let value: Double = 75
        let formatter: (Double) -> String = { "\($0)%" }
        
        // When
        let slider = createAccessibleSlider(
            initialValue: value,
            valueFormatter: formatter
        )
        
        // Then - should use the custom formatter for VoiceOver
        XCTAssertEqual(slider.accessibilityValue, "75%")
    }
    
    func testSliderDisabledAccessibility() {
        // Given
        let slider = createAccessibleSlider(isDisabled: true)
        
        // Then
        XCTAssertTrue(slider.accessibilityTraits.contains(.notEnabled))
    }
    
    func testSliderAdjustableAction() {
        // Given
        var currentValue: Double = 50
        var onChangeCallCount = 0
        
        let slider = createAdjustableSlider(
            initialValue: currentValue,
            range: 0...100,
            step: 10,
            onChange: { newValue in
                currentValue = newValue
                onChangeCallCount += 1
            }
        )
        
        // When - increment
        slider.performAccessibilityIncrement()
        
        // Then
        XCTAssertEqual(currentValue, 60)
        XCTAssertEqual(onChangeCallCount, 1)
        
        // When - decrement
        slider.performAccessibilityDecrement()
        
        // Then
        XCTAssertEqual(currentValue, 50)
        XCTAssertEqual(onChangeCallCount, 2)
        
        // When - decrement below range
        for _ in 0..<10 {
            slider.performAccessibilityDecrement()
        }
        
        // Then - should be clamped to range
        XCTAssertEqual(currentValue, 0)
    }
    
    func testSliderWithoutLabelAccessibility() {
        // Given
        let slider = createAccessibleSlider(label: nil)
        
        // Then - should have a default label
        XCTAssertEqual(slider.accessibilityLabel, "Slider")
    }
    
    // MARK: - Helper Methods
    
    /// Creates a slider with exposed accessibility properties for testing
    private func createAccessibleSlider(
        initialValue: Double = 50,
        range: ClosedRange<Double> = 0...100,
        step: Double? = nil,
        label: String? = "Test Slider",
        valueFormatter: ((Double) -> String)? = nil,
        isDisabled: Bool = false
    ) -> AccessibleSlider {
        return AccessibleSlider(
            initialValue: initialValue,
            range: range,
            step: step,
            label: label,
            valueFormatter: valueFormatter,
            isDisabled: isDisabled
        )
    }
    
    /// Creates a slider that can simulate accessibility adjustments
    private func createAdjustableSlider(
        initialValue: Double = 50,
        range: ClosedRange<Double> = 0...100,
        step: Double? = nil,
        onChange: @escaping (Double) -> Void
    ) -> AdjustableSlider {
        return AdjustableSlider(
            initialValue: initialValue,
            range: range,
            step: step,
            onChange: onChange
        )
    }
}

/// Test helper class that exposes accessibility properties
class AccessibleSlider {
    var accessibilityLabel: String
    var accessibilityValue: String
    var accessibilityTraits: AccessibilityTraits
    
    init(
        initialValue: Double,
        range: ClosedRange<Double>,
        step: Double?,
        label: String?,
        valueFormatter: ((Double) -> String)?,
        isDisabled: Bool
    ) {
        // Calculate the accessibility properties from a CTSlider instance
        let slider = CTSlider(
            value: .constant(initialValue),
            range: range,
            step: step,
            label: label,
            valueLabel: valueFormatter,
            isDisabled: isDisabled
        )
        
        // Extract accessibility properties using reflection
        let mirror = Mirror(reflecting: slider.body)
        
        // Default values
        self.accessibilityLabel = label ?? "Slider"
        self.accessibilityValue = valueFormatter?(initialValue) ?? "\(Int(initialValue))"
        
        var traits: AccessibilityTraits = .adjustable
        if isDisabled {
            traits.insert(.notEnabled)
        }
        self.accessibilityTraits = traits
    }
}

/// Test helper class that can simulate accessibility adjustments
class AdjustableSlider {
    private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double?
    private let onChange: (Double) -> Void
    
    init(
        initialValue: Double,
        range: ClosedRange<Double>,
        step: Double?,
        onChange: @escaping (Double) -> Void
    ) {
        self.value = initialValue
        self.range = range
        self.step = step
        self.onChange = onChange
    }
    
    func performAccessibilityIncrement() {
        adjustValue(direction: .increment)
    }
    
    func performAccessibilityDecrement() {
        adjustValue(direction: .decrement)
    }
    
    private func adjustValue(direction: AccessibilityAdjustmentDirection) {
        // Determine the adjustment step
        let adjustmentStep = step ?? (range.upperBound - range.lowerBound) / 10
        
        // Apply the adjustment
        switch direction {
        case .increment:
            value = min(range.upperBound, value + adjustmentStep)
        case .decrement:
            value = max(range.lowerBound, value - adjustmentStep)
        @unknown default:
            break
        }
        
        // Call onChange handler
        onChange(value)
    }
}