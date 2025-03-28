//
//  CTCard.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A card component with optional header, footer, and content areas.
///
/// `CTCard` provides a container for content with a consistent card-like appearance.
/// It supports optional header and footer sections, various styles, and customization options.
///
/// # Example
///
/// ```swift
/// // Basic card with only content
/// CTCard {
///     Text("Card Content")
/// }
///
/// // Card with header and content
/// CTCard {
///     Text("Card Content")
/// } header: {
///     Text("Card Header")
/// }
///
/// // Card with header, content, and footer
/// CTCard {
///     Text("Card Content")
/// } header: {
///     Text("Card Header")
/// } footer: {
///     Text("Card Footer")
/// }
/// ```
public struct CTCard<Content: View, Header: View, Footer: View>: View {
    // MARK: - Properties
    
    /// The main content of the card
    private let content: Content
    
    /// The optional header view
    private let header: Header?
    
    /// The optional footer view
    private let footer: Footer?
    
    /// The style of the card
    private let style: CTCardStyle
    
    /// Custom padding for the card content
    private let contentPadding: EdgeInsets
    
    /// Custom padding for the card header
    private let headerPadding: EdgeInsets
    
    /// Custom padding for the card footer
    private let footerPadding: EdgeInsets
    
    /// Whether the card is interactive
    private let isInteractive: Bool
    
    /// The action to perform when the card is tapped (if interactive)
    private let action: (() -> Void)?
    
    /// The corner radius of the card
    private let cornerRadius: CGFloat
    
    /// The border width of the card
    private let borderWidth: CGFloat
    
    /// Whether the card has a shadow
    private let hasShadow: Bool
    
    /// The shadow radius when enabled
    private let shadowRadius: CGFloat
    
    /// The shadow opacity when enabled
    private let shadowOpacity: Double
    
    /// Theme access via environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Creates a card with header, content, and footer
    ///
    /// - Parameters:
    ///   - style: The style of the card
    ///   - contentPadding: Custom padding for the card content
    ///   - headerPadding: Custom padding for the card header
    ///   - footerPadding: Custom padding for the card footer
    ///   - isInteractive: Whether the card is interactive (tappable)
    ///   - action: The action to perform when the card is tapped (if interactive)
    ///   - cornerRadius: The corner radius of the card
    ///   - borderWidth: The border width of the card
    ///   - hasShadow: Whether the card has a shadow
    ///   - shadowRadius: The shadow radius when enabled
    ///   - shadowOpacity: The shadow opacity when enabled
    ///   - content: The content view builder
    ///   - header: The header view builder
    ///   - footer: The footer view builder
    public init(
        style: CTCardStyle = .elevated,
        contentPadding: EdgeInsets = CTSpacing.all(CTSpacing.m),
        headerPadding: EdgeInsets = CTSpacing.insets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.s, trailing: CTSpacing.m),
        footerPadding: EdgeInsets = CTSpacing.insets(top: CTSpacing.s, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m),
        isInteractive: Bool = false,
        action: (() -> Void)? = nil,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 0,
        hasShadow: Bool = true,
        shadowRadius: CGFloat = 4,
        shadowOpacity: Double = 0.1,
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer
    ) {
        self.content = content()
        self.header = header()
        self.footer = footer()
        self.style = style
        self.contentPadding = contentPadding
        self.headerPadding = headerPadding
        self.footerPadding = footerPadding
        self.isInteractive = isInteractive
        self.action = action
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.hasShadow = hasShadow
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
    }
    
    /// Creates a card with content and optional header
    ///
    /// - Parameters:
    ///   - style: The style of the card
    ///   - contentPadding: Custom padding for the card content
    ///   - headerPadding: Custom padding for the card header
    ///   - isInteractive: Whether the card is interactive (tappable)
    ///   - action: The action to perform when the card is tapped (if interactive)
    ///   - cornerRadius: The corner radius of the card
    ///   - borderWidth: The border width of the card
    ///   - hasShadow: Whether the card has a shadow
    ///   - content: The content view builder
    ///   - header: The header view builder
    public init(
        style: CTCardStyle = .elevated,
        contentPadding: EdgeInsets = CTSpacing.all(CTSpacing.m),
        headerPadding: EdgeInsets = CTSpacing.insets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.s, trailing: CTSpacing.m),
        isInteractive: Bool = false,
        action: (() -> Void)? = nil,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 0,
        hasShadow: Bool = true,
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header
    ) where Footer == EmptyView {
        self.content = content()
        self.header = header()
        self.footer = nil
        self.style = style
        self.contentPadding = contentPadding
        self.headerPadding = headerPadding
        self.footerPadding = CTSpacing.all(0)
        self.isInteractive = isInteractive
        self.action = action
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.hasShadow = hasShadow
        self.shadowRadius = 4
        self.shadowOpacity = 0.1
    }
    
    /// Creates a card with content only
    ///
    /// - Parameters:
    ///   - style: The style of the card
    ///   - contentPadding: Custom padding for the card content
    ///   - isInteractive: Whether the card is interactive (tappable)
    ///   - action: The action to perform when the card is tapped (if interactive)
    ///   - cornerRadius: The corner radius of the card
    ///   - borderWidth: The border width of the card
    ///   - hasShadow: Whether the card has a shadow
    ///   - content: The content view builder
    public init(
        style: CTCardStyle = .elevated,
        contentPadding: EdgeInsets = CTSpacing.all(CTSpacing.m),
        isInteractive: Bool = false,
        action: (() -> Void)? = nil,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 0,
        hasShadow: Bool = true,
        @ViewBuilder content: () -> Content
    ) where Header == EmptyView, Footer == EmptyView {
        self.content = content()
        self.header = nil
        self.footer = nil
        self.style = style
        self.contentPadding = contentPadding
        self.headerPadding = CTSpacing.all(0)
        self.footerPadding = CTSpacing.all(0)
        self.isInteractive = isInteractive
        self.action = action
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.hasShadow = hasShadow
        self.shadowRadius = 4
        self.shadowOpacity = 0.1
    }
    
    // MARK: - Body
    
    public var body: some View {
        cardContent
            .background(style.backgroundColor(for: theme))
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(style.borderColor(for: theme), lineWidth: borderWidth)
            )
            .modifier(ShadowModifier(
                hasShadow: hasShadow,
                shadowColor: theme.shadowColor,
                shadowOpacity: shadowOpacity,
                shadowRadius: shadowRadius
            ))
            .modifier(InteractiveModifier(
                isInteractive: isInteractive,
                action: performAction,
                style: style
            ))
    }
    
    // MARK: - Private Views
    
    /// The main card content layout
    private var cardContent: some View {
        VStack(spacing: 0) {
            if let header = header {
                VStack(spacing: 0) {
                    header
                        .padding(headerPadding)
                }
            }
            
            content
                .padding(contentPadding)
            
            if let footer = footer {
                VStack(spacing: 0) {
                    footer
                        .padding(footerPadding)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Perform the card's action if it exists
    private func performAction() {
        action?()
    }
}

// MARK: - Supporting Types

/// Style options for the Card component
public enum CTCardStyle: Hashable {
    /// An elevated card with shadow
    case elevated
    
    /// A flat card with border
    case flat
    
    /// An outlined card with custom border
    case outlined
    
    /// A filled card with background color
    case filled
    
    /// A custom style with specified parameters
    case custom(backgroundColor: Color, borderColor: Color)
    
    /// Get the background color for this style
    /// - Parameter theme: The current theme
    /// - Returns: The background color
    func backgroundColor(for theme: CTTheme) -> Color {
        switch self {
        case .elevated, .flat, .outlined:
            return theme.surface
        case .filled:
            return theme.background
        case .custom(let backgroundColor, _):
            return backgroundColor
        }
    }
    
    /// Get the border color for this style
    /// - Parameter theme: The current theme
    /// - Returns: The border color
    func borderColor(for theme: CTTheme) -> Color {
        switch self {
        case .elevated, .filled:
            return Color.clear
        case .flat, .outlined:
            return theme.border
        case .custom(_, let borderColor):
            return borderColor
        }
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .elevated:
            hasher.combine(0)
        case .flat:
            hasher.combine(1)
        case .outlined:
            hasher.combine(2)
        case .filled:
            hasher.combine(3)
        case .custom(let backgroundColor, let borderColor):
            hasher.combine(4)
            hasher.combine(backgroundColor)
            hasher.combine(borderColor)
        }
    }
    
    public static func == (lhs: CTCardStyle, rhs: CTCardStyle) -> Bool {
        switch (lhs, rhs) {
        case (.elevated, .elevated),
             (.flat, .flat),
             (.outlined, .outlined),
             (.filled, .filled):
            return true
        case (.custom(let lhsBackground, let lhsBorder), .custom(let rhsBackground, let rhsBorder)):
            return lhsBackground == rhsBackground && lhsBorder == rhsBorder
        default:
            return false
        }
    }
}

// MARK: - Button Style

/// A button style for interactive cards
private struct CTCardButtonStyle: SwiftUI.ButtonStyle {
    func makeBody(configuration: SwiftUI.ButtonStyle.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Previews

struct CTCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Basic card with content only
                CTCard {
                    Text("Basic Card")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                }
                
                // Card with header and content
                CTCard {
                    Text("Card with Header")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                } header: {
                    Text("Header")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Card with header, content, and footer
                CTCard {
                    Text("Card with Header and Footer")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                } header: {
                    Text("Header")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                } footer: {
                    Text("Footer")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                // Interactive card
                CTCard(isInteractive: true, action: {
                    print("Card tapped")
                }) {
                    Text("Interactive Card (Tap me)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                }
                
                // Different card styles
                Group {
                    CTCard(style: .elevated) {
                        Text("Elevated Card")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical)
                    }
                    
                    CTCard(style: .flat, borderWidth: 1) {
                        Text("Flat Card")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical)
                    }
                    
                    CTCard(style: .outlined, borderWidth: 1) {
                        Text("Outlined Card")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical)
                    }
                    
                    CTCard(style: .filled) {
                        Text("Filled Card")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical)
                    }
                    
                    CTCard(style: .custom(backgroundColor: Color.blue.opacity(0.1), borderColor: Color.blue), borderWidth: 1) {
                        Text("Custom Card")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical)
                    }
                }
            }
            .padding()
        }
    }
}

/// A view modifier that conditionally applies a shadow
private struct ShadowModifier: ViewModifier {
    let hasShadow: Bool
    let shadowColor: Color
    let shadowOpacity: Double
    let shadowRadius: CGFloat
    
    func body(content: Content) -> some View {
        if hasShadow {
            content.shadow(
                color: shadowColor.opacity(shadowOpacity),
                radius: shadowRadius,
                x: 0,
                y: 2
            )
        } else {
            content
        }
    }
}

/// A view modifier that conditionally makes a view interactive
private struct InteractiveModifier: ViewModifier {
    let isInteractive: Bool
    let action: () -> Void
    let style: CTCardStyle
    
    func body(content: Content) -> some View {
        if isInteractive {
            Button(action: action) {
                content
            }
            .ctButton()
        } else {
            content
        }
    }
}