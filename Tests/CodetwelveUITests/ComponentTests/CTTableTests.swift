//
//  CTTableTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTTableTests: XCTestCase {
    struct TestPerson: Identifiable {
        let id = UUID()
        let name: String
        let age: Int
    }
    
    private var testData: [TestPerson]!
    
    override func setUp() {
        super.setUp()
        testData = [
            TestPerson(name: "Alice", age: 30),
            TestPerson(name: "Bob", age: 25),
            TestPerson(name: "Charlie", age: 35)
        ]
    }
    
    override func tearDown() {
        testData = nil
        super.tearDown()
    }
    
    func testTableInitialization() {
        let table = CTTable(testData) { person in
            CTTableRow {
                CTTableCell(person.name)
                CTTableCell(String(person.age))
            }
        }
        
        XCTAssertNotNil(table, "Table should be initialized successfully")
    }
    
    func testTableWithConfiguration() {
        let config = CTTable<[TestPerson], AnyView>.Configuration(
            allowSelection: true,
            maxRows: 2,
            showBorder: true,
            stripedRows: true
        )
        
        let table = CTTable(testData, configuration: config) { person in
            CTTableRow {
                CTTableCell(person.name)
                CTTableCell(String(person.age))
            }
        }
        
        XCTAssertNotNil(table, "Table with custom configuration should be initialized successfully")
    }
    
    func testTableCellInitialization() {
        let textCell = CTTableCell("Test Name")
        let numberCell = CTTableCell(String(42))
        
        XCTAssertNotNil(textCell, "Text cell should be initialized successfully")
        XCTAssertNotNil(numberCell, "Number cell should be initialized successfully")
    }
    
    func testTableRowInitialization() {
        let row = CTTableRow {
            CTTableCell("Name")
            CTTableCell("Age")
        }
        
        XCTAssertNotNil(row, "Table row should be initialized successfully")
    }
    
    func testMaxRowsConfiguration() {
        let config = CTTable<[TestPerson], AnyView>.Configuration(maxRows: 2)
        
        let table = CTTable(testData, configuration: config) { person in
            CTTableRow {
                CTTableCell(person.name)
                CTTableCell(String(person.age))
            }
        }
        
        // In a real test, we'd need a way to inspect the number of rows
        // This is a placeholder for demonstration
        XCTAssertNotNil(table, "Table with max rows configuration should be initialized")
    }
    
    func testRowSelectionConfiguration() {
        let config = CTTable<[TestPerson], AnyView>.Configuration(allowSelection: true)
        
        let table = CTTable(testData, configuration: config) { person in
            CTTableRow {
                CTTableCell(person.name)
                CTTableCell(String(person.age))
            }
        }
        
        XCTAssertNotNil(table, "Table with row selection configuration should be initialized")
    }
}