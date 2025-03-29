//
//  TableExamples.swift
//  CodeTwelveExamples
//
//  Created on 29/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view showcasing various examples of the `CTTable` component.
struct TableExamples: View {
    // MARK: - Data Models
    
    /// Sample employee model for examples
    private struct Employee: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let position: String
        let department: String
        let salary: Double
        
        static let samples = [
            Employee(name: "Alice Smith", position: "Senior Developer", department: "Engineering", salary: 120000),
            Employee(name: "Bob Johnson", position: "Product Manager", department: "Product", salary: 135000),
            Employee(name: "Carol Williams", position: "Designer", department: "Design", salary: 95000),
            Employee(name: "Dave Brown", position: "Junior Developer", department: "Engineering", salary: 80000),
            Employee(name: "Eve Davis", position: "Marketing Lead", department: "Marketing", salary: 110000)
        ]
    }
    
    /// Sample product model for examples
    private struct Product: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let category: String
        let price: Double
        let stock: Int
        let status: Status
        
        enum Status: String {
            case available = "Available"
            case lowStock = "Low Stock"
            case outOfStock = "Out of Stock"
            
            var color: Color {
                switch self {
                case .available:
                    return .ctSuccess
                case .lowStock:
                    return .ctWarning
                case .outOfStock:
                    return .ctDestructive
                }
            }
        }
        
        static let samples = [
            Product(name: "Laptop Pro", category: "Electronics", price: 1999.99, stock: 45, status: .available),
            Product(name: "Smartphone X", category: "Electronics", price: 899.99, stock: 120, status: .available),
            Product(name: "Wireless Headphones", category: "Audio", price: 199.99, stock: 8, status: .lowStock),
            Product(name: "4K Monitor", category: "Displays", price: 349.99, stock: 0, status: .outOfStock),
            Product(name: "Ergonomic Keyboard", category: "Accessories", price: 129.99, stock: 65, status: .available),
            Product(name: "Wireless Mouse", category: "Accessories", price: 49.99, stock: 5, status: .lowStock)
        ]
    }
    
    // MARK: - State Properties
    
    @State private var selectedEmployee: Employee? = nil
    @State private var selectedProduct: Product? = nil
    @State private var showCode: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.xl) {
                // Basic Usage
                Group {
                    SectionHeader(title: "Basic Usage", showCode: $showCode)
                    
                    Text("A simple table displaying employee data.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    basicUsageSection
                    
                    if showCode {
                        CodePreview(code: """
                        CTTable(employees) { employee in
                            CTTableRow {
                                CTTableCell(employee.name)
                                CTTableCell(employee.position)
                                CTTableCell(employee.department)
                                CTTableCell("$\\(formatCurrency(employee.salary))")
                            }
                        }
                        """)
                    }
                }
                
                // Style Options
                Group {
                    Text("Style Options").ctHeading2()
                    
                    Text("Tables can be styled with different visual options.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    styleOptionsSection
                    
                    if showCode {
                        CodePreview(code: """
                        // Striped rows
                        CTTable(
                            employees,
                            configuration: .init(stripedRows: true)
                        ) { employee in
                            CTTableRow {
                                CTTableCell(employee.name)
                                CTTableCell(employee.position)
                                CTTableCell(employee.department)
                                CTTableCell("$\\(formatCurrency(employee.salary))")
                            }
                        }
                        
                        // Without border
                        CTTable(
                            employees,
                            configuration: .init(showBorder: false)
                        ) { employee in
                            CTTableRow {
                                CTTableCell(employee.name)
                                CTTableCell(employee.position)
                                CTTableCell(employee.department)
                                CTTableCell("$\\(formatCurrency(employee.salary))")
                            }
                        }
                        """)
                    }
                }
                
                // Row Selection
                Group {
                    Text("Row Selection").ctHeading2()
                    
                    Text("Tables can have selectable rows with visual feedback.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    rowSelectionSection
                    
                    if showCode {
                        CodePreview(code: """
                        @State private var selectedEmployee: Employee? = nil
                        
                        CTTable(
                            employees,
                            configuration: .init(allowSelection: true)
                        ) { employee in
                            CTTableRow {
                                CTTableCell(employee.name)
                                CTTableCell(employee.position)
                                CTTableCell(employee.department)
                                CTTableCell("$\\(formatCurrency(employee.salary))")
                            }
                        }
                        """)
                    }
                }
                
                // Custom Cell Content
                Group {
                    Text("Custom Cell Content").ctHeading2()
                    
                    Text("Table cells can contain custom content beyond simple text.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    customCellContentSection
                    
                    if showCode {
                        CodePreview(code: """
                        CTTable(products) { product in
                            CTTableRow {
                                // Name cell
                                CTTableCell {
                                    Text(product.name)
                                        .fontWeight(.medium)
                                }
                                
                                // Category cell
                                CTTableCell {
                                    Text(product.category)
                                }
                                
                                // Price cell with formatting
                                CTTableCell(alignment: .trailing) {
                                    Text("$\\(formatCurrency(product.price))")
                                        .foregroundColor(.ctPrimary)
                                }
                                
                                // Stock cell with visual indicator
                                CTTableCell(alignment: .center) {
                                    HStack {
                                        Text("\\(product.stock)")
                                        
                                        if product.stock == 0 {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .foregroundColor(.ctDestructive)
                                        } else if product.stock < 10 {
                                            Image(systemName: "exclamationmark.circle.fill")
                                                .foregroundColor(.ctWarning)
                                        }
                                    }
                                }
                                
                                // Status cell with badge
                                CTTableCell {
                                    Text(product.status.rawValue)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(product.status.color.opacity(0.1))
                                        .foregroundColor(product.status.color)
                                        .cornerRadius(4)
                                }
                            }
                        }
                        """)
                    }
                }
                
                // Real-world Example
                Group {
                    Text("Real-world Example").ctHeading2()
                    
                    Text("A practical example of the table component with selection.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    realWorldExample
                }
            }
            .padding()
        }
        .navigationTitle("Table")
    }
    
    // MARK: - Example Sections
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading) {
            CTCard {
                CTTable(Employee.samples) { employee in
                    CTTableRow {
                        CTTableCell(employee.name)
                        CTTableCell(employee.position)
                        CTTableCell(employee.department)
                        CTTableCell("$\(formatCurrency(employee.salary))")
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var styleOptionsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.l) {
            // Striped rows
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Striped Rows").ctBodyBold()
                
                CTCard {
                    CTTable(
                        Employee.samples,
                        configuration: .init(stripedRows: true)
                    ) { employee in
                        CTTableRow {
                            CTTableCell(employee.name)
                            CTTableCell(employee.position)
                            CTTableCell(employee.department)
                            CTTableCell("$\(formatCurrency(employee.salary))")
                        }
                    }
                }
            }
            
            // Without border
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Without Border").ctBodyBold()
                
                CTCard {
                    CTTable(
                        Employee.samples,
                        configuration: .init(showBorder: false)
                    ) { employee in
                        CTTableRow {
                            CTTableCell(employee.name)
                            CTTableCell(employee.position)
                            CTTableCell(employee.department)
                            CTTableCell("$\(formatCurrency(employee.salary))")
                        }
                    }
                }
            }
            
            // Custom Padding
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Custom Padding").ctBodyBold()
                
                CTCard {
                    CTTable(
                        Employee.samples,
                        configuration: .init(
                            horizontalPadding: CTSpacing.l,
                            verticalPadding: CTSpacing.m
                        )
                    ) { employee in
                        CTTableRow {
                            CTTableCell(employee.name)
                            CTTableCell(employee.position)
                            CTTableCell(employee.department)
                            CTTableCell("$\(formatCurrency(employee.salary))")
                        }
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var rowSelectionSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.s) {
            Text("Tap a row to select it").ctBodySmall()
            
            CTCard {
                CTTable(
                    Employee.samples,
                    configuration: .init(allowSelection: true)
                ) { employee in
                    CTTableRow {
                        CTTableCell(employee.name)
                        CTTableCell(employee.position)
                        CTTableCell(employee.department)
                        CTTableCell("$\(formatCurrency(employee.salary))")
                    }
                }
            }
            
            if let selected = selectedEmployee {
                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                    Text("Selected Employee:").ctBodyBold()
                    Text(selected.name).ctBody()
                    Text("\(selected.position), \(selected.department)").ctBodySmall()
                }
                .foregroundColor(.ctPrimary)
                .padding(.top)
            }
        }
        .padding(.vertical)
    }
    
    private var customCellContentSection: some View {
        VStack(alignment: .leading) {
            CTCard {
                CTTable(Product.samples) { product in
                    CTTableRow {
                        // Name cell
                        CTTableCell {
                            Text(product.name)
                                .fontWeight(.medium)
                        }
                        
                        // Category cell
                        CTTableCell {
                            Text(product.category)
                        }
                        
                        // Price cell with formatting
                        CTTableCell(alignment: .trailing) {
                            Text("$\(formatCurrency(product.price))")
                                .foregroundColor(.ctPrimary)
                        }
                        
                        // Stock cell with visual indicator
                        CTTableCell(alignment: .center) {
                            HStack {
                                Text("\(product.stock)")
                                
                                if product.stock == 0 {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.ctDestructive)
                                } else if product.stock < 10 {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.ctWarning)
                                }
                            }
                        }
                        
                        // Status cell with badge
                        CTTableCell {
                            Text(product.status.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(product.status.color.opacity(0.1))
                                .foregroundColor(product.status.color)
                                .cornerRadius(4)
                        }
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var realWorldExample: some View {
        VStack(alignment: .leading, spacing: CTSpacing.l) {
            Text("Inventory Management")
                .ctHeading3()
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                HStack {
                    Text("Product Inventory").ctBodyBold()
                    
                    Spacer()
                    
                    Text("Total Products: \(Product.samples.count)")
                        .ctBodySmall()
                        .foregroundColor(.ctTextSecondary)
                }
                
                CTCard {
                    CTTable(
                        Product.samples,
                        configuration: .init(
                            allowSelection: true,
                            stripedRows: true
                        )
                    ) { product in
                        CTTableRow {
                            // Name cell
                            CTTableCell {
                                Text(product.name)
                                    .fontWeight(.medium)
                            }
                            
                            // Category cell
                            CTTableCell {
                                Text(product.category)
                            }
                            
                            // Price cell
                            CTTableCell(alignment: .trailing) {
                                Text("$\(formatCurrency(product.price))")
                                    .foregroundColor(.ctPrimary)
                            }
                            
                            // Stock cell
                            CTTableCell(alignment: .center) {
                                HStack {
                                    Text("\(product.stock)")
                                    
                                    if product.stock == 0 {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.ctDestructive)
                                    } else if product.stock < 10 {
                                        Image(systemName: "exclamationmark.circle.fill")
                                            .foregroundColor(.ctWarning)
                                    }
                                }
                            }
                            
                            // Status cell
                            CTTableCell {
                                Text(product.status.rawValue)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(product.status.color.opacity(0.1))
                                    .foregroundColor(product.status.color)
                                    .cornerRadius(4)
                            }
                            
                            // Actions cell
                            CTTableCell(alignment: .trailing) {
                                HStack(spacing: CTSpacing.s) {
                                    Button(action: {}) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.ctPrimary)
                                    }
                                    
                                    Button(action: {}) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.ctDestructive)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Summary section
            HStack(spacing: CTSpacing.m) {
                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                    Text("Total Value").ctBodySmall().foregroundColor(.ctTextSecondary)
                    Text("$\(formatCurrency(Product.samples.reduce(0) { $0 + $1.price * Double($1.stock) }))")
                        .ctHeading3()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.ctBackground)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                    Text("Total Items").ctBodySmall().foregroundColor(.ctTextSecondary)
                    Text("\(Product.samples.reduce(0) { $0 + $1.stock })")
                        .ctHeading3()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.ctBackground)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                    Text("Low Stock Items").ctBodySmall().foregroundColor(.ctTextSecondary)
                    Text("\(Product.samples.filter { $0.status == .lowStock || $0.status == .outOfStock }.count)")
                        .ctHeading3()
                        .foregroundColor(.ctWarning)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.ctBackground)
                .cornerRadius(8)
            }
        }
        .padding(.vertical)
    }
    
    // MARK: - Helper Methods
    
    /// Format a Double as a currency string with 2 decimal places
    private func formatCurrency(_ value: Double) -> String {
        String(format: "%.2f", value)
    }
}

// MARK: - Previews

struct TableExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TableExamples()
        }
    }
}
