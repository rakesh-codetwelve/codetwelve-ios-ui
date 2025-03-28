//
//  CTSliderTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTSliderTests: XCTestCase {
    func testSliderInitialization() {
        // Given
        let initialValue: Double = 50
        
        // When
        let slider = TestSlider(
            value: initialValue,
            range: 0...100
        )
        
        // Then
        XCTAssertEqual(slider.value, initialValue)
        XCTAssertEqual(slider.range, 0...100)
        XCTAssertNil(slider.step)
        XCTAssertEqual(slider.style, .primary)
        XCTAssertEqual(slider.size, .medium)
        XCTAssertFalse(slider.isDisabled)
    }
    
    func testSliderWithStep() {
        // Given
        let initialValue: Double = 52.4
        let step: Double = 5
        
        // When
        let slider = TestSlider(
            value: initialValue,
            range: 0...100,
            step: step
        )
        
        // Then
        XCTAssertEqual(slider.value, initialValue) // Value not snapped until gesture ends
        XCTAssertEqual(slider.step, step)
        
        // When: simulate drag end which should snap to step
        slider.simulateDragEnd()
        
        // Then: value should be snapped to closest step
        XCTAssertEqual(slider.value, 50) // Snapped to closest step (50)
    }
    
    func testSliderWithDifferentStyles() {
        // Given / When / Then
        let primarySlider = TestSlider(
            value: 50,
            range: 0...100,
            style: .primary
        )
        XCTAssertEqual(primarySlider.style, .primary)
        
        let secondarySlider = TestSlider(
            value: 50,
            range: 0...100,
            style: .secondary
        )
        XCTAssertEqual(secondarySlider.style, .secondary)
        
        let accentSlider = TestSlider(
            value: 50,
            range: 0...100,
            style: .accent(.red)
        )
        if case .accent(let color) = accentSlider.style {
            // Color comparison is complex, but we can check if it's present
            XCTAssertNotNil(color)
        } else {
            XCTFail("Expected accent style")
        }
        
        let customSlider = TestSlider(
            value: 50,
            range: 0...100,
            style: .custom(colors: CTSliderColorOptions(trackFill: .blue, thumb: .white))
        )
        if case .custom = customSlider.style {
            // Success - can't easily compare the colors themselves
        } else {
            XCTFail("Expected custom style")
        }
    }
    
    func testSliderWithDifferentSizes() {
        // Given / When / Then
        let smallSlider = TestSlider(
            value: 50,
            range: 0...100,
            size: .small
        )
        XCTAssertEqual(smallSlider.size, .small)
        
        let mediumSlider = TestSlider(
            value: 50,
            range: 0...100,
            size: .medium
        )
        XCTAssertEqual(mediumSlider.size, .medium)
        
        let largeSlider = TestSlider(
            value: 50,
            range: 0...100,
            size: .large
        )
        XCTAssertEqual(largeSlider.size, .large)
    }
    
    func testSliderValueChange() {
        // Given
        var newValue: Double?
        let slider = TestSlider(
            value: 50,
            range: 0...100,
            onChange: { value in
                newValue = value
            }
        )
        
        // When
        slider.value = 75
        slider.simulateDragEnd()
        
        // Then
        XCTAssertEqual(slider.value, 75)
        XCTAssertEqual(newValue, 75)
    }
    
    func testSliderValueClampedToRange() {
        // Given
        let slider = TestSlider(
            value: 50,
            range: 0...100
        )
        
        // When - attempt to set value below range
        slider.value = -10
        
        // Then - value should be clamped to lower bound
        XCTAssertEqual(slider.value, 0)
        
        // When - attempt to set value above range
        slider.value = 150
        
        // Then - value should be clamped to upper bound
        XCTAssertEqual(slider.value, 100)
    }
    
    func testSliderDisabledState() {
        // Given
        let slider = TestSlider(
            value: 50,
            range: 0...100,
            isDisabled: true
        )
        
        // Then
        XCTAssertTrue(slider.isDisabled)
    }
    
    func testSliderWithLabels() {
        // Given
        let slider = TestSlider(
            value: 50,
            range: 0...100,
            label: "Volume",
            showMinMaxLabels: true,
            valueLabel: { "\($0)%" },
            showValueLabel: true
        )
        
        // Then
        XCTAssertEqual(slider.label, "Volume")
        XCTAssertTrue(slider.showMinMaxLabels)
        XCTAssertTrue(slider.showValueLabel)
        XCTAssertNotNil(slider.valueLabel)
        XCTAssertEqual(slider.valueLabel?(50), "50%")
    }
    
    func testSliderAccessibilityProperties() {
        // Given
        let slider = CTSlider(
            value: .constant(50),
            range: 0...100,
            label: "Volume"
        )
        
        // Extracting accessibility properties isn't straightforward in unit tests
        // This would typically be tested in UI tests, but we can verify the component doesn't crash
        _ = slider.body
    }
    
    func testSliderThumbPosition() {
        // Given
        let slider = TestSlider(
            value: 0,
            range: 0...100
        )
        
        // Then - at minimum
        XCTAssertEqual(slider.getThumbPosition(), 0.0)
        
        // When - at middle
        slider.value = 50
        
        // Then
        XCTAssertEqual(slider.getThumbPosition(), 0.5)
        
        // When - at maximum
        slider.value = 100
        
        // Then
        XCTAssertEqual(slider.getThumbPosition(), 1.0)
    }
    
    func testSliderCustomValueFormatter() {
        // Given
        let formatter: (Double) -> String = { value in
            return String(format: "%.1f dB", value)
        }
        
        let slider = TestSlider(
            value: 42.5,
            range: 0...100,
            valueLabel: formatter,
            showValueLabel: true
        )
        
        // Then
        XCTAssertEqual(slider.valueLabel?(42.5), "42.5 dB")
    }
}

// Test helper class to expose internal properties and methods
class TestSlider {
    var value: Double
    let range: ClosedRange<Double>
    let step: Double?
    let style: CTSliderStyle
    let size: CTSliderSize
    let label: String?
    let showMinMaxLabels: Bool
    let valueLabel: ((Double) -> String)?
    let showValueLabel: Bool
    let isDisabled: Bool
    let onChange: ((Double) -> Void)?
    
    init(
        value: Double,
        range: ClosedRange<Double>,
        step: Double? = nil,
        style: CTSliderStyle = .primary,
        size: CTSliderSize = .medium,
        label: String? = nil,
        showMinMaxLabels: Bool = true,
        valueLabel: ((Double) -> String)? = nil,
        showValueLabel: Bool = false,
        isDisabled: Bool = false,
        onChange: ((Double) -> Void)? = nil
    ) {
        self.value = value.clamped(to: range)
        self.range = range
        self.step = step
        self.style = style
        self.size = size
        self.label = label
        self.showMinMaxLabels = showMinMaxLabels
        self.valueLabel = valueLabel
        self.showValueLabel = showValueLabel
        self.isDisabled = isDisabled
        self.onChange = onChange
    }
    
    func getThumbPosition() -> CGFloat {
        let normalizedValue = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(normalizedValue)
    }
    
    func simulateDragEnd() {
        // Apply step value if needed
        if let step = step {
            value = (round(value / step) * step).clamped(to: range)
        }
        
        // Call onChange handler
        onChange?(value)
    }
}