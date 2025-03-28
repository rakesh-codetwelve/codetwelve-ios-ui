//
//  CTList.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable list component for displaying collections of data with various styling options.
///
/// `CTList` provides a consistent and flexible list interface throughout your application
/// with support for different layouts, separators, and accessibility features.
///
/// # Example
///
/// ```swift
/// // Basic list of strings
/// CTList(data: ["Apple", "Banana", "Cherry"]) { item in
///     Text(item)
/// }
///
/// // Custom styled list with separators
/// CTList(
///     data: users,
///     separator: .ctDivider(),
///     selection: $selectedUser
/// ) { user in
///     UserRowView(user: user)
/// }
/// ```

// First, move PreviewPerson outside the preview scope
private struct PreviewPerson: Hashable, Identifiable {
    let id = UUID()
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

public struct CTList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable & Identifiable {
    // MARK: - Public Properties
    
    /// Defines the separator style for the list
    public enum SeparatorStyle {
        /// No separator between items
        case none
        
        /// Default system divider
        case `default`
        
        /// Custom divider using CTDivider
        case custom(CTDivider)
    }
    
    /// Defines the list layout type
    public enum ListLayout {
        /// Standard vertical list
        case vertical
        
        /// Horizontal scrolling list
        case horizontal
        
        /// Grid-based list with a specified number of columns
        case grid(columns: Int)
    }
    
    // MARK: - Private Properties
    
    /// The data source for the list
    private let data: Data
    
    /// The view builder for creating list content
    private let content: (Data.Element) -> Content
    
    /// The list layout configuration
    private let layout: ListLayout
    
    /// The separator style for the list
    private let separator: SeparatorStyle
    
    /// Optional binding for selection
    @Binding private var selection: Data.Element?
    
    /// Whether multiple selection is allowed
    private let allowsMultipleSelection: Bool
    
    /// Spacing between list items
    private let spacing: CGFloat
    
    /// Padding around the list
    private let padding: EdgeInsets
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new list with data and content
    /// - Parameters:
    ///   - data: The collection of data to display
    ///   - layout: The layout style for the list (default: vertical)
    ///   - separator: The separator style between list items (default: system)
    ///   - spacing: The spacing between list items (default: theme's standard spacing)
    ///   - padding: The padding around the list (default: minimal)
    ///   - selection: Optional binding for selected item
    ///   - allowsMultipleSelection: Whether multiple items can be selected (default: false)
    ///   - content: A view builder for creating list item content
    public init(
        _ data: Data,
        layout: ListLayout = .vertical,
        separator: SeparatorStyle = .default,
        spacing: CGFloat = CTSpacing.s,
        padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        selection: Binding<Data.Element?> = .constant(nil),
        allowsMultipleSelection: Bool = false,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.layout = layout
        self.separator = separator
        self.spacing = spacing
        self.padding = padding
        self._selection = selection
        self.allowsMultipleSelection = allowsMultipleSelection
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        switch layout {
        case .vertical:
            verticalList
        case .horizontal:
            horizontalList
        case .grid(let columns):
            gridList(columns: columns)
        }
    }
    
    // MARK: - Private Views
    
    private var verticalList: some View {
        VStack(spacing: spacing) {
            let items = Array(data)
            ForEach(items) { item in
                VStack(spacing: 0) {
                    itemView(for: item)
                    
                    if case .none = separator {
                        EmptyView()
                    } else if item.id != items.last?.id {
                        separatorView
                    }
                }
            }
        }
        .padding(padding)
    }
    
    private var separatorView: some View {
        Group {
            switch separator {
            case .default:
                Divider()
                    .padding(.horizontal, padding.leading)
                    .padding(.vertical, padding.top)
            case .custom(let divider):
                divider
                    .padding(.horizontal, padding.leading)
                    .padding(.vertical, padding.top)
            case .none:
                EmptyView()
            }
        }
    }
    
    private var horizontalList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                let items = Array(data)
                ForEach(items, id: \.id) { item in
                    itemView(for: item)
                }
            }
            .padding(padding)
        }
    }
    
    private func gridList(columns: Int) -> some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns),
                spacing: spacing
            ) {
                let items = Array(data)
                ForEach(items, id: \.id) { item in
                    itemView(for: item)
                }
            }
            .padding(padding)
        }
    }
    
    private func itemView(for item: Data.Element) -> some View {
        content(item)
            .ctConditional(selection != nil) { view in
                view.onTapGesture {
                    if allowsMultipleSelection {
                        // Implement multiple selection logic
                        // TODO: Implement multi-select
                    } else {
                        selection = (selection == item) ? nil : item
                    }
                }
                .ctSelectedAccessibility(isSelected: selection == item)
            }
    }
}

// MARK: - Supporting Types

fileprivate struct IdentifiableString: Identifiable, Hashable {
    let id = UUID()
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    static func == (lhs: IdentifiableString, rhs: IdentifiableString) -> Bool {
        lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

// MARK: - Convenience Initializers

extension CTList where Content == Text {
    /// Convenience initializer for creating a list of strings
    /// - Parameters:
    ///   - data: An array of strings to display
    ///   - configuration: Optional configuration closure
    fileprivate init(
        _ data: [String],
        configuration: ((inout CTList<[IdentifiableString], Text>) -> Void)? = nil
    ) {
        let identifiableStrings = data.map { IdentifiableString($0) }
        var list = CTList<[IdentifiableString], Text>(identifiableStrings, content: { Text($0.value) })
        configuration?(&list)
        self = list as! CTList<Data, Text>
    }
}

// MARK: - Previews

struct CTList_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedPerson: PreviewPerson? = nil
        
        let people = [
            PreviewPerson(name: "Alice"),
            PreviewPerson(name: "Bob"),
            PreviewPerson(name: "Charlie")
        ]
        
        return ScrollView {
            VStack(spacing: CTSpacing.l) {
                // Vertical List
                VStack {
                    Text("Vertical List").ctHeading3()
                    CTList(people) { person in
                        Text(person.name)
                    }
                }
                
                // Horizontal List
                VStack {
                    Text("Horizontal List").ctHeading3()
                    CTList(
                        people,
                        layout: .horizontal
                    ) { person in
                        Text(person.name)
                            .padding()
                            .background(Color.ctSecondary.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                // Grid List
                VStack {
                    Text("Grid List").ctHeading3()
                    CTList(
                        people,
                        layout: .grid(columns: 3)
                    ) { person in
                        Text(person.name)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.ctSecondary.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                
                // List with Selection
                VStack {
                    Text("List with Selection").ctHeading3()
                    CTList(
                        people,
                        selection: $selectedPerson
                    ) { person in
                        Text(person.name)
                            .padding()
                            .background(selectedPerson == person ? Color.ctPrimary.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}