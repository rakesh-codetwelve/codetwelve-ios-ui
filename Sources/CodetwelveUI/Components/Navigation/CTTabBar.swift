//
//  CTTabBar.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable tab bar component for navigation within an application.
///
/// `CTTabBar` provides a consistent tab bar interface for navigation with support
/// for different styles, icons, labels, and indicators.
///
/// # Example
///
/// ```swift
/// struct ContentView: View {
///     @State private var selectedTab = 0
///
///     var body: some View {
///         VStack {
///             // Content view based on selectedTab
///             if selectedTab == 0 {
///                 Text("Home View")
///             } else if selectedTab == 1 {
///                 Text("Search View")
///             } else {
///                 Text("Profile View")
///             }
///
///             Spacer()
///
///             // Tab bar at the bottom
///             CTTabBar(
///                 selectedTab: $selectedTab,
///                 tabs: [
///                     CTTabItem(label: "Home", icon: "house"),
///                     CTTabItem(label: "Search", icon: "magnifyingglass"),
///                     CTTabItem(label: "Profile", icon: "person")
///                 ]
///             )
///         }
///     }
/// }
/// ```
public struct CTTabBar: View {
    // MARK: - Public Properties
    
    /// Binding to the selected tab index
    @Binding private var selectedTab: Int
    
    /// Array of tab items to display
    private let tabs: [CTTabItem]
    
    /// Style of the tab bar
    private let style: CTTabBarStyle
    
    /// Whether to show labels for the tabs
    private let showLabels: Bool
    
    /// Alignment of the tab items
    private let alignment: CTTabBarAlignment
    
    /// Whether to add a safe area inset at the bottom
    private let addBottomSafeArea: Bool
    
    /// Whether to show badges on tabs
    private let showBadges: Bool
    
    /// The background style of the tab bar
    private let backgroundStyle: CTTabBarBackgroundStyle
    
    /// Action to perform when a tab is selected
    private let onTabSelected: ((Int) -> Void)?
    
    // MARK: - Environment Properties
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - State Properties
    
    /// Animation state for tab selection
    @State private var animatedSelectedTab: CGFloat
    
    // MARK: - Initializers
    
    /// Initialize a new tab bar with the specified tabs and configuration
    ///
    /// - Parameters:
    ///   - selectedTab: Binding to the selected tab index
    ///   - tabs: Array of tab items to display
    ///   - style: Style of the tab bar
    ///   - showLabels: Whether to show labels for the tabs
    ///   - alignment: Alignment of the tab items
    ///   - addBottomSafeArea: Whether to add a safe area inset at the bottom
    ///   - showBadges: Whether to show badges on tabs
    ///   - backgroundStyle: The background style of the tab bar
    ///   - onTabSelected: Action to perform when a tab is selected
    public init(
        selectedTab: Binding<Int>,
        tabs: [CTTabItem],
        style: CTTabBarStyle = .default,
        showLabels: Bool = true,
        alignment: CTTabBarAlignment = .spaceEvenly,
        addBottomSafeArea: Bool = true,
        showBadges: Bool = true,
        backgroundStyle: CTTabBarBackgroundStyle = .standard,
        onTabSelected: ((Int) -> Void)? = nil
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.style = style
        self.showLabels = showLabels
        self.alignment = alignment
        self.addBottomSafeArea = addBottomSafeArea
        self.showBadges = showBadges
        self.backgroundStyle = backgroundStyle
        self.onTabSelected = onTabSelected
        
        // Initialize the animated tab position
        self._animatedSelectedTab = State(initialValue: CGFloat(selectedTab.wrappedValue))
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            // Tab bar content
            HStack(spacing: 0) {
                // Create tabs based on alignment
                switch alignment {
                case .spaceEvenly:
                    Spacer()
                    ForEach(0..<tabs.count, id: \.self) { index in
                        createTabButton(for: index)
                        Spacer()
                    }
                case .distributed:
                    ForEach(0..<tabs.count, id: \.self) { index in
                        createTabButton(for: index)
                            .frame(maxWidth: .infinity)
                    }
                case .leading:
                    ForEach(0..<tabs.count, id: \.self) { index in
                        createTabButton(for: index)
                    }
                    Spacer()
                case .trailing:
                    Spacer()
                    ForEach(0..<tabs.count, id: \.self) { index in
                        createTabButton(for: index)
                    }
                }
            }
            .padding(.vertical, CTSpacing.s)
            .frame(height: tabBarHeight)
            .background(backgroundView)
            .overlay(
                // Show indicator based on style
                ZStack {
                    if style == .indicator {
                        GeometryReader { geometry in
                            let tabWidth = geometry.size.width / CGFloat(tabs.count)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(theme.primary)
                                .frame(width: tabWidth / 2, height: 4)
                                .offset(
                                    x: tabWidth * animatedSelectedTab + tabWidth / 4,
                                    y: -2
                                )
                                .ctAnimation(
                                    Animation.spring(response: 0.3, dampingFraction: 0.7),
                                    value: animatedSelectedTab
                                )
                        }
                        .frame(height: 4)
                        .offset(y: -CTSpacing.s / 2)
                    }
                }
            )
            
            // Add safe area inset if needed
            if addBottomSafeArea {
                Spacer()
                    .frame(height: bottomSafeAreaInset)
                    .background(backgroundView)
            }
        }
        .onChange(of: selectedTab) { newValue in
            withAnimation {
                animatedSelectedTab = CGFloat(newValue)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Create a tab button for the specified index
    ///
    /// - Parameter index: The index of the tab
    /// - Returns: A view containing the tab button
    @ViewBuilder
    private func createTabButton(for index: Int) -> some View {
        let tab = tabs[index]
        let isSelected = selectedTab == index
        
        Button(action: {
            selectedTab = index
            onTabSelected?(index)
            
            // Add haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            VStack(spacing: CTSpacing.xxs) {
                ZStack {
                    if let icon = tab.icon {
                        Image(systemName: icon)
                            .imageScale(showLabels ? .medium : .large)
                            .foregroundColor(isSelected ? iconColor(isSelected) : iconColor(isSelected))
                            .ctAnimation(.easeInOut, value: isSelected)
                    }
                    
                    // Show badge if needed
                    if showBadges && tab.badgeCount > 0 {
                        ZStack {
                            Circle()
                                .fill(theme.destructive)
                                .frame(width: badgeSize, height: badgeSize)
                            
                            if tab.badgeCount < 100 {
                                Text("\(tab.badgeCount)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("99+")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .offset(x: 10, y: -10)
                    }
                }
                
                if showLabels {
                    Text(tab.label)
                        .font(.system(size: 12, weight: isSelected ? .medium : .regular))
                        .foregroundColor(isSelected ? labelColor(isSelected) : labelColor(isSelected))
                        .ctAnimation(.easeInOut, value: isSelected)
                }
            }
            .frame(height: tabBarHeight - CTSpacing.s * 2)
            .padding(.horizontal, CTSpacing.xs)
            .background(
                Group {
                    if isSelected && style == .filled {
                        RoundedRectangle(cornerRadius: theme.borderRadius)
                            .fill(theme.primary.opacity(0.1))
                            .ctAnimation(.easeInOut, value: isSelected)
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(tab.label)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint("Tab \(index + 1) of \(tabs.count)")
    }
    
    // MARK: - Private Properties
    
    /// The background view for the tab bar
    @ViewBuilder
    private var backgroundView: some View {
        switch backgroundStyle {
        case .standard:
            RoundedRectangle(cornerRadius: 0)
                .fill(theme.surface)
                .shadow(color: theme.shadowColor.opacity(0.1), radius: 5, x: 0, y: -2)
        case .solid(let color):
            RoundedRectangle(cornerRadius: 0)
                .fill(color)
        case .blur:
            BlurredBackground()
        case .invisible:
            Color.clear
        }
    }
    
    /// The icon color based on selection state
    private func iconColor(_ isSelected: Bool) -> Color {
        return isSelected ? theme.primary : theme.textSecondary
    }
    
    /// The label color based on selection state
    private func labelColor(_ isSelected: Bool) -> Color {
        return isSelected ? theme.primary : theme.textSecondary
    }
    
    /// The height of the tab bar (excluding safe area inset)
    private var tabBarHeight: CGFloat {
        return 50
    }
    
    /// The size of the badge indicator
    private var badgeSize: CGFloat {
        return 16
    }
    
    /// The bottom safe area inset
    private var bottomSafeAreaInset: CGFloat {
        return CTLayoutUtilities.bottomSafeAreaInset
    }
}

// MARK: - Supporting Types

/// Represents a single item in the tab bar
public struct CTTabItem {
    /// The label text for the tab
    public let label: String
    
    /// The SF Symbol name for the tab's icon
    public let icon: String?
    
    /// The badge count to display on the tab (0 for no badge)
    public let badgeCount: Int
    
    /// Initialize a new tab item
    ///
    /// - Parameters:
    ///   - label: The label text for the tab
    ///   - icon: The SF Symbol name for the tab's icon
    ///   - badgeCount: The badge count to display on the tab (0 for no badge)
    public init(label: String, icon: String? = nil, badgeCount: Int = 0) {
        self.label = label
        self.icon = icon
        self.badgeCount = badgeCount
    }
}

/// The style of the tab bar
public enum CTTabBarStyle {
    /// Default tab bar style with colored icons and labels
    case `default`
    
    /// Tab bar with a background indicator for the selected tab
    case filled
    
    /// Tab bar with a sliding indicator below the selected tab
    case indicator
}

/// The alignment of the tabs within the tab bar
public enum CTTabBarAlignment {
    /// Tabs are evenly spaced with space between them
    case spaceEvenly
    
    /// Tabs are distributed to fill the entire width
    case distributed
    
    /// Tabs are aligned to the leading edge
    case leading
    
    /// Tabs are aligned to the trailing edge
    case trailing
}

/// The background style of the tab bar
public enum CTTabBarBackgroundStyle: Hashable {
    /// Standard background with a subtle shadow
    case standard
    
    /// Solid color background
    case solid(Color)
    
    /// Blurred background (translucent)
    case blur
    
    /// Invisible background (transparent)
    case invisible
}

/// A blurred background view
private struct BlurredBackground: View {
    var body: some View {
        ZStack {
            Color.white.opacity(0.2)
            
            Rectangle()
                .fill(.ultraThinMaterial)
        }
    }
}

// MARK: - Previews

struct CTTabBar_Previews: PreviewProvider {
    struct TabBarPreview: View {
        @State private var selectedTab: Int = 0
        let style: CTTabBarStyle
        let showLabels: Bool
        let alignment: CTTabBarAlignment
        
        var body: some View {
            VStack {
                Spacer()
                
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: [
                        CTTabItem(label: "Home", icon: "house", badgeCount: 0),
                        CTTabItem(label: "Search", icon: "magnifyingglass", badgeCount: 5),
                        CTTabItem(label: "Favorites", icon: "heart", badgeCount: 0),
                        CTTabItem(label: "Profile", icon: "person", badgeCount: 2)
                    ],
                    style: style,
                    showLabels: showLabels,
                    alignment: alignment
                )
            }
        }
    }
    
    static var previews: some View {
        Group {
            TabBarPreview(
                style: .default,
                showLabels: true,
                alignment: .spaceEvenly
            )
            .previewDisplayName("Default Style")
            
            TabBarPreview(
                style: .filled,
                showLabels: true,
                alignment: .spaceEvenly
            )
            .previewDisplayName("Filled Style")
            
            TabBarPreview(
                style: .indicator,
                showLabels: true,
                alignment: .spaceEvenly
            )
            .previewDisplayName("Indicator Style")
            
            TabBarPreview(
                style: .default,
                showLabels: false,
                alignment: .spaceEvenly
            )
            .previewDisplayName("Icons Only")
            
            TabBarPreview(
                style: .default,
                showLabels: true,
                alignment: .distributed
            )
            .previewDisplayName("Distributed Alignment")
            
            TabBarPreview(
                style: .default,
                showLabels: true,
                alignment: .leading
            )
            .previewDisplayName("Leading Alignment")
            
            TabBarPreview(
                style: .default,
                showLabels: true,
                alignment: .trailing
            )
            .previewDisplayName("Trailing Alignment")
        }
    }
}