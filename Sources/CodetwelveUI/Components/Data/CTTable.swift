//
//  CTTable.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable table component for displaying structured data with advanced features.
///
/// `CTTable` provides a flexible and accessible way to render tabular data with support
/// for various customization options, theming, and accessibility features.
///
/// # Features
/// - Supports different data types
/// - Customizable column configurations
/// - Responsive design
/// - Theme integration
/// - Accessibility support
/// - Optional row selection
///
/// # Example
///
/// ```swift
/// struct Person: Identifiable {
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
/// CTTable(data: people) { person in
///     CTTableRow {
///         CTTableCell(person.name)
///         CTTableCell(String(person.age))
///         CTTableCell(person.city)
///     }
/// }
/// ```
public struct CTTable<Data: RandomAccessCollection, Content: View>: View 
where Data.Element: Identifiable {
    // MARK: - Public Properties
    
    /// Configuration options for the table
    public struct Configuration {
        /// Whether to allow row selection
        public var allowSelection: Bool = false
        
        /// Maximum number of rows to display
        public var maxRows: Int?
        
        /// Whether to show a border around the table
        public var showBorder: Bool = true
        
        /// Whether to alternate row background colors
        public var stripedRows: Bool = false
        
        /// Horizontal padding between cells
        public var horizontalPadding: CGFloat = CTSpacing.s
        
        /// Vertical padding between cells
        public var verticalPadding: CGFloat = CTSpacing.xs
        
        /// Default initializer with configurable options
        public init(
            allowSelection: Bool = false,
            maxRows: Int? = nil,
            showBorder: Bool = true,
            stripedRows: Bool = false,
            horizontalPadding: CGFloat = CTSpacing.s,
            verticalPadding: CGFloat = CTSpacing.xs
        ) {
            self.allowSelection = allowSelection
            self.maxRows = maxRows
            self.showBorder = showBorder
            self.stripedRows = stripedRows
            self.horizontalPadding = horizontalPadding
            self.verticalPadding = verticalPadding
        }
    }
    
    // MARK: - Private Properties
    
    /// The data source for the table
    private let data: Data
    
    /// The table configuration
    private let configuration: Configuration
    
    /// A closure that generates table rows
    private let rowContent: (Data.Element) -> Content
    
    /// The current selected row ID
    @State private var selectedRowId: Data.Element.ID?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Create a table with data and row generation closure
    /// - Parameters:
    ///   - data: The collection of data to display
    ///   - configuration: Configuration options for the table
    ///   - rowContent: A closure that generates content for each row
    public init(
        _ data: Data,
        configuration: Configuration = .init(),
        @ViewBuilder rowContent: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.configuration = configuration
        self.rowContent = rowContent
    }
    
    // MARK: - Body
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(limitedData) { item in
                    rowView(for: item)
                }
            }
            .background(configuration.stripedRows ? Color.clear : theme.surface)
            .cornerRadius(theme.borderRadius)
            .overlay(
                configuration.showBorder ?
                RoundedRectangle(cornerRadius: theme.borderRadius)
                    .stroke(theme.border, lineWidth: 1) : 
                nil
            )
        }
        //.accessibilityAddTraits(.isTable)
    }
    
    // MARK: - Private Computed Properties
    
    /// The data limited by the maximum row configuration
    private var limitedData: [Data.Element] {
        guard let maxRows = configuration.maxRows else {
            return Array(data)
        }
        return Array(data.prefix(maxRows))
    }
    
    // MARK: - Private Methods
    
    /// Create a row view for a specific data item
    /// - Parameter item: The data item to render
    /// - Returns: A view representing the row
    private func rowView(for item: Data.Element) -> some View {
        let isSelected = configuration.allowSelection && selectedRowId == item.id
        
        return rowContent(item)
            .background(
                configuration.stripedRows ?
                    (isSelected ? theme.primary.opacity(0.1) : alternateRowColor()) :
                    (isSelected ? theme.primary.opacity(0.1) : theme.surface)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                if configuration.allowSelection {
                    selectedRowId = selectedRowId == item.id ? nil : item.id
                }
            }
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    /// Determine the alternate row color for striped rows
    /// - Returns: A color for alternating row backgrounds
    private func alternateRowColor() -> Color {
        return theme.surface.opacity(0.5)
    }
}

/// A row container for table data
public struct CTTableRow<Content: View>: View {
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            content
        }
    }
}

/// A cell in a table row
public struct CTTableCell: View {
    /// The content of the cell
    private let content: AnyView
    
    /// The alignment of the content
    private let alignment: HorizontalAlignment
    
    /// Initialize a new table cell with text content
    /// - Parameters:
    ///   - text: The text to display in the cell
    ///   - alignment: The alignment of the text
    public init(_ text: String, alignment: HorizontalAlignment = .leading) {
        self.content = AnyView(Text(text))
        self.alignment = alignment
    }
    
    /// Initialize a new table cell with custom content
    /// - Parameters:
    ///   - alignment: The alignment of the content
    ///   - content: The content to display in the cell
    public init(alignment: HorizontalAlignment = .leading, @ViewBuilder content: () -> some View) {
        self.content = AnyView(content())
        self.alignment = alignment
    }
    
    public var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment, vertical: .center))
    }
}

// MARK: - Previews

struct CTTable_Previews: PreviewProvider {
    struct Person: Identifiable {
        let id = UUID()
        let name: String
        let age: Int
        let city: String
    }
    
    static let people = [
        Person(name: "Alice", age: 30, city: "New York"),
        Person(name: "Bob", age: 25, city: "San Francisco"),
        Person(name: "Charlie", age: 35, city: "Los Angeles"),
        Person(name: "Diana", age: 28, city: "Chicago")
    ]
    
    static var previews: some View {
        ScrollView {
            VStack(spacing: CTSpacing.m) {
                Text("Basic Table").ctHeading2()
                CTTable(people) { person in
                    CTTableRow {
                        CTTableCell(person.name)
                        CTTableCell(String(person.age))
                        CTTableCell(person.city)
                    }
                }
                
                Text("Striped Table").ctHeading2()
                CTTable(people, configuration: .init(stripedRows: true)) { person in
                    CTTableRow {
                        CTTableCell(person.name)
                        CTTableCell(String(person.age))
                        CTTableCell(person.city)
                    }
                }
                
                Text("Selectable Table").ctHeading2()
                CTTable(people, configuration: .init(allowSelection: true)) { person in
                    CTTableRow {
                        CTTableCell(person.name)
                        CTTableCell(String(person.age))
                        CTTableCell(person.city)
                    }
                }
                
                Text("Limited Rows Table").ctHeading2()
                CTTable(people, configuration: .init(maxRows: 2)) { person in
                    CTTableRow {
                        CTTableCell(person.name)
                        CTTableCell(String(person.age))
                        CTTableCell(person.city)
                    }
                }
            }
            .padding()
        }
    }
}
