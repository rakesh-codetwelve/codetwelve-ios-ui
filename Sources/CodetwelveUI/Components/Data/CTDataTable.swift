//
//  CTDataTable.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A comprehensive data table component with advanced features like sorting, filtering, and pagination.
///
/// `CTDataTable` provides a flexible and powerful way to display and interact with tabular data,
/// supporting dynamic data manipulation, accessibility, and responsive design.
///
/// # Features
/// - Sorting columns
/// - Filtering data
/// - Pagination
/// - Column configuration
/// - Responsive design
/// - Accessibility support
/// - Theme integration
///
/// # Example
///
/// ```swift
/// struct Person: Identifiable, Hashable {
///     let id = UUID()
///     let name: String
///     let age: Int
///     let city: String
/// }
///
/// let people = [
///     Person(name: "Alice", age: 30, city: "New York"),
///     Person(name: "Bob", age: 25, city: "San Francisco")
/// ]
///
/// CTDataTable(
///     data: people,
///     columns: [
///         CTDataTableColumn(id: "name", title: "Name", keyPath: \.name),
///         CTDataTableColumn(id: "age", title: "Age", keyPath: \.age),
///         CTDataTableColumn(id: "city", title: "City", keyPath: \.city)
///     ]
/// )
/// ```

// First, move Person struct outside and make it public
public struct Person: Identifiable, Hashable {
    public let id = UUID()
    public let name: String
    public let age: Int
    public let city: String
    
    public init(name: String, age: Int, city: String) {
        self.name = name
        self.age = age
        self.city = city
    }
}

public struct CTDataTable<Data: RandomAccessCollection>: View 
where Data.Element: Identifiable, Data.Element: Hashable {
    // MARK: - Public Types
    
    /// Configuration for data table columns
    public struct Column<T, Value>: Identifiable {
        /// Unique identifier for the column
        public let id: String
        
        /// Display title for the column
        public let title: String
        
        /// KeyPath for sorting and displaying column data
        public let keyPath: KeyPath<T, Value>
        
        /// Whether the column is sortable
        public let isSortable: Bool
        
        /// Custom cell content renderer
        public let cellRenderer: ((T) -> AnyView)?
        
        /// Initialize a data table column
        /// - Parameters:
        ///   - id: Unique column identifier
        ///   - title: Column display title
        ///   - keyPath: KeyPath for data extraction
        ///   - isSortable: Whether the column can be sorted
        ///   - cellRenderer: Optional custom cell content renderer
        public init(
            id: String,
            title: String,
            keyPath: KeyPath<T, Value>,
            isSortable: Bool = true,
            cellRenderer: ((T) -> AnyView)? = nil
        ) {
            self.id = id
            self.title = title
            self.keyPath = keyPath
            self.isSortable = isSortable
            self.cellRenderer = cellRenderer
        }
        
        // Add a type-erasing wrapper
        private struct AnyValueKeyPath<Root> {
            let keyPath: KeyPath<Root, Any>
            
            init<Value>(_ keyPath: KeyPath<Root, Value>) {
                self.keyPath = unsafeBitCast(keyPath, to: KeyPath<Root, Any>.self)
            }
        }
        
        func eraseToAnyColumn() -> Column<T, Any> {
            let erasedKeyPath = AnyValueKeyPath(keyPath).keyPath
            return Column<T, Any>(
                id: id,
                title: title,
                keyPath: erasedKeyPath,
                isSortable: isSortable,
                cellRenderer: cellRenderer
            )
        }
    }
    
    /// Sorting configuration for the data table
    public struct SortConfig {
        /// Column ID being sorted
        let columnId: String
        
        /// Sort direction
        let direction: SortDirection
    }
    
    /// Sort direction
    public enum SortDirection {
        case ascending
        case descending
    }
    
    /// Pagination configuration
    public struct PaginationConfig {
        /// Number of items per page
        let itemsPerPage: Int
        
        /// Current page number
        var currentPage: Int
        
        /// Initializer for pagination configuration
        /// - Parameters:
        ///   - itemsPerPage: Number of items to display per page
        ///   - currentPage: Initial page number
        public init(
            itemsPerPage: Int = 10,
            currentPage: Int = 1
        ) {
            self.itemsPerPage = itemsPerPage
            self.currentPage = currentPage
        }
    }
    
    // MARK: - Private Properties
    
    /// Original data source
    private let data: Data
    
    /// Columns for the data table
    private let columns: [Column<Data.Element, Any>]
    
    /// Search text for filtering
    @State private var searchText: String = ""
    
    /// Current sorting configuration
    @State private var sortConfig: SortConfig?
    
    /// Current pagination configuration
    @State private var paginationConfig: PaginationConfig
    
    /// Selected row IDs
    @State private var selectedRows: Set<Data.Element.ID> = []
    
    /// Environment theme
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initialization
    
    /// Initialize a data table
    /// - Parameters:
    ///   - data: Data source
    ///   - columns: Table columns
    ///   - paginationConfig: Pagination configuration
    public init(
        _ data: Data,
        columns: [Column<Data.Element, Any>],
        paginationConfig: PaginationConfig = .init()
    ) {
        self.data = data
        self.columns = columns
        self._paginationConfig = State(initialValue: paginationConfig)
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: CTSpacing.m) {
            // Search bar
            CTTextField(
                "Search",
                text: $searchText
            )
            .padding(.horizontal)
            
            // Table view
            ScrollView(.horizontal) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header row
                    headerRow
                    
                    // Data rows
                    ForEach(filteredAndSortedData, id: \.id) { item in
                        dataRow(for: item)
                    }
                }
                .background(theme.surface)
                .cornerRadius(theme.borderRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.borderRadius)
                        .stroke(theme.border, lineWidth: 1)
                )
            }
            
            // Pagination controls
            paginationControls
        }
    }
    
    // MARK: - Private Computed Properties
    
    /// Filtered and sorted data
    private var filteredAndSortedData: [Data.Element] {
        var result = data.filter { item in
            searchText.isEmpty || columns.contains { column in
                String(describing: item[keyPath: column.keyPath])
                    .localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sorting if configured
        if let sortConfig = sortConfig,
           let column = columns.first(where: { $0.id == sortConfig.columnId }) {
            result.sort { a, b in
                let valueA = String(describing: a[keyPath: column.keyPath])
                let valueB = String(describing: b[keyPath: column.keyPath])
                
                return sortConfig.direction == .ascending
                    ? valueA < valueB
                    : valueA > valueB
            }
        }
        
        // Apply pagination
        let startIndex = (paginationConfig.currentPage - 1) * paginationConfig.itemsPerPage
        let endIndex = min(startIndex + paginationConfig.itemsPerPage, result.count)
        
        return Array(result[startIndex..<endIndex])
    }
    
    /// Total number of pages
    private var totalPages: Int {
        let filteredCount = data.filter { item in
            searchText.isEmpty || columns.contains { column in
                String(describing: item[keyPath: column.keyPath])
                    .localizedCaseInsensitiveContains(searchText)
            }
        }.count
        
        return max(1, (filteredCount + paginationConfig.itemsPerPage - 1) / paginationConfig.itemsPerPage)
    }
    
    // MARK: - Private Views
    
    /// Header row with column titles and sorting
    private var headerRow: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(columns, id: \.id) { column in
                HStack {
                    Text(column.title)
                        .ctBodyBold()
                        .frame(minWidth: 100, alignment: .leading)
                    
                    if column.isSortable {
                        sortIndicator(for: column)
                    }
                }
                .padding(CTSpacing.s)
                .background(theme.surface)
                .onTapGesture {
                    handleColumnSort(column)
                }
            }
        }
        .background(theme.surface.opacity(0.1))
    }
    
    /// Render a data row for a specific item
    /// - Parameter item: The data item to render
    /// - Returns: A row view for the item
    private func dataRow(for item: Data.Element) -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(columns, id: \.id) { column in
                Group {
                    if let customRenderer = column.cellRenderer {
                        customRenderer(item)
                    } else {
                        Text(String(describing: item[keyPath: column.keyPath]))
                            .ctBody()
                    }
                }
                .frame(minWidth: 100, alignment: .leading)
                .padding(CTSpacing.s)
            }
        }
    }
    
    /// Pagination controls view
    private var paginationControls: some View {
        HStack {
            CTButton("Previous", style: .secondary, isDisabled: paginationConfig.currentPage <= 1) {
                paginationConfig.currentPage = max(1, paginationConfig.currentPage - 1)
            }
            
            Text("Page \(paginationConfig.currentPage) of \(totalPages)")
                .ctBodySmall()
            
            CTButton("Next", style: .secondary, isDisabled: paginationConfig.currentPage >= totalPages) {
                paginationConfig.currentPage = min(totalPages, paginationConfig.currentPage + 1)
            }
        }
        .padding()
    }
    
    /// Sort indicator for a column
    /// - Parameter column: The column to show sort indicator for
    /// - Returns: A view representing the sort indicator
    private func sortIndicator(for column: Column<Data.Element, Any>) -> some View {
        Group {
            if let sortConfig = sortConfig, sortConfig.columnId == column.id {
                Image(systemName: sortConfig.direction == .ascending 
                      ? "chevron.up" 
                      : "chevron.down")
                    .foregroundColor(theme.primary)
                    .imageScale(.small)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Handle column sorting when a sortable column header is tapped
    /// - Parameter column: The column being sorted
    private func handleColumnSort(_ column: Column<Data.Element, Any>) {
        guard column.isSortable else { return }
        
        if let existingSort = sortConfig, existingSort.columnId == column.id {
            // Toggle sort direction if same column
            sortConfig = SortConfig(
                columnId: column.id,
                direction: existingSort.direction == .ascending ? .descending : .ascending
            )
        } else {
            // Set new sort configuration
            sortConfig = SortConfig(
                columnId: column.id,
                direction: .ascending
            )
        }
    }
}

// MARK: - Previews

struct CTDataTable_Previews: PreviewProvider {
    static var previews: some View {
        let people = [
            Person(name: "Alice", age: 30, city: "New York"),
            Person(name: "Bob", age: 25, city: "San Francisco"),
            Person(name: "Charlie", age: 35, city: "Chicago")
        ]
        
        return CTDataTable(people, columns: [
            CTDataTable.Column<Person, String>(
                id: "name",
                title: "Name",
                keyPath: \.name
            ).eraseToAnyColumn(),
            CTDataTable.Column<Person, Int>(
                id: "age",
                title: "Age",
                keyPath: \.age
            ).eraseToAnyColumn(),
            CTDataTable.Column<Person, String>(
                id: "city",
                title: "City",
                keyPath: \.city
            ).eraseToAnyColumn()
        ])
        .padding()
        .previewDisplayName("Basic Data Table")
    }
}