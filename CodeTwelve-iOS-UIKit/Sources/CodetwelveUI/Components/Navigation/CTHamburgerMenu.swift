//
//  CTHamburgerMenu.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable hamburger menu component for mobile navigation interfaces.
///
/// `CTHamburgerMenu` provides a flexible and accessible navigation menu
/// that can be used to display menu items, sections, and interactive elements.
///
/// # Features
/// - Supports multiple navigation sections
/// - Customizable styling
/// - Accessibility optimized
/// - Dynamic content support
/// - State management for menu expansion
///
/// # Example
///
/// ```swift
/// CTHamburgerMenu(
///     sections: [
///         .section(title: "Main", items: [
///             .item(title: "Home", icon: "house.fill", action: { navigateToHome() }),
///             .item(title: "Profile", icon: "person.fill", action: { navigateToProfile() })
///         ]),
///         .section(title: "Settings", items: [
///             .item(title: "Preferences", icon: "gear", action: { showPreferences() }),
///             .item(title: "Logout", icon: "exit", action: { logout() })
///         ])
///     ]
/// )
/// ```
public struct CTHamburgerMenu: View {
    // MARK: - Public Enums
    
    /// Represents a navigation item in the hamburger menu
    public enum MenuItem {
        /// A standard menu item with a title, optional icon, and action
        case item(title: String, icon: String?, action: () -> Void)
        
        /// A section header to group related menu items
        case section(title: String, items: [MenuItem])
        
        /// A custom view for complex menu entries
        case custom(view: AnyView)
    }
    
    /// Defines the style of the hamburger menu
    public enum MenuStyle {
        /// Default style with standard background and text color
        case `default`
        
        /// Transparent style with minimal visual emphasis
        case transparent
        
        /// Compact style with reduced spacing and smaller font
        case compact
        
        /// Custom style with specific colors and attributes
        case custom(
            backgroundColor: Color,
            textColor: Color,
            selectedItemColor: Color
        )
    }
    
    // MARK: - Private Properties
    
    private let sections: [MenuItem]
    private let style: MenuStyle
    private let showIcons: Bool
    private let allowMultipleExpanded: Bool
    
    @State private var expandedSections: Set<String> = []
    @State private var selectedItem: String?
    
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Creates a hamburger menu with the specified configuration
    /// - Parameters:
    ///   - sections: Array of menu items and sections
    ///   - style: Visual style of the menu
    ///   - showIcons: Whether to display icons for menu items
    ///   - allowMultipleExpanded: Whether multiple sections can be expanded simultaneously
    public init(
        sections: [MenuItem],
        style: MenuStyle = .default,
        showIcons: Bool = true,
        allowMultipleExpanded: Bool = false
    ) {
        self.sections = sections
        self.style = style
        self.showIcons = showIcons
        self.allowMultipleExpanded = allowMultipleExpanded
    }
    
    // MARK: - Body
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                ForEach(sections.indices, id: \.self) { index in
                    menuSectionContent(for: sections[index])
                }
            }
            .padding(CTSpacing.m)
        }
        .background(backgroundColor)
        .cornerRadius(theme.borderRadius)
    }
    
    // MARK: - Private Views
    
    private func menuSectionContent(for item: MenuItem) -> some View {
        switch item {
        case .section(let title, let items):
            return AnyView(
                VStack(alignment: .leading) {
                    sectionHeader(title: title)
                    
                    if expandedSections.contains(title) {
                        ForEach(items.indices, id: \.self) { itemIndex in
                            menuItemContent(for: items[itemIndex])
                        }
                    }
                }
            )
            
        case .item(let title, let icon, let action):
            return AnyView(
                menuItemButton(title: title, icon: icon, action: action)
            )
            
        case .custom(let view):
            return AnyView(view)
        }
    }
    
    private func menuItemContent(for item: MenuItem) -> some View {
        switch item {
        case .section(let title, let items):
            return AnyView(
                VStack(alignment: .leading) {
                    sectionHeader(title: title)
                    
                    if expandedSections.contains(title) {
                        ForEach(items.indices, id: \.self) { itemIndex in
                            menuItemContent(for: items[itemIndex])
                        }
                    }
                }
            )
            
        case .item(let title, let icon, let action):
            return AnyView(
                menuItemButton(title: title, icon: icon, action: action)
            )
            
        case .custom(let view):
            return AnyView(view)
        }
    }
    
    private func sectionHeader(title: String) -> some View {
        Button(action: {
            if allowMultipleExpanded {
                if expandedSections.contains(title) {
                    expandedSections.remove(title)
                } else {
                    expandedSections.insert(title)
                }
            } else {
                expandedSections = expandedSections.contains(title) ? [] : [title]
            }
        }) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(textColor)
                
                Spacer()
                
                Image(systemName: expandedSections.contains(title) ? "chevron.down" : "chevron.right")
                    .foregroundColor(textColor.opacity(0.6))
            }
            .padding(.vertical, CTSpacing.s)
        }
        .accessibilityLabel("Toggle \(title) section")
    }
    
    private func menuItemButton(title: String, icon: String?, action: @escaping () -> Void) -> some View {
        Button(action: {
            selectedItem = title
            action()
        }) {
            HStack(spacing: CTSpacing.s) {
                if showIcons, let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(textColor.opacity(0.8))
                        .imageScale(.medium)
                }
                
                Text(title)
                    .font(.body)
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(CTSpacing.s)
            .background(selectedItem == title ? selectedItemColor : Color.clear)
            .cornerRadius(theme.borderRadius)
        }
        .accessibilityLabel(title)
    }
    
    // MARK: - Styling Helpers
    
    private var backgroundColor: Color {
        switch style {
        case .default:
            return theme.surface
        case .transparent:
            return .clear
        case .compact:
            return theme.surface.opacity(0.8)
        case .custom(let backgroundColor, _, _):
            return backgroundColor
        }
    }
    
    private var textColor: Color {
        switch style {
        case .default, .compact:
            return theme.text
        case .transparent:
            return theme.text.opacity(0.8)
        case .custom(_, let textColor, _):
            return textColor
        }
    }
    
    private var selectedItemColor: Color {
        switch style {
        case .default, .compact:
            return theme.primary.opacity(0.1)
        case .transparent:
            return theme.primary.opacity(0.05)
        case .custom(_, _, let selectedItemColor):
            return selectedItemColor
        }
    }
}

// MARK: - Previews

struct CTHamburgerMenu_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            Group {
                Text("Default Hamburger Menu").ctHeading2()
                CTHamburgerMenu(
                    sections: [
                        .section(title: "Main", items: [
                            .item(title: "Home", icon: "house.fill", action: {}),
                            .item(title: "Profile", icon: "person.fill", action: {})
                        ]),
                        .section(title: "Settings", items: [
                            .item(title: "Preferences", icon: "gear", action: {}),
                            .item(title: "Logout", icon: "arrow.right.square", action: {})
                        ])
                    ]
                )
                
                Text("Transparent Style").ctHeading2()
                CTHamburgerMenu(
                    sections: [
                        .section(title: "Main", items: [
                            .item(title: "Dashboard", icon: "chart.bar.fill", action: {}),
                            .item(title: "Analytics", icon: "graph.circle.fill", action: {})
                        ])
                    ],
                    style: .transparent
                )
                
                Text("Compact Style").ctHeading2()
                CTHamburgerMenu(
                    sections: [
                        .section(title: "Quick Access", items: [
                            .item(title: "Search", icon: "magnifyingglass", action: {}),
                            .item(title: "Notifications", icon: "bell.fill", action: {})
                        ])
                    ],
                    style: .compact
                )
            }
        }
        .padding()
    }
}