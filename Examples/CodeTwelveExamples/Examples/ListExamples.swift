//
//  ListExamples.swift
//  CodeTwelveExamples
//
//  Created on 29/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view showcasing various examples of the `CTList` component.
struct ListExamples: View {
    // MARK: - Data Models
    
    /// Sample person model for examples
    private struct Person: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let role: String
        let avatar: String  // This would be an image in a real app, using SF Symbol names here
        
        static let samples = [
            Person(name: "Alice Smith", role: "Designer", avatar: "person.fill"),
            Person(name: "Bob Johnson", role: "Developer", avatar: "hammer.fill"),
            Person(name: "Carol Williams", role: "Manager", avatar: "briefcase.fill"),
            Person(name: "Dave Brown", role: "Developer", avatar: "hammer.fill"),
            Person(name: "Eve Davis", role: "Marketer", avatar: "megaphone.fill")
        ]
    }
    
    /// Sample product model for examples
    private struct Product: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let price: Double
        let category: String
        let image: String  // Using SF Symbol names as placeholders
        
        static let samples = [
            Product(name: "Laptop", price: 1299.99, category: "Electronics", image: "laptopcomputer"),
            Product(name: "Phone", price: 799.99, category: "Electronics", image: "iphone"),
            Product(name: "Headphones", price: 199.99, category: "Audio", image: "headphones"),
            Product(name: "Monitor", price: 399.99, category: "Electronics", image: "display"),
            Product(name: "Speaker", price: 149.99, category: "Audio", image: "speaker.wave.3.fill")
        ]
    }
    
    // MARK: - State Properties
    
    @State private var selectedPerson: Person? = nil
    @State private var selectedProduct: Product? = nil
    @State private var showCode: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.xl) {
                // Basic Usage
                Group {
                    SectionHeader(title: "Basic Usage", showCode: $showCode)
                    
                    Text("A simple vertical list displaying string items.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    basicUsageSection
                    
                    if showCode {
                        CodePreview("""
                        // Simple list with string data
                        let items = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
                        
                        CTList(items) { item in
                            Text(item)
                                .padding()
                        }
                        """)
                    }
                }
                
                // List Layouts
                Group {
                    Text("List Layouts").ctHeading2()
                    
                    Text("Lists can be displayed in vertical, horizontal, or grid layouts.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    listLayoutsSection
                    
                    if showCode {
                        CodePreview("""
                        // Vertical layout (default)
                        CTList(items) { item in
                            Text(item)
                        }
                        
                        // Horizontal layout
                        CTList(
                            items,
                            layout: .horizontal
                        ) { item in
                            Text(item)
                                .padding()
                                .background(Color.ctSecondary.opacity(0.1))
                        }
                        
                        // Grid layout
                        CTList(
                            items,
                            layout: .grid(columns: 2)
                        ) { item in
                            Text(item)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.ctSecondary.opacity(0.1))
                        }
                        """)
                    }
                }
                
                // Separators
                Group {
                    Text("Separators").ctHeading2()
                    
                    Text("Lists can display different types of separators between items.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    separatorsSection
                    
                    if showCode {
                        CodePreview("""
                        // Default system separator
                        CTList(
                            people,
                            separator: .default
                        ) { person in
                            Text(person.name)
                                .padding()
                        }
                        
                        // Custom separator using CTDivider
                        CTList(
                            people,
                            separator: .custom(
                                CTDivider(color: .ctPrimary, thickness: 2)
                            )
                        ) { person in
                            Text(person.name)
                                .padding()
                        }
                        
                        // No separator
                        CTList(
                            people,
                            separator: .none
                        ) { person in
                            Text(person.name)
                                .padding()
                        }
                        """)
                    }
                }
                
                // Selection
                Group {
                    Text("Selection").ctHeading2()
                    
                    Text("Lists can support item selection with visual feedback.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    selectionSection
                    
                    if showCode {
                        CodePreview("""
                        @State private var selectedPerson: Person? = nil
                        
                        CTList(
                            people,
                            selection: $selectedPerson
                        ) { person in
                            HStack {
                                Image(systemName: person.avatar)
                                    .foregroundColor(.ctPrimary)
                                
                                VStack(alignment: .leading) {
                                    Text(person.name)
                                        .font(.headline)
                                    Text(person.role)
                                        .font(.subheadline)
                                        .foregroundColor(.ctTextSecondary)
                                }
                            }
                            .padding()
                            .background(selectedPerson == person ? Color.ctPrimary.opacity(0.1) : Color.clear)
                            .cornerRadius(8)
                        }
                        """)
                    }
                }
                
                // Custom Item Styling
                Group {
                    Text("Custom Item Styling").ctHeading2()
                    
                    Text("List items can be styled however you like for complex content.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    customStylingSection
                    
                    if showCode {
                        CodePreview("""
                        CTList(products) { product in
                            HStack {
                                Image(systemName: product.image)
                                    .font(.system(size: 24))
                                    .foregroundColor(.ctPrimary)
                                    .frame(width: 40, height: 40)
                                    .background(Color.ctSecondary.opacity(0.1))
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading) {
                                    Text(product.name)
                                        .font(.headline)
                                    
                                    HStack {
                                        Text(product.category)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(Color.ctSecondary.opacity(0.1))
                                            .cornerRadius(4)
                                        
                                        Spacer()
                                        
                                        Text("$\\(String(format: "%.2f", product.price))")
                                            .font(.headline)
                                            .foregroundColor(.ctPrimary)
                                    }
                                }
                                .padding(.leading, 8)
                            }
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                        """)
                    }
                }
                
                // Real-world Example
                Group {
                    Text("Real-world Example").ctHeading2()
                    
                    Text("A functional example showing selection and custom layout.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    realWorldExample
                }
            }
            .padding()
        }
        .navigationTitle("List")
    }
    
    // MARK: - Example Sections
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading) {
            let items = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
            
            CTCard {
                CTList(items.map { IdentifiableString($0) }) { item in
                    Text(item.value)
                        .padding()
                }
            }
        }
        .padding(.vertical)
    }
    
    private var listLayoutsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.l) {
            let items = ["One", "Two", "Three", "Four", "Five", "Six"].map { IdentifiableString($0) }
            
            // Vertical layout
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Vertical Layout").ctBodyBold()
                
                CTCard {
                    CTList(items) { item in
                        Text(item.value)
                            .padding()
                    }
                }
            }
            
            // Horizontal layout
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Horizontal Layout").ctBodyBold()
                
                CTCard {
                    CTList(
                        items,
                        layout: .horizontal
                    ) { item in
                        Text(item.value)
                            .padding()
                            .background(Color.ctSecondary.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            
            // Grid layout
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Grid Layout").ctBodyBold()
                
                CTCard {
                    CTList(
                        items,
                        layout: .grid(columns: 2)
                    ) { item in
                        Text(item.value)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.ctSecondary.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var separatorsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.l) {
            // Default separator
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Default Separator").ctBodyBold()
                
                CTCard {
                    CTList(
                        Person.samples,
                        separator: .default
                    ) { person in
                        Text(person.name)
                            .padding()
                    }
                }
            }
            
            // Custom separator
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Custom Separator").ctBodyBold()
                
                CTCard {
                    CTList(
                        Person.samples,
                        separator: .custom(
                            CTDivider(color: .ctPrimary, thickness: 2)
                        )
                    ) { person in
                        Text(person.name)
                            .padding()
                    }
                }
            }
            
            // No separator
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("No Separator").ctBodyBold()
                
                CTCard {
                    CTList(
                        Person.samples,
                        separator: .none
                    ) { person in
                        Text(person.name)
                            .padding()
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var selectionSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.s) {
            Text("Tap an item to select it").ctBodySmall()
            
            CTCard {
                CTList(
                    Person.samples,
                    selection: $selectedPerson
                ) { person in
                    HStack {
                        Image(systemName: person.avatar)
                            .foregroundColor(.ctPrimary)
                        
                        VStack(alignment: .leading) {
                            Text(person.name)
                                .font(.headline)
                            Text(person.role)
                                .font(.subheadline)
                                .foregroundColor(.ctTextSecondary)
                        }
                    }
                    .padding()
                    .background(selectedPerson == person ? Color.ctPrimary.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
                }
            }
            
            if let selected = selectedPerson {
                Text("Selected: \(selected.name)")
                    .ctBodyBold()
                    .foregroundColor(.ctPrimary)
                    .padding(.top)
            }
        }
        .padding(.vertical)
    }
    
    private var customStylingSection: some View {
        VStack(alignment: .leading) {
            CTCard {
                CTList(Product.samples) { product in
                    HStack {
                        Image(systemName: product.image)
                            .font(.system(size: 24))
                            .foregroundColor(.ctPrimary)
                            .frame(width: 40, height: 40)
                            .background(Color.ctSecondary.opacity(0.1))
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline)
                            
                            HStack {
                                Text(product.category)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.ctSecondary.opacity(0.1))
                                    .cornerRadius(4)
                                
                                Spacer()
                                
                                Text("$\(String(format: "%.2f", product.price))")
                                    .font(.headline)
                                    .foregroundColor(.ctPrimary)
                            }
                        }
                        .padding(.leading, 8)
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
            }
        }
        .padding(.vertical)
    }
    
    private var realWorldExample: some View {
        VStack(alignment: .leading, spacing: CTSpacing.l) {
            Text("Product Catalog")
                .ctHeading3()
            
            HStack(spacing: CTSpacing.l) {
                // Product list
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Products").ctBodyBold()
                    
                    CTCard {
                        CTList(
                            Product.samples,
                            selection: $selectedProduct
                        ) { product in
                            HStack {
                                Image(systemName: product.image)
                                    .font(.system(size: 20))
                                    .foregroundColor(.ctPrimary)
                                    .frame(width: 32, height: 32)
                                
                                Text(product.name)
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("$\(String(format: "%.2f", product.price))")
                                    .font(.subheadline)
                                    .foregroundColor(.ctTextSecondary)
                            }
                            .padding()
                            .background(selectedProduct == product ? Color.ctPrimary.opacity(0.1) : Color.clear)
                        }
                    }
                }
                .frame(width: 300)
                
                // Product details
                if let product = selectedProduct {
                    VStack(alignment: .leading, spacing: CTSpacing.m) {
                        Text("Product Details").ctBodyBold()
                        
                        CTCard {
                            VStack(alignment: .leading, spacing: CTSpacing.m) {
                                HStack(alignment: .top) {
                                    Image(systemName: product.image)
                                        .font(.system(size: 48))
                                        .foregroundColor(.ctPrimary)
                                        .frame(width: 100, height: 100)
                                        .background(Color.ctSecondary.opacity(0.1))
                                        .cornerRadius(12)
                                    
                                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                        Text(product.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        
                                        Text(product.category)
                                            .font(.subheadline)
                                            .foregroundColor(.ctTextSecondary)
                                        
                                        Text("$\(String(format: "%.2f", product.price))")
                                            .font(.title3)
                                            .foregroundColor(.ctPrimary)
                                            .padding(.top, 4)
                                    }
                                }
                                
                                Divider()
                                
                                Text("Product Description")
                                    .font(.headline)
                                
                                Text("This is a sample product description for the \(product.name). It would include details about the product features, specifications, and other relevant information.")
                                    .foregroundColor(.ctTextSecondary)
                                
                                CTButton("Add to Cart", icon: "cart.fill.badge.plus") {
                                    // Add to cart action
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding()
                        }
                    }
                } else {
                    VStack {
                        Text("Select a product to view details")
                            .ctBody()
                            .foregroundColor(.ctTextSecondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                }
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Supporting Types

/// A helper struct to make strings identifiable for the list
fileprivate struct IdentifiableString: Identifiable, Hashable {
    let id = UUID()
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
}

// MARK: - Previews

struct ListExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListExamples()
        }
    }
}
