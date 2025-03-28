//
//  CTCommandPalette.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A command palette component for keyboard-driven navigation and quick actions.
///
/// `CTCommandPalette` provides a powerful, searchable interface for discovering and executing actions
/// quickly using keyboard input, similar to spotlight search or command+K interfaces.
///
/// # Example
///
/// ```swift
/// CTCommandPalette(
///     items: [
///         .init(title: "New Project", icon: "plus", action: createProject),
///         .init(title: "Open Settings", icon: "gear", action: openSettings)
///     ]
/// )
/// ```
public struct CTCommandPalette: View {
    // MARK: - Public Types
    
    /// Represents an individual command or action in the command palette
    public struct CommandItem: Identifiable, Hashable {
        /// Unique identifier for the item
        public let id = UUID()
        
        /// Title of the command
        public let title: String
        
        /// Optional SF Symbol icon for the command
        public let icon: String?
        
        /// Optional description or subtitle
        public let description: String?
        
        /// The action to execute when the command is selected
        public let action: () -> Void
        
        /// Keywords for searching, optional
        public let keywords: [String]?
        
        /// Custom initializer
        public init(
            title: String,
            icon: String? = nil,
            description: String? = nil,
            keywords: [String]? = nil,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.icon = icon
            self.description = description
            self.keywords = keywords
            self.action = action
        }
        
        /// Add hash(into:) implementation
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(title)
            hasher.combine(description)
            hasher.combine(icon)
            hasher.combine(keywords)
        }
        
        /// Add == implementation
        public static func == (lhs: CommandItem, rhs: CommandItem) -> Bool {
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.icon == rhs.icon &&
            lhs.keywords == rhs.keywords
        }
    }
    
    /// Defines the visual style of the command palette
    public enum Style {
        case `default`
        case compact
        case floating
        case fullScreen
    }
    
    // MARK: - Private Properties
    
    /// The collection of commands
    private let items: [CommandItem]
    
    /// The current search query
    @State private var searchQuery: String = ""
    
    /// The currently selected item index
    @State private var selectedIndex: Int = 0
    
    /// Whether the command palette is currently visible
    @Binding private var isPresented: Bool
    
    /// The style of the command palette
    private let style: Style
    
    /// Maximum number of items to display
    private let maxDisplayItems: Int
    
    /// Action to perform when an item is selected
    private let onItemSelect: ((CommandItem) -> Void)?
    
    /// Theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Computed Properties
    
    /// Filtered and sorted items based on search query
    private var filteredItems: [CommandItem] {
        Array(
            items
                .filter { item in
                    searchQuery.isEmpty ||
                    item.title.localizedCaseInsensitiveContains(searchQuery) ||
                    (item.description?.localizedCaseInsensitiveContains(searchQuery) ?? false) ||
                    (item.keywords?.contains { $0.localizedCaseInsensitiveContains(searchQuery) } ?? false)
                }
                .sorted { first, second in
                    let firstScore = scoreItem(first)
                    let secondScore = scoreItem(second)
                    return firstScore > secondScore
                }
                .prefix(maxDisplayItems)
        )
    }
    
    // MARK: - Initializers
    
    /// Create a command palette with a collection of command items
    public init(
        items: [CommandItem],
        isPresented: Binding<Bool>,
        style: Style = .default,
        maxDisplayItems: Int = 10,
        onItemSelect: ((CommandItem) -> Void)? = nil
    ) {
        self.items = items
        self._isPresented = isPresented
        self.style = style
        self.maxDisplayItems = maxDisplayItems
        self.onItemSelect = onItemSelect
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch style {
            case .default, .compact, .floating:
                floatingPaletteView
            case .fullScreen:
                fullScreenPaletteView
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Command Palette")
        .accessibilityAddTraits(.isSearchField)
    }
    
    // MARK: - Private Views
    
    private var floatingPaletteView: some View {
        VStack {
            searchField
            itemsList
        }
        .background(theme.surface)
        .cornerRadius(theme.borderRadius)
        .shadow(color: theme.shadowColor.opacity(theme.shadowOpacity), radius: theme.shadowRadius, x: 0, y: 2)
        .frame(maxWidth: 500)
    }
    
    private var fullScreenPaletteView: some View {
        VStack {
            searchField
            itemsList
        }
        .background(theme.background)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var searchField: some View {
        TextField("Search commands...", text: $searchQuery)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(CTSpacing.s)
            .background(theme.background.opacity(0.05))
            .cornerRadius(theme.borderRadius)
            .padding(CTSpacing.m)
            .onChange(of: searchQuery) { _ in
                selectedIndex = 0
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIResponder.keyboardWillShowNotification
                )
            ) { _ in
                searchQuery = ""
            }
    }
    
    private var itemsList: some View {
        List(Array(filteredItems.enumerated()), id: \.element.id) { index, item in
            commandItemView(item, isSelected: index == selectedIndex)
                .listRowBackground(index == selectedIndex ? theme.surface.opacity(0.2) : Color.clear)
                .onTapGesture {
                    selectAndExecuteItem(item)
                }
        }
        .listStyle(PlainListStyle())
    }
    
    private func commandItemView(_ item: CommandItem, isSelected: Bool) -> some View {
        HStack {
            if let icon = item.icon {
                Image(systemName: icon)
                    .foregroundColor(theme.primary)
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                
                if let description = item.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "arrow.right")
                    .foregroundColor(theme.primary)
            }
        }
        .padding(CTSpacing.s)
    }
    
    // MARK: - Private Methods
    
    private func selectAndExecuteItem(_ item: CommandItem) {
        onItemSelect?(item)
        item.action()
        isPresented = false
    }
    
    /// Score an item for search result ranking
    private func scoreItem(_ item: CommandItem) -> Double {
        var score: Double = 0
        
        if item.title.localizedCaseInsensitiveContains(searchQuery) {
            score += 10
        }
        
        if item.description?.localizedCaseInsensitiveContains(searchQuery) ?? false {
            score += 5
        }
        
        if item.keywords?.contains(where: { $0.localizedCaseInsensitiveContains(searchQuery) }) ?? false {
            score += 3
        }
        
        return score
    }
}

// MARK: - Previews

struct CTCommandPalette_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer()
    }
    
    struct PreviewContainer: View {
        @State private var isPalettePresented = false
        
        private let sampleCommands: [CTCommandPalette.CommandItem] = [
            .init(
                title: "New Project",
                icon: "plus.circle.fill",
                description: "Create a new project",
                keywords: ["create", "start"],
                action: { print("New Project") }
            ),
            .init(
                title: "Open Settings",
                icon: "gear",
                description: "Open application settings",
                keywords: ["configure", "preferences"],
                action: { print("Open Settings") }
            ),
            .init(
                title: "Export Data",
                icon: "square.and.arrow.up",
                description: "Export current project data",
                keywords: ["save", "backup"],
                action: { print("Export Data") }
            )
        ]
        
        var body: some View {
            VStack {
                Button("Show Command Palette") {
                    isPalettePresented.toggle()
                }
                .ctTheme(CTDefaultTheme())
                
                CTCommandPalette(
                    items: sampleCommands,
                    isPresented: $isPalettePresented,
                    style: .floating
                )
            }
        }
    }
}