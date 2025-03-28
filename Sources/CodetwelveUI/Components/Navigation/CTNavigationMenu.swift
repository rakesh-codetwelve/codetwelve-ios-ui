//
//  CTNavigationMenu.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable navigation menu component for applications.
///
/// `CTNavigationMenu` provides a consistent navigation menu interface with support
/// for hierarchical structures, icons, badges, and different visual styles.
///
/// # Example
///
/// ```swift
/// struct ContentView: View {
///     @State private var selectedItem: String? = "home"
///
///     var body: some View {
///         CTNavigationMenu(
///             items: [
///                 CTNavigationItem(id: "home", label: "Home", icon: "house"),
///                 CTNavigationItem(id: "explore", label: "Explore", icon: "safari"),
///                 CTNavigationItem.separator,
///                 CTNavigationItem(id: "settings", label: "Settings", icon: "gear")
///             ],
///             selectedItemId: $selectedItem
///         )
///     }
/// }
/// ```
public struct CTNavigationMenu: View {
    // MARK: - Public Properties
    
    /// Binding to the selected item's ID
    @Binding private var selectedItemId: String?
    
    /// Array of navigation items to display
    private let items: [CTNavigationItem]
    
    /// Style of the navigation menu
    private let style: CTNavigationMenuStyle
    
    /// Whether to collapse sections by default
    private let collapseByDefault: Bool
    
    /// Whether to allow multiple expanded sections
    private let allowMultipleExpanded: Bool
    
    /// Action to perform when an item is selected
    private let onItemSelected: ((String) -> Void)?
    
    // MARK: - State Properties
    
    /// Set of expanded section IDs
    @State private var expandedSections: Set<String> = []
    
    // MARK: - Environment Properties
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new navigation menu with the specified items and configuration
    ///
    /// - Parameters:
    ///   - items: Array of navigation items to display
    ///   - selectedItemId: Binding to the selected item's ID
    ///   - style: Style of the navigation menu
    ///   - collapseByDefault: Whether to collapse sections by default
    ///   - allowMultipleExpanded: Whether to allow multiple expanded sections
    ///   - onItemSelected: Action to perform when an item is selected
    public init(
        items: [CTNavigationItem],
        selectedItemId: Binding<String?>,
        style: CTNavigationMenuStyle = .sidebar,
        collapseByDefault: Bool = false,
        allowMultipleExpanded: Bool = true,
        onItemSelected: ((String) -> Void)? = nil
    ) {
        self.items = items
        self._selectedItemId = selectedItemId
        self.style = style
        self.collapseByDefault = collapseByDefault
        self.allowMultipleExpanded = allowMultipleExpanded
        self.onItemSelected = onItemSelected
        
        // Initialize expanded sections based on default collapse preference
        if !collapseByDefault {
            var initialExpandedSections: Set<String> = []
            for item in items {
                if case .section(let id, _, _) = item {
                    initialExpandedSections.insert(id)
                }
            }
            self._expandedSections = State(initialValue: initialExpandedSections)
        }
    }
    
    // MARK: - Body
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    navigationItem(for: item)
                }
            }
            .padding(.vertical, CTSpacing.xs)
        }
        .background(backgroundColor)
    }
    
    // MARK: - Private Methods
    
    /// Create a view for the specified navigation item
    ///
    /// - Parameter item: The navigation item
    /// - Returns: A view representing the navigation item
    @ViewBuilder
    private func navigationItem(for item: CTNavigationItem) -> some View {
        switch item {
        case .item(let id, let label, let icon, let badge, let isEnabled, let action):
            createItemButton(
                id: id,
                label: label,
                icon: icon,
                badge: badge,
                isEnabled: isEnabled,
                action: action
            )
            
        case .section(let id, let label, let children):
            createSectionView(id: id, label: label, children: children)
            
        case .separator:
            createSeparator()
            
        case .customView(let view):
            view
        }
    }
    
    /// Create a button for a navigation item
    ///
    /// - Parameters:
    ///   - id: The ID of the item
    ///   - label: The label of the item
    ///   - icon: The icon of the item (optional)
    ///   - badge: The badge to display (optional)
    ///   - isEnabled: Whether the item is enabled
    ///   - action: Custom action to perform (optional)
    /// - Returns: A button view for the navigation item
    private func createItemButton(
        id: String,
        label: String,
        icon: String?,
        badge: CTNavigationBadge?,
        isEnabled: Bool,
        action: (() -> Void)?
    ) -> some View {
        let isSelected = selectedItemId == id
        
        return Button(action: {
            if isEnabled {
                if action != nil {
                    action?()
                } else {
                    selectedItemId = id
                    onItemSelected?(id)
                }
            }
        }) {
            HStack {
                // Icon (if provided)
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: iconSize, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? activeIconColor : inactiveIconColor)
                        .frame(width: iconSize + CTSpacing.s)
                }
                
                // Label
                Text(label)
                    .font(.system(size: fontSize, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? activeTextColor : inactiveTextColor)
                
                Spacer()
                
                // Badge (if provided)
                if let badge = badge {
                    badgeView(badge)
                }
            }
            .padding(.vertical, CTSpacing.s)
            .padding(.horizontal, CTSpacing.m)
            .background(
                RoundedRectangle(cornerRadius: theme.borderRadius)
                    .fill(isSelected ? activeBackgroundColor : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityLabel(label)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
    
    /// Create a view for a section
    ///
    /// - Parameters:
    ///   - id: The ID of the section
    ///   - label: The label of the section
    ///   - children: The child items of the section
    /// - Returns: A view for the section
    private func createSectionView(
        id: String,
        label: String,
        children: [CTNavigationItem]
    ) -> some View {
        let isExpanded = expandedSections.contains(id)
        
        return VStack(spacing: 0) {
            // Section header
            Button(action: {
                toggleSection(id)
            }) {
                HStack {
                    Text(label)
                        .font(.system(size: fontSize, weight: .semibold))
                        .foregroundColor(sectionTextColor)
                    
                    Spacer()
                    
                    // Chevron indicator
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(sectionTextColor.opacity(0.7))
                }
                .padding(.vertical, CTSpacing.s)
                .padding(.horizontal, CTSpacing.m)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityAddTraits(.isHeader)
            
            // Children if expanded
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(children.indices, id: \.self) { index in
                        navigationItem(for: children[index])
                            .padding(.leading, CTSpacing.m)
                    }
                }
            }
        }
    }
    
    /// Create a separator view
    ///
    /// - Returns: A separator view
    private func createSeparator() -> some View {
        CTDivider(color: separatorColor, opacity: 0.5)
            .padding(.vertical, CTSpacing.xs)
            .padding(.horizontal, CTSpacing.m)
    }
    
    /// Create a badge view
    ///
    /// - Parameter badge: The badge configuration
    /// - Returns: A badge view
    @ViewBuilder
    private func badgeView(_ badge: CTNavigationBadge) -> some View {
        switch badge {
        case .dot(let color):
            Circle()
                .fill(color ?? theme.destructive)
                .frame(width: 8, height: 8)
        
        case .count(let count, let color):
            if count > 0 {
                Text("\(count > 99 ? "99+" : "\(count)")")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(color ?? theme.destructive)
                    .cornerRadius(10)
            }
            
        case .text(let text, let color):
            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(color ?? theme.primary)
                .cornerRadius(10)
        }
    }
    
    /// Toggle the expanded state of a section
    ///
    /// - Parameter id: The ID of the section
    private func toggleSection(_ id: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if expandedSections.contains(id) {
                expandedSections.remove(id)
            } else {
                if !allowMultipleExpanded {
                    expandedSections.removeAll()
                }
                expandedSections.insert(id)
            }
        }
    }
    
    // MARK: - Private Properties
    
    /// Background color based on style
    private var backgroundColor: Color {
        switch style {
        case .sidebar:
            return theme.background
        case .transparent:
            return Color.clear
        case .solid(let color):
            return color
        }
    }
    
    /// Active text color based on style
    private var activeTextColor: Color {
        switch style {
        case .sidebar, .transparent:
            return theme.primary
        case .solid:
            return theme.primary
        }
    }
    
    /// Inactive text color based on style
    private var inactiveTextColor: Color {
        return theme.text
    }
    
    /// Active icon color based on style
    private var activeIconColor: Color {
        return activeTextColor
    }
    
    /// Inactive icon color based on style
    private var inactiveIconColor: Color {
        return theme.textSecondary
    }
    
    /// Active background color based on style
    private var activeBackgroundColor: Color {
        switch style {
        case .sidebar:
            return theme.primary.opacity(0.1)
        case .transparent:
            return theme.primary.opacity(0.1)
        case .solid:
            return theme.primary.opacity(0.2)
        }
    }
    
    /// Section text color based on style
    private var sectionTextColor: Color {
        return theme.textSecondary
    }
    
    /// Separator color based on style
    private var separatorColor: Color {
        return theme.border
    }
    
    /// Font size for navigation items
    private var fontSize: CGFloat {
        return 16
    }
    
    /// Icon size for navigation items
    private var iconSize: CGFloat {
        return 16
    }
}

// MARK: - Supporting Types

/// Represents an item in the navigation menu
public enum CTNavigationItem {
    /// Regular navigation item
    case item(
        id: String,
        label: String,
        icon: String? = nil,
        badge: CTNavigationBadge? = nil,
        isEnabled: Bool = true,
        action: (() -> Void)? = nil
    )
    
    /// Section with child items
    case section(
        id: String,
        label: String,
        children: [CTNavigationItem]
    )
    
    /// Separator line
    case separator
    
    /// Custom view
    case customView(AnyView)
    
    /// Create a custom item with a view
    ///
    /// - Parameter view: The view to display
    /// - Returns: A navigation item with a custom view
    public static func custom<Content: View>(_ view: Content) -> CTNavigationItem {
        return .customView(AnyView(view))
    }
}

/// Badge to display on a navigation item
public enum CTNavigationBadge {
    /// Simple dot indicator
    case dot(color: Color? = nil)
    
    /// Numeric counter
    case count(Int, color: Color? = nil)
    
    /// Text label
    case text(String, color: Color? = nil)
}

/// Style of the navigation menu
public enum CTNavigationMenuStyle: Hashable {
    /// Standard sidebar style with light background
    case sidebar
    
    /// Transparent background
    case transparent
    
    /// Solid color background
    case solid(Color)
}

// MARK: - Previews

struct CTNavigationMenu_Previews: PreviewProvider {
    struct NavigationMenuPreview: View {
        @State private var selectedItem: String? = "home"
        let style: CTNavigationMenuStyle
        
        var body: some View {
            CTNavigationMenu(
                items: [
                    .item(id: "home", label: "Home", icon: "house"),
                    .item(id: "search", label: "Search", icon: "magnifyingglass"),
                    .item(id: "favorites", label: "Favorites", icon: "heart", badge: .count(5)),
                    .separator,
                    .section(id: "content", label: "Content", children: [
                        .item(id: "photos", label: "Photos", icon: "photo"),
                        .item(id: "videos", label: "Videos", icon: "film"),
                        .item(id: "music", label: "Music", icon: "music.note")
                    ]),
                    .section(id: "settings", label: "Settings", children: [
                        .item(id: "account", label: "Account", icon: "person.circle"),
                        .item(id: "notifications", label: "Notifications", icon: "bell", badge: .dot()),
                        .item(id: "appearance", label: "Appearance", icon: "paintbrush"),
                        .item(id: "security", label: "Security", icon: "lock.shield"),
                        .item(id: "help", label: "Help & Support", icon: "questionmark.circle", isEnabled: false)
                    ]),
                    .separator,
                    .item(id: "logout", label: "Log Out", icon: "rectangle.portrait.and.arrow.right")
                ],
                selectedItemId: $selectedItem,
                style: style
            )
            .frame(width: 250)
            .frame(maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
        }
    }
    
    static var previews: some View {
        Group {
            NavigationMenuPreview(style: .sidebar)
                .previewDisplayName("Sidebar Style")
            
            NavigationMenuPreview(style: .transparent)
                .previewDisplayName("Transparent Style")
            
            NavigationMenuPreview(style: .solid(Color.blue.opacity(0.1)))
                .previewDisplayName("Solid Style")
            
            VStack(alignment: .leading) {
                Text("Navigation Menu with Different Badges").ctHeading2()
                    .padding()
                
                CTNavigationMenu(
                    items: [
                        .item(id: "item1", label: "No Badge", icon: "circle"),
                        .item(id: "item2", label: "Dot Badge", icon: "circle", badge: .dot()),
                        .item(id: "item3", label: "Count Badge (5)", icon: "circle", badge: .count(5)),
                        .item(id: "item4", label: "Count Badge (100+)", icon: "circle", badge: .count(105)),
                        .item(id: "item5", label: "Text Badge", icon: "circle", badge: .text("NEW")),
                        .item(id: "item6", label: "Custom Color Badge", icon: "circle", badge: .dot(color: .green)),
                    ],
                    selectedItemId: .constant("item2")
                )
                .frame(width: 250)
            }
            .previewDisplayName("Badge Styles")
        }
    }
}