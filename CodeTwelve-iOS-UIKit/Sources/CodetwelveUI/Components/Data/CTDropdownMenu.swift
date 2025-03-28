//
//  CTDropdownMenu.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable dropdown menu component for displaying options.
///
/// `CTDropdownMenu` provides a consistent dropdown menu interface throughout your application
/// with support for different styles, positioning, and item configurations.
///
/// # Example
///
/// ```swift
/// // Basic dropdown menu
/// @State private var isMenuOpen = false
///
/// Button("Open Menu") {
///     isMenuOpen.toggle()
/// }
/// .ctDropdownMenu(isPresented: $isMenuOpen) {
///     CTDropdownMenuItem(label: "Option 1") {
///         print("Option 1 selected")
///     }
///     
///     CTDropdownMenuItem(label: "Option 2") {
///         print("Option 2 selected")
///     }
///     
///     CTDropdownMenuItem.divider()
///     
///     CTDropdownMenuItem(label: "Delete", icon: "trash", style: .destructive) {
///         print("Delete selected")
///     }
/// }
/// ```

// First, define the environment keys at file scope
private struct DismissOnSelectionKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

private struct DismissActionKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

// Add environment values extension at file scope
extension EnvironmentValues {
    var ctDropdownDismissOnSelection: Bool {
        get { self[DismissOnSelectionKey.self] }
        set { self[DismissOnSelectionKey.self] = newValue }
    }
    
    var ctDropdownDismissAction: () -> Void {
        get { self[DismissActionKey.self] }
        set { self[DismissActionKey.self] = newValue }
    }
}

// First, make CTDropdownMenu conform to ViewModifier instead of View
public struct CTDropdownMenu<MenuContent: View>: ViewModifier {
    // MARK: - Public Properties
    
    /// The style of the dropdown menu
    public enum Style {
        /// Default style with a subtle shadow and border
        case `default`
        
        /// Solid style with a more pronounced background and border
        case solid
        
        /// Minimal style with reduced visual elements
        case minimal
        
        /// Custom style with specific parameters
        case custom(
            backgroundColor: Color,
            borderColor: Color,
            shadowRadius: CGFloat,
            cornerRadius: CGFloat
        )
    }
    
    /// The position of the dropdown menu relative to the anchor view
    public enum Position {
        /// Below the anchor view, aligned to the leading edge
        case bottomLeading
        
        /// Below the anchor view, aligned to the trailing edge
        case bottomTrailing
        
        /// Below the anchor view, centered
        case bottomCenter
        
        /// Above the anchor view, aligned to the leading edge
        case topLeading
        
        /// Above the anchor view, aligned to the trailing edge
        case topTrailing
        
        /// Above the anchor view, centered
        case topCenter
        
        /// To the leading side of the anchor view, aligned to the top
        case leadingTop
        
        /// To the leading side of the anchor view, aligned to the bottom
        case leadingBottom
        
        /// To the trailing side of the anchor view, aligned to the top
        case trailingTop
        
        /// To the trailing side of the anchor view, aligned to the bottom
        case trailingBottom
    }
    
    // MARK: - Private Properties
    
    /// Binding to control whether the dropdown menu is presented
    @Binding private var isPresented: Bool
    
    /// The position of the dropdown menu
    private let position: Position
    
    /// The style of the dropdown menu
    private let style: Style
    
    /// The width of the dropdown menu (nil for automatic)
    private let width: CGFloat?
    
    /// The maximum height of the dropdown menu (nil for automatic)
    private let maxHeight: CGFloat?
    
    /// Offset from the anchor view
    private let offset: CGPoint
    
    /// Whether to dismiss the menu when an item is selected
    private let dismissOnSelection: Bool
    
    /// Whether to dismiss the menu when tapping outside
    private let dismissOnOutsideTap: Bool
    
    /// The content of the dropdown menu
    private let menuContent: MenuContent
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    @State private var isExpanded: Bool = false
    @Environment(\.ctDropdownDismissOnSelection) private var dismissOnSelectionEnvironment
    @Environment(\.ctDropdownDismissAction) private var dismissActionEnvironment
    
    // MARK: - Initializers
    
    /// Initialize a new dropdown menu
    /// - Parameters:
    ///   - isPresented: Binding to control whether the dropdown menu is presented
    ///   - position: The position of the dropdown menu relative to the anchor view
    ///   - style: The style of the dropdown menu
    ///   - width: The width of the dropdown menu (nil for automatic)
    ///   - maxHeight: The maximum height of the dropdown menu (nil for automatic)
    ///   - offset: Offset from the anchor view
    ///   - dismissOnSelection: Whether to dismiss the menu when an item is selected
    ///   - dismissOnOutsideTap: Whether to dismiss the menu when tapping outside
    ///   - content: The content of the dropdown menu
    public init(
        isPresented: Binding<Bool>,
        position: Position = .bottomLeading,
        style: Style = .default,
        width: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        offset: CGPoint = CGPoint(x: 0, y: 0),
        dismissOnSelection: Bool = true,
        dismissOnOutsideTap: Bool = true,
        @ViewBuilder content: () -> MenuContent
    ) {
        self._isPresented = isPresented
        self.position = position
        self.style = style
        self.width = width
        self.maxHeight = maxHeight
        self.offset = offset
        self.dismissOnSelection = dismissOnSelection
        self.dismissOnOutsideTap = dismissOnOutsideTap
        self.menuContent = content()
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            content
                .overlay(
                    GeometryReader { geometry in
                        ZStack {
                            if isPresented {
                                // Invisible background for outside tap detection
                                if dismissOnOutsideTap {
                                    Color.clear
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            isPresented = false
                                        }
                                        .ignoresSafeArea()
                                }
                                
                                // The actual dropdown menu
                                dropdownContent
                                    .position(
                                        calculatePosition(
                                            in: geometry,
                                            anchorFrame: geometry.frame(in: .global)
                                        )
                                    )
                                    .transition(.scale(scale: 0.95).combined(with: .opacity))
                                    .ctAnimation(CTAnimation.easeInOut, value: isPresented)
                            }
                        }
                    }
                )
        }
        .environment(\.ctDropdownDismissOnSelection, dismissOnSelectionEnvironment)
        .environment(\.ctDropdownDismissAction, dismissActionEnvironment)
    }
    
    // MARK: - Private Views and Helpers
    
    /// The content of the dropdown menu
    private var dropdownContent: some View {
        CTDropdownMenuContext {
            menuContent
        }
        .padding(CTSpacing.s)
        .frame(width: width)
        .frame(maxHeight: maxHeight)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .shadow(
            color: shadowColor.opacity(shadowOpacity),
            radius: shadowRadius,
            x: shadowOffset.width,
            y: shadowOffset.height
        )
    }
    
    /// Calculate the position of the dropdown menu based on the anchor frame
    /// - Parameters:
    ///   - geometry: The geometry proxy
    ///   - anchorFrame: The frame of the anchor view
    /// - Returns: The position of the dropdown menu
    private func calculatePosition(in geometry: GeometryProxy, anchorFrame: CGRect) -> CGPoint {
        let menuWidth = width ?? 200
        let menuHeight = min(maxHeight ?? 300, geometry.size.height * 0.7)
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        switch position {
        case .bottomLeading:
            x = anchorFrame.minX + offset.x
            y = anchorFrame.maxY + menuHeight / 2 + offset.y
        case .bottomTrailing:
            x = anchorFrame.maxX - menuWidth + offset.x
            y = anchorFrame.maxY + menuHeight / 2 + offset.y
        case .bottomCenter:
            x = anchorFrame.midX - menuWidth / 2 + offset.x
            y = anchorFrame.maxY + menuHeight / 2 + offset.y
        case .topLeading:
            x = anchorFrame.minX + offset.x
            y = anchorFrame.minY - menuHeight / 2 + offset.y
        case .topTrailing:
            x = anchorFrame.maxX - menuWidth + offset.x
            y = anchorFrame.minY - menuHeight / 2 + offset.y
        case .topCenter:
            x = anchorFrame.midX - menuWidth / 2 + offset.x
            y = anchorFrame.minY - menuHeight / 2 + offset.y
        case .leadingTop:
            x = anchorFrame.minX - menuWidth / 2 + offset.x
            y = anchorFrame.minY + menuHeight / 2 + offset.y
        case .leadingBottom:
            x = anchorFrame.minX - menuWidth / 2 + offset.x
            y = anchorFrame.maxY - menuHeight / 2 + offset.y
        case .trailingTop:
            x = anchorFrame.maxX + menuWidth / 2 + offset.x
            y = anchorFrame.minY + menuHeight / 2 + offset.y
        case .trailingBottom:
            x = anchorFrame.maxX + menuWidth / 2 + offset.x
            y = anchorFrame.maxY - menuHeight / 2 + offset.y
        }
        
        // Ensure the menu stays within the screen bounds
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // Adjust horizontal position to keep within screen bounds
        if x - menuWidth / 2 < 0 {
            x = menuWidth / 2
        } else if x + menuWidth / 2 > screenWidth {
            x = screenWidth - menuWidth / 2
        }
        
        // Adjust vertical position to keep within screen bounds
        if y - menuHeight / 2 < 0 {
            y = menuHeight / 2
        } else if y + menuHeight / 2 > screenHeight {
            y = screenHeight - menuHeight / 2
        }
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - Style Properties
    
    /// The background color of the dropdown menu
    private var backgroundColor: Color {
        switch style {
        case .default:
            return theme.surface
        case .solid:
            return theme.background
        case .minimal:
            return theme.surface.opacity(0.95)
        case .custom(let backgroundColor, _, _, _):
            return backgroundColor
        }
    }
    
    /// The border color of the dropdown menu
    private var borderColor: Color {
        switch style {
        case .default:
            return theme.border
        case .solid:
            return theme.border.opacity(0.7)
        case .minimal:
            return .clear
        case .custom(_, let borderColor, _, _):
            return borderColor
        }
    }
    
    /// The border width of the dropdown menu
    private var borderWidth: CGFloat {
        switch style {
        case .default, .solid:
            return theme.borderWidth
        case .minimal:
            return 0
        case .custom:
            return theme.borderWidth
        }
    }
    
    /// The corner radius of the dropdown menu
    private var cornerRadius: CGFloat {
        switch style {
        case .default, .solid, .minimal:
            return theme.borderRadius
        case .custom(_, _, _, let cornerRadius):
            return cornerRadius
        }
    }
    
    /// The shadow color of the dropdown menu
    private var shadowColor: Color {
        return theme.shadowColor
    }
    
    /// The shadow opacity of the dropdown menu
    private var shadowOpacity: Double {
        switch style {
        case .default:
            return theme.shadowOpacity
        case .solid:
            return theme.shadowOpacity * 1.5
        case .minimal:
            return theme.shadowOpacity * 0.5
        case .custom:
            return theme.shadowOpacity
        }
    }
    
    /// The shadow radius of the dropdown menu
    private var shadowRadius: CGFloat {
        switch style {
        case .default:
            return theme.shadowRadius
        case .solid:
            return theme.shadowRadius * 1.5
        case .minimal:
            return theme.shadowRadius * 0.5
        case .custom(_, _, let shadowRadius, _):
            return shadowRadius
        }
    }
    
    /// The shadow offset of the dropdown menu
    private var shadowOffset: CGSize {
        return theme.shadowOffset
    }
}

// Fix the CTDropdownMenuContext
struct CTDropdownMenuContext<Content: View>: View {
    let content: () -> Content  // Change to closure type
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()  // Call the closure
    }
}

/// A menu item for the dropdown menu
public struct CTDropdownMenuItem: View {
    // MARK: - Public Properties
    
    /// The style of the menu item
    public enum Style {
        /// Default style
        case `default`
        
        /// Highlighted style (for selected or active items)
        case highlighted
        
        /// Destructive style (for delete or dangerous actions)
        case destructive
        
        /// Disabled style
        case disabled
        
        /// Custom style with specific colors
        case custom(textColor: Color, iconColor: Color, backgroundColor: Color?)
    }
    
    // MARK: - Private Properties
    
    /// The label for the menu item
    private let label: String
    
    /// The icon for the menu item (optional)
    private let icon: String?
    
    /// The trailing icon for the menu item (optional)
    private let trailingIcon: String?
    
    /// The style of the menu item
    private let style: Style
    
    /// Whether the menu item is disabled
    private let isDisabled: Bool
    
    /// Whether this is a divider item
    private let isDivider: Bool
    
    /// The action to perform when the menu item is selected
    private let action: (() -> Void)?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    /// Whether to dismiss the menu when an item is selected
    @Environment(\.ctDropdownDismissOnSelection) private var dismissOnSelection
    
    /// Action to dismiss the dropdown menu
    @Environment(\.ctDropdownDismissAction) private var dismissAction
    
    /// The padding for the menu item
    private let itemPadding = EdgeInsets(
        top: CTSpacing.xs,
        leading: CTSpacing.s,
        bottom: CTSpacing.xs,
        trailing: CTSpacing.s
    )
    
    // MARK: - Initializers
    
    /// Initialize a new menu item
    /// - Parameters:
    ///   - label: The label for the menu item
    ///   - icon: The icon for the menu item (optional)
    ///   - trailingIcon: The trailing icon for the menu item (optional)
    ///   - style: The style of the menu item
    ///   - isDisabled: Whether the menu item is disabled
    ///   - action: The action to perform when the menu item is selected
    public init(
        label: String,
        icon: String? = nil,
        trailingIcon: String? = nil,
        style: Style = .default,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.trailingIcon = trailingIcon
        self.style = style
        self.isDisabled = isDisabled
        self.action = action
        self.isDivider = false
    }
    
    /// Private initializer for divider items
    private init(isDivider: Bool) {
        self.label = ""
        self.icon = nil
        self.trailingIcon = nil
        self.style = .default
        self.isDisabled = true
        self.action = nil
        self.isDivider = isDivider
    }
    
    /// Create a divider item
    /// - Returns: A divider menu item
    public static func divider() -> CTDropdownMenuItem {
        return CTDropdownMenuItem(isDivider: true)
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if isDivider {
                Divider()
                    .padding(.vertical, CTSpacing.xs)
            } else {
                Button(action: {
                    if !isDisabled {
                        action?()  // Keep optional chaining for action
                        if dismissOnSelection {
                            dismissAction()  // Remove optional chaining
                        }
                    }
                }) {
                    HStack {
                        // Leading icon (if present)
                        if let icon = icon {
                            Image(systemName: icon)
                                .foregroundColor(iconColor)
                                .font(.system(size: 14))
                                .frame(width: 20)
                        }
                        
                        // Label
                        Text(label)
                            .ctBody()
                            .foregroundColor(textColor)
                        
                        Spacer()
                        
                        // Trailing icon (if present)
                        if let trailingIcon = trailingIcon {
                            Image(systemName: trailingIcon)
                                .foregroundColor(iconColor)
                                .font(.system(size: 14))
                        }
                    }
                    .padding(itemPadding)
                    .background(backgroundColor)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(isDisabled)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    // MARK: - Private Properties
    
    /// The text color for the menu item
    private var textColor: Color {
        switch style {
        case .default:
            return theme.text
        case .highlighted:
            return theme.primary
        case .destructive:
            return theme.destructive
        case .disabled:
            return theme.textSecondary.opacity(0.6)
        case .custom(let textColor, _, _):
            return textColor
        }
    }
    
    /// The icon color for the menu item
    private var iconColor: Color {
        switch style {
        case .default:
            return theme.textSecondary
        case .highlighted:
            return theme.primary
        case .destructive:
            return theme.destructive
        case .disabled:
            return theme.textSecondary.opacity(0.6)
        case .custom(_, let iconColor, _):
            return iconColor
        }
    }
    
    /// The background color for the menu item
    private var backgroundColor: Color? {
        switch style {
        case .default, .destructive, .disabled:
            return nil // Transparent
        case .highlighted:
            return theme.primary.opacity(0.1)
        case .custom(_, _, let backgroundColor):
            return backgroundColor
        }
    }
    
    /// The accessibility label for the menu item
    private var accessibilityLabel: String {
        if isDivider {
            return "Divider"
        } else if isDisabled {
            return "\(label), Disabled"
        } else {
            return label
        }
    }
}

// MARK: - View Extensions

public extension View {
    /// Apply a dropdown menu to a view
    ///
    /// This modifier adds a dropdown menu that can be presented when the binding is true.
    ///
    /// # Example
    ///
    /// ```swift
    /// @State private var isMenuOpen = false
    ///
    /// Button("Open Menu") {
    ///     isMenuOpen.toggle()
    /// }
    /// .ctDropdownMenu(isPresented: $isMenuOpen) {
    ///     CTDropdownMenuItem(label: "Option 1") {
    ///         print("Option 1 selected")
    ///     }
    ///     
    ///     CTDropdownMenuItem(label: "Option 2") {
    ///         print("Option 2 selected")
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control whether the dropdown menu is presented
    ///   - position: The position of the dropdown menu
    ///   - style: The style of the dropdown menu
    ///   - width: The width of the dropdown menu (nil for automatic)
    ///   - maxHeight: The maximum height of the dropdown menu (nil for automatic)
    ///   - offset: Offset from the anchor view
    ///   - dismissOnSelection: Whether to dismiss the menu when an item is selected
    ///   - dismissOnOutsideTap: Whether to dismiss the menu when tapping outside
    ///   - content: The content of the dropdown menu
    /// - Returns: The view with the dropdown menu modifier applied
    func ctDropdownMenu<MenuContent: View>(
        isPresented: Binding<Bool>,
        position: CTDropdownMenu<MenuContent>.Position = .bottomLeading,
        style: CTDropdownMenu<MenuContent>.Style = .default,
        width: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        offset: CGPoint = CGPoint(x: 0, y: 0),
        dismissOnSelection: Bool = true,
        dismissOnOutsideTap: Bool = true,
        @ViewBuilder content: @escaping () -> MenuContent
    ) -> some View {
        modifier(
            CTDropdownMenu(
                isPresented: isPresented,
                position: position,
                style: style,
                width: width,
                maxHeight: maxHeight,
                offset: offset,
                dismissOnSelection: dismissOnSelection,
                dismissOnOutsideTap: dismissOnOutsideTap,
                content: content
            )
        )
    }
    
    // Remove redundant public modifiers
    func ctDropdownDismissOnSelection(_ dismiss: Bool) -> some View {
        environment(\.ctDropdownDismissOnSelection, dismiss)
    }
    
    func ctDropdownDismissAction(_ action: @escaping () -> Void) -> some View {
        environment(\.ctDropdownDismissAction, action)
    }
}

// MARK: - Previews

struct CTDropdownMenu_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        VStack {
            Text("Trigger")
                .ctDropdownMenu(
                    isPresented: .constant(true),  // Add required parameter
                    content: {
                        Text("Dropdown Content")
                    }
                )
                .ctDropdownDismissOnSelection(true)
                .ctDropdownDismissAction {
                    print("Dismissed")
                }
        }
    }
}