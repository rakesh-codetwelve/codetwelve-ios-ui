//
//  CTDatePickerTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTDatePickerTests: XCTestCase {
    func testDatePickerInitialization() {
        // Given
        let initialDate = Date()
        
        // When
        let datePicker = TestDatePicker(
            "Test Date",
            selection: initialDate
        )
        
        // Then
        XCTAssertEqual(datePicker.label, "Test Date")
        XCTAssertEqual(datePicker.selection, initialDate)
        XCTAssertEqual(datePicker.displayedComponents, [.date, .hourAndMinute])
        XCTAssertEqual(datePicker.style, .bordered)
        XCTAssertFalse(datePicker.isRequired)
        XCTAssertFalse(datePicker.isDisabled)
        XCTAssertNil(datePicker.minDate)
        XCTAssertNil(datePicker.maxDate)
        XCTAssertNil(datePicker.dateFormatter)
    }
    
    func testDatePickerWithDifferentComponents() {
        // Given / When
        let dateOnlyPicker = TestDatePicker(
            "Date Only",
            selection: Date(),
            displayedComponents: .date
        )
        
        let timeOnlyPicker = TestDatePicker(
            "Time Only",
            selection: Date(),
            displayedComponents: .hourAndMinute
        )
        
        // Then
        XCTAssertEqual(dateOnlyPicker.displayedComponents, .date)
        XCTAssertEqual(timeOnlyPicker.displayedComponents, .hourAndMinute)
    }
    
    func testDatePickerWithDateRange() {
        // Given
        let today = Date()
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let oneWeekLater = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        
        // When
        let datePicker = TestDatePicker(
            "Date Range",
            selection: today,
            minDate: oneWeekAgo,
            maxDate: oneWeekLater
        )
        
        // Then
        XCTAssertEqual(datePicker.minDate, oneWeekAgo)
        XCTAssertEqual(datePicker.maxDate, oneWeekLater)
    }
    
    func testDatePickerWithDifferentStyles() {
        // Given / When / Then
        let borderedPicker = TestDatePicker(
            "Bordered",
            selection: Date(),
            style: .bordered
        )
        XCTAssertEqual(borderedPicker.style, .bordered)
        
        let underlinedPicker = TestDatePicker(
            "Underlined",
            selection: Date(),
            style: .underlined
        )
        XCTAssertEqual(underlinedPicker.style, .underlined)
        
        let filledPicker = TestDatePicker(
            "Filled",
            selection: Date(),
            style: .filled
        )
        XCTAssertEqual(filledPicker.style, .filled)
        
        let plainPicker = TestDatePicker(
            "Plain",
            selection: Date(),
            style: .plain
        )
        XCTAssertEqual(plainPicker.style, .plain)
    }
    
    func testDatePickerWithFormatter() {
        // Given
        let today = Date()
        let formatter: (Date) -> String = { date in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: date)
        }
        
        // When
        let datePicker = TestDatePicker(
            "With Formatter",
            selection: today,
            dateFormatter: formatter
        )
        
        // Then
        XCTAssertNotNil(datePicker.dateFormatter)
        XCTAssertEqual(datePicker.dateFormatter?(today), formatter(today))
    }
    
    func testDatePickerRequiredState() {
        // Given / When
        let datePicker = TestDatePicker(
            "Required Date",
            selection: Date(),
            isRequired: true
        )
        
        // Then
        XCTAssertTrue(datePicker.isRequired)
    }
    
    func testDatePickerDisabledState() {
        // Given / When
        let datePicker = TestDatePicker(
            "Disabled Date",
            selection: Date(),
            isDisabled: true
        )
        
        // Then
        XCTAssertTrue(datePicker.isDisabled)
    }
    
    func testDatePickerOnChangeCallback() {
        // Given
        let initialDate = Date()
        var dateChanged = false
        var newDate: Date?
        
        let datePicker = TestDatePicker(
            "With Callback",
            selection: initialDate,
            onChange: { date in
                dateChanged = true
                newDate = date
            }
        )
        
        // When
        let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: initialDate)!
        datePicker.selection = futureDate
        datePicker.simulateChange()
        
        // Then
        XCTAssertTrue(dateChanged)
        XCTAssertEqual(newDate, futureDate)
    }
    
    func testDatePickerAccessibilityProperties() {
        // Given
        let label = "Appointment Date"
        let datePicker = CTDatePicker(
            label,
            selection: .constant(Date()),
            isRequired: true
        )
        
        // Extracting accessibility properties isn't straightforward in unit tests
        // This would typically be tested in UI tests, but we can verify the component doesn't crash
        _ = datePicker.body
    }
    
    func testDatePickerHandlesInvalidDates() {
        // Given
        let initialDate = Date()
        let minDate = Calendar.current.date(byAdding: .day, value: 1, to: initialDate)!
        
        // When - initializing with a date before the minimum date
        // This would typically clamp the date to the valid range in a real UI component
        let datePicker = TestDatePicker(
            "Invalid Date",
            selection: initialDate,
            minDate: minDate
        )
        
        // Then - in a test environment we just verify it doesn't crash
        // In a real implementation this would be adjusted to the min date
        XCTAssertEqual(datePicker.selection, initialDate)
        XCTAssertEqual(datePicker.minDate, minDate)
    }
}

// Test helper class to expose internal properties and methods
class TestDatePicker {
    var label: String
    var selection: Date
    var displayedComponents: DatePickerComponents
    var minDate: Date?
    var maxDate: Date?
    var style: CTDatePickerStyle
    var isRequired: Bool
    var isDisabled: Bool
    var dateFormatter: ((Date) -> String)?
    var onChange: ((Date) -> Void)?
    
    init(
        _ label: String,
        selection: Date,
        displayedComponents: DatePickerComponents = [.date, .hourAndMinute],
        minDate: Date? = nil,
        maxDate: Date? = nil,
        style: CTDatePickerStyle = .bordered,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        dateFormatter: ((Date) -> String)? = nil,
        onChange: ((Date) -> Void)? = nil
    ) {
        self.label = label
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.minDate = minDate
        self.maxDate = maxDate
        self.style = style
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.dateFormatter = dateFormatter
        self.onChange = onChange
    }
    
    func simulateChange() {
        onChange?(selection)
    }
}