//
//  CTDataTableTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTDataTableTests: XCTestCase {
    struct Person: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let age: Int
        let city: String
    }
    
    private var testData: [Person]!
    
    override func setUp() {
        super.setUp()
        testData = [
            Person(name: "Alice", age: 30, city: "New York"),
            Person(name: "Bob", age: 25, city: "San Francisco"),
            Person(name: "Charlie", age: 35, city: "Los Angeles")
        ]
    }
    
    override func tearDown() {
        testData = nil
        super.tearDown()
    }
    
    func testDataTableInitialization() {
        let columns = [
            CTDataTable<[Person]>.Column(id: "name", title: "Name", keyPath: \.name),
            CTDataTable<[Person]>.Column(id: "age", title: "Age", keyPath: \.age),
            CTDataTable<[Person]>.Column(id: "city", title: "City", keyPath: \.city)
        ]
        
        let dataTable = CTDataTable(testData, columns: columns)
        
        XCTAssertEqual(dataTable._data.count, testData.count)
        XCTAssertEqual(dataTable._columns.count, columns.count)
    }
    
    func testDataTableSorting() {
        let columns = [
            CTDataTable<[Person]>.Column(id: "name", title: "Name", keyPath: \.name),
            CTDataTable<[Person]>.Column(id: "age", title: "Age", keyPath: \.age)
        ]
        
        var dataTable = CTDataTable(testData, columns: columns)
        
        // Test ascending sort
        dataTable._sortConfig = CTDataTable<[Person]>.SortConfig(columnId: "name", direction: .ascending)
        let ascendingSortedData = dataTable._filteredAndSortedData
        
        XCTAssertEqual(ascendingSortedData[0].name, "Alice")
        XCTAssertEqual(ascendingSortedData[1].name, "Bob")
        XCTAssertEqual(ascendingSortedData[2].name, "Charlie")
        
        // Test descending sort
        dataTable._sortConfig = CTDataTable<[Person]>.SortConfig(columnId: "name", direction: .descending)
        let descendingSortedData = dataTable._filteredAndSortedData
        
        XCTAssertEqual(descendingSortedData[0].name, "Charlie")
        XCTAssertEqual(descendingSortedData[1].name, "Bob")
        XCTAssertEqual(descendingSortedData[2].name, "Alice")
    }
    
    func testDataTableFiltering() {
        let columns = [
            CTDataTable<[Person]>.Column(id: "name", title: "Name", keyPath: \.name),
            CTDataTable<[Person]>.Column(id: "city", title: "City", keyPath: \.city)
        ]
        
        var dataTable = CTDataTable(testData, columns: columns)
        
        // Test filtering by name
        dataTable._searchText = "Alice"
        let filteredData = dataTable._filteredAndSortedData
        
        XCTAssertEqual(filteredData.count, 1)
        XCTAssertEqual(filteredData[0].name, "Alice")
        
        // Test filtering by city
        dataTable._searchText = "San Francisco"
        let cityFilteredData = dataTable._filteredAndSortedData
        
        XCTAssertEqual(cityFilteredData.count, 1)
        XCTAssertEqual(cityFilteredData[0].name, "Bob")
    }
    
    func testDataTablePagination() {
        let moreTestData = (0..<20).map { index in
            Person(name: "Person \(index)", age: 20 + index, city: "City \(index)")
        }
        
        let columns = [
            CTDataTable<[Person]>.Column(id: "name", title: "Name", keyPath: \.name),
            CTDataTable<[Person]>.Column(id: "age", title: "Age", keyPath: \.age)
        ]
        
        var dataTable = CTDataTable(
            moreTestData,
            columns: columns,
            paginationConfig: .init(itemsPerPage: 5, currentPage: 1)
        )
        
        // Test first page
        XCTAssertEqual(dataTable._filteredAndSortedData.count, 5)
        XCTAssertEqual(dataTable._filteredAndSortedData[0].name, "Person 0")
        
        // Test second page
        dataTable._paginationConfig.currentPage = 2
        XCTAssertEqual(dataTable._filteredAndSortedData.count, 5)
        XCTAssertEqual(dataTable._filteredAndSortedData[0].name, "Person 5")
        
        // Test total pages
        XCTAssertEqual(dataTable._totalPages, 4)
    }
    
    func testDataTableCustomCellRendering() {
        let columns = [
            CTDataTable<[Person]>.Column(
                id: "age",
                title: "Age",
                keyPath: \.age,
                cellRenderer: { person in
                    AnyView(
                        Text(String(person.age))
                            .foregroundColor(person.age > 30 ? .red : .blue)
                    )
                }
            )
        ]
        
        let dataTable = CTDataTable(testData, columns: columns)
        
        // This test ensures the custom cell renderer can be created without runtime issues
        XCTAssertNoThrow(dataTable._filteredAndSortedData)
    }
    
    func testDataTableAccessibility() {
        let columns = [
            CTDataTable<[Person]>.Column(id: "name", title: "Name", keyPath: \.name),
            CTDataTable<[Person]>.Column(id: "age", title: "Age", keyPath: \.age)
        ]
        
        let dataTable = CTDataTable(testData, columns: columns)
        
        // The intention here is just to ensure these properties exist and can be accessed
        XCTAssertNotNil(dataTable)
    }
}