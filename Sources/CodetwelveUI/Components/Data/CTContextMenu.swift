//
//  CTContextMenu.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable context menu component for displaying actions on long press.
///
/// `CTContextMenu` provides a consistent and flexible context menu interface
/// throughout your application with support for different styles, positioning,
/// and accessibility features.
///
/// # Example
///
/// ```swift
/// CTContextMenu {
///     CTContextMenuItem(label: "Edit", icon: "pencil", action: editAction)
///     CTContextMenuItem(label: "Delete", icon: "trash", style: .destructive, action: deleteAction)
/// } content: {
///     Text("Long press me")
/// }
/// ```
public struct CTContextMenu<Content: View>: View {
    // MARK: - Private Properties
    
    /// The menu items to display in the context menu
    private let menuItems: [CTContextMenuItem]
    
    /// The content view that triggers the context menu
    private let content: Content
    
    /// The style of the context menu
    private let style: CTContextMenuStyle
    
    /// Indicates whether the menu can be dismissed by tapping outside
    private let dismissOnOutsideTap: Bool
    
    /// Action to perform when the context menu is shown
    private let onShow: (() -> Void)?
    
    /// Action to perform when the context menu is dismissed
    private let onDismiss: (() -> Void)?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    /// State to track menu visibility
    @State private var isPresented = false
    
    // MARK: - Initializers
    
    /// Initialize a new context menu
    /// - Parameters:
    ///   - style: The style of the context menu
    ///   - dismissOnOutsideTap: Whether the menu can be dismissed by tapping outside
    ///   - onShow: Action to perform when the menu is shown
    ///   - onDismiss: Action to perform when the menu is dismissed
    ///   - menuItems: Builder for menu items
    ///   - content: The content that triggers the context menu
    public init(
        style: CTContextMenuStyle = .default,
        dismissOnOutsideTap: Bool = true,
        onShow: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        menuItems: [CTContextMenuItem],
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.dismissOnOutsideTap = dismissOnOutsideTap
        self.onShow = onShow
        self.onDismiss = onDismiss
        self.menuItems = menuItems
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .contextMenu {
                ForEach(menuItems) { item in
                    menuItemView(item)
                }
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityHint("Long press to show actions")
    }
    
    // MARK: - Private Methods
    
    /// Create a menu item view based on the context menu style
    /// - Parameter item: The context menu item
    /// - Returns: A view representing the menu item
    private func menuItemView(_ item: CTContextMenuItem) -> some View {
        Button(action: {
            item.action()
        }) {
            HStack {
                if let icon = item.icon {
                    Image(systemName: icon)
                        .foregroundColor(iconColor(for: item))
                }
                Text(item.label)
                    .foregroundColor(textColor(for: item))
            }
        }
    }
    
    /// Get the icon color for a menu item
    /// - Parameter item: The context menu item
    /// - Returns: The appropriate color for the item's icon
    private func iconColor(for item: CTContextMenuItem) -> Color {
        switch item.style {
        case .default:
            return theme.text
        case .destructive:
            return theme.destructive
        case .custom(let color):
            return color
        }
    }
    
    /// Get the text color for a menu item
    /// - Parameter item: The context menu item
    /// - Returns: The appropriate color for the item's text
    private func textColor(for item: CTContextMenuItem) -> Color {
        switch item.style {
        case .default:
            return theme.text
        case .destructive:
            return theme.destructive
        case .custom(let color):
            return color
        }
    }
}

/// A single menu item for the context menu
public struct CTContextMenuItem: Identifiable {
    // MARK: - Public Properties
    
    /// Unique identifier for the menu item
    public let id = UUID()
    
    /// The label text for the menu item
    public let label: String
    
    /// Optional SF Symbol icon for the menu item
    public let icon: String?
    
    /// The style of the menu item
    public let style: CTContextMenuItemStyle
    
    /// The action to perform when the item is tapped
    public let action: () -> Void
    
    // MARK: - Initializers
    
    /// Initialize a new context menu item
    /// - Parameters:
    ///   - label: The label text for the menu item
    ///   - icon: Optional SF Symbol icon
    ///   - style: The style of the menu item
    ///   - action: The action to perform when tapped
    public init(
        label: String,
        icon: String? = nil,
        style: CTContextMenuItemStyle = .default,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.style = style
        self.action = action
    }
}

/// The style of a context menu item
public enum CTContextMenuItemStyle {
    /// Default style using theme's text color
    case `default`
    
    /// Destructive style using the theme's destructive color
    case destructive
    
    /// Custom color style
    case custom(Color)
}

/// The style of the context menu
public enum CTContextMenuStyle {
    /// Default style matching the theme
    case `default`
    
    /// A compact style with minimal decoration
    case compact
    
    /// A custom styled context menu
    case custom(backgroundColor: Color, foregroundColor: Color)
}

// MARK: - Previews

struct CTContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: CTSpacing.m) {
                Text("Context Menu Examples").ctHeading2()
                
                // Basic Context Menu
                CTContextMenu(
                    menuItems: [
                        CTContextMenuItem(label: "Edit", icon: "pencil") {},
                        CTContextMenuItem(label: "Delete", icon: "trash", style: .destructive) {}
                    ]
                ) {
                    Text("Basic Context Menu")
                        .ctBody()
                        .padding()
                        .background(Color.ctSecondary.opacity(0.1))
                        .cornerRadius(CTSpacing.xs)
                }
                
                // Destructive Context Menu
                CTContextMenu(
                    menuItems: [
                        CTContextMenuItem(label: "Delete", icon: "trash", style: .destructive) {}
                    ]
                ) {
                    Text("Destructive Context Menu")
                        .ctBody()
                        .padding()
                        .background(Color.ctSecondary.opacity(0.1))
                        .cornerRadius(CTSpacing.xs)
                }
                
                // Complex Context Menu
                CTContextMenu(
                    menuItems: [
                        CTContextMenuItem(label: "Copy", icon: "doc.on.doc") {},
                        CTContextMenuItem(label: "Share", icon: "square.and.arrow.up") {},
                        CTContextMenuItem(label: "Delete", icon: "trash", style: .destructive) {}
                    ]
                ) {
                    Text("Complex Context Menu")
                        .ctBody()
                        .padding()
                        .background(Color.ctSecondary.opacity(0.1))
                        .cornerRadius(CTSpacing.xs)
                }
            }
            .padding()
        }
    }
}