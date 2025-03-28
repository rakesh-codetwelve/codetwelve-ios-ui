//
//  ComponentCatalog.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// The main component catalog view that displays all available UI components organized by category.
///
/// This view serves as the primary navigation hub for exploring the CodeTwelveUI library components.
/// It organizes components into logical categories and provides navigation to detailed examples.
struct ComponentCatalog: View {
    // MARK: - Component Category
    
    /// Represents a category of components in the catalog
    struct ComponentCategory: Identifiable {
        /// Unique identifier for the category
        let id = UUID()
        
        /// The display name of the category
        let name: String
        
        /// Icon for the category (SF Symbol name)
        let icon: String
        
        /// Components within this category
        let components: [Component]
    }
    
    /// Represents a single component in the catalog
    struct Component: Identifiable {
        /// Unique identifier for the component
        let id = UUID()
        
        /// The display name of the component
        let name: String
        
        /// The destination view for this component
        let destination: AnyView
        
        /// Create a component with its name and associated view
        /// - Parameters:
        ///   - name: The display name of the component
        ///   - destination: The view to navigate to for this component
        init<V: View>(name: String, destination: V) {
            self.name = name
            self.destination = AnyView(destination)
        }
    }
    
    // MARK: - Private Properties
    
    /// The list of component categories
    private let categories: [ComponentCategory] = [
        // Basic Components
        ComponentCategory(name: "Basic", icon: "square.grid.2x2", components: [
            Component(name: "Button", destination: ButtonExamples()),
            Component(name: "Text", destination: TextExamples()),
            Component(name: "Icon", destination: IconExamples()),
            Component(name: "Divider", destination: DividerExamples())
        ]),
        
        // Layout Components
        ComponentCategory(name: "Layout", icon: "rectangle.3.group", components: [
            Component(name: "Card", destination: Text("Card Examples")),
            Component(name: "Container", destination: Text("Container Examples")),
            Component(name: "Stack", destination: Text("Stack Examples")),
            Component(name: "Grid", destination: Text("Grid Examples")),
            Component(name: "Accordion", destination: Text("Accordion Examples")),
            Component(name: "Aspect Ratio", destination: Text("Aspect Ratio Examples")),
            Component(name: "Scroll Area", destination: Text("Scroll Area Examples"))
        ]),
        
        // Form Components
        ComponentCategory(name: "Forms", icon: "text.field", components: [
            Component(name: "Text Field", destination: Text("Text Field Examples")),
            Component(name: "Secure Field", destination: Text("Secure Field Examples")),
            Component(name: "Text Area", destination: Text("Text Area Examples")),
            Component(name: "Checkbox", destination: Text("Checkbox Examples")),
            Component(name: "Radio Group", destination: Text("Radio Group Examples")),
            Component(name: "Toggle", destination: Text("Toggle Examples")),
            Component(name: "Select", destination: Text("Select Examples")),
            Component(name: "Slider", destination: Text("Slider Examples")),
            Component(name: "Date Picker", destination: Text("Date Picker Examples"))
        ]),
        
        // Feedback Components
        ComponentCategory(name: "Feedback", icon: "bell", components: [
            Component(name: "Toast", destination: Text("Toast Examples")),
            Component(name: "Alert", destination: Text("Alert Examples")),
            Component(name: "Alert Dialog", destination: Text("Alert Dialog Examples")),
            Component(name: "Progress", destination: Text("Progress Examples")),
            Component(name: "Skeleton Loader", destination: Text("Skeleton Loader Examples")),
            Component(name: "Badge", destination: Text("Badge Examples"))
        ]),
        
        // Navigation Components
        ComponentCategory(name: "Navigation", icon: "arrow.left.arrow.right", components: [
            Component(name: "Tab Bar", destination: Text("Tab Bar Examples")),
            Component(name: "Navigation Menu", destination: Text("Navigation Menu Examples")),
            Component(name: "Bottom Sheet", destination: Text("Bottom Sheet Examples")),
            Component(name: "Drawer", destination: Text("Drawer Examples")),
            Component(name: "Hamburger Menu", destination: Text("Hamburger Menu Examples")),
            Component(name: "Pagination", destination: Text("Pagination Examples")),
            Component(name: "Popover", destination: Text("Popover Examples")),
            Component(name: "Command Palette", destination: Text("Command Palette Examples"))
        ]),
        
        // Data Components
        ComponentCategory(name: "Data", icon: "chart.bar.xaxis", components: [
            Component(name: "Avatar", destination: Text("Avatar Examples")),
            Component(name: "Tag", destination: Text("Tag Examples")),
            Component(name: "List", destination: Text("List Examples")),
            Component(name: "Table", destination: Text("Table Examples")),
            Component(name: "Data Table", destination: Text("Data Table Examples")),
            Component(name: "Context Menu", destination: Text("Context Menu Examples")),
            Component(name: "Dropdown Menu", destination: Text("Dropdown Menu Examples")),
            Component(name: "Hover Card", destination: Text("Hover Card Examples"))
        ]),
        
        // Media Components
        ComponentCategory(name: "Media", icon: "photo", components: [
            Component(name: "Image", destination: Text("Image Examples")),
            Component(name: "Carousel", destination: Text("Carousel Examples")),
            Component(name: "Video", destination: Text("Video Examples"))
        ])
    ]
    
    // MARK: - Body
    
    var body: some View {
        List {
            ForEach(categories) { category in
                Section(header: sectionHeader(for: category)) {
                    ForEach(category.components) { component in
                        NavigationLink(destination: component.destination) {
                            Text(component.name)
                                .padding(.vertical, CTSpacing.xs)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("CodeTwelve UI")
        .navigationBarItems(trailing: aboutButton)
    }
    
    // MARK: - Private Views
    
    /// Creates a section header view for a component category
    /// - Parameter category: The category to create a header for
    /// - Returns: A styled section header view
    private func sectionHeader(for category: ComponentCategory) -> some View {
        HStack {
            Image(systemName: category.icon)
                .foregroundColor(Color.ctPrimary)
            
            Text(category.name)
                .font(.headline)
                .foregroundColor(Color.ctPrimary)
        }
        .padding(.vertical, CTSpacing.xxs)
    }
    
    /// About button in the navigation bar
    private var aboutButton: some View {
        Button(action: {
            // Show about information
        }) {
            Image(systemName: "info.circle")
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationView {
        ComponentCatalog()
    }
}