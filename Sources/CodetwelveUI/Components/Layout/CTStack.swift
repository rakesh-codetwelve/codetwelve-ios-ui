//
//  CTStack.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable stack component that enhances SwiftUI's VStack and HStack.
///
/// `CTStack` provides a consistent stack interface throughout your application
/// with support for different orientations, spacing, alignment, and conditional content.
///
/// # Example
///
/// ```swift
/// // Vertical stack with standard medium spacing
/// CTStack {
///     Text("Item 1")
///     Text("Item 2")
///     Text("Item 3")
/// }
///
/// // Horizontal stack with custom spacing
/// CTStack(orientation: .horizontal, spacing: CTSpacing.l) {
///     Text("Item 1")
///     Text("Item 2")
/// }
///
/// // Stack with dividers between items
/// CTStack(showDividers: true) {
///     Text("Section 1")
///     Text("Section 2")
/// }
/// ```
public struct CTStack<Content: View>: View {
    // MARK: - Public Properties
    
    /// The orientation of the stack
    public enum Orientation {
        /// Vertical stack (like VStack)
        case vertical
        /// Horizontal stack (like HStack)
        case horizontal
    }
    
    // MARK: - Private Properties
    
    private let orientation: Orientation
    private let spacing: CGFloat?
    private let alignment: Alignment
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let showDividers: Bool
    private let dividerColor: Color?
    private let dividerThickness: CGFloat
    private let content: Content
    
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new stack with a specific orientation
    /// - Parameters:
    ///   - orientation: The orientation of the stack (default: .vertical)
    ///   - spacing: The spacing between items, nil for default spacing (default: nil)
    ///   - alignment: The alignment of the stack (default: .center)
    ///   - showDividers: Whether to show dividers between items (default: false)
    ///   - dividerColor: The color of the dividers (default: theme's border color)
    ///   - dividerThickness: The thickness of the dividers (default: 1)
    ///   - content: The content of the stack
    public init(
        orientation: Orientation = .vertical,
        spacing: CGFloat? = nil,
        alignment: Alignment = .center,
        showDividers: Bool = false,
        dividerColor: Color? = nil,
        dividerThickness: CGFloat = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.orientation = orientation
        self.spacing = spacing
        self.alignment = alignment
        self.horizontalAlignment = .center
        self.verticalAlignment = .center
        self.showDividers = showDividers
        self.dividerColor = dividerColor
        self.dividerThickness = dividerThickness
        self.content = content()
    }
    
    /// Initialize a new vertical stack
    /// - Parameters:
    ///   - spacing: The spacing between items, nil for default spacing (default: nil)
    ///   - alignment: The horizontal alignment of the stack (default: .center)
    ///   - showDividers: Whether to show dividers between items (default: false)
    ///   - dividerColor: The color of the dividers (default: theme's border color)
    ///   - dividerThickness: The thickness of the dividers (default: 1)
    ///   - content: The content of the stack
    public init(
        vertical spacing: CGFloat? = nil,
        alignment: HorizontalAlignment = .center,
        showDividers: Bool = false,
        dividerColor: Color? = nil,
        dividerThickness: CGFloat = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.orientation = .vertical
        self.spacing = spacing
        self.alignment = Alignment(horizontal: alignment, vertical: .center)
        self.horizontalAlignment = alignment
        self.verticalAlignment = .center
        self.showDividers = showDividers
        self.dividerColor = dividerColor
        self.dividerThickness = dividerThickness
        self.content = content()
    }
    
    /// Initialize a new horizontal stack
    /// - Parameters:
    ///   - spacing: The spacing between items, nil for default spacing (default: nil)
    ///   - alignment: The vertical alignment of the stack (default: .center)
    ///   - showDividers: Whether to show dividers between items (default: false)
    ///   - dividerColor: The color of the dividers (default: theme's border color)
    ///   - dividerThickness: The thickness of the dividers (default: 1)
    ///   - content: The content of the stack
    public init(
        horizontal spacing: CGFloat? = nil,
        alignment: VerticalAlignment = .center,
        showDividers: Bool = false,
        dividerColor: Color? = nil,
        dividerThickness: CGFloat = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.orientation = .horizontal
        self.spacing = spacing
        self.alignment = Alignment(horizontal: .center, vertical: alignment)
        self.horizontalAlignment = .center
        self.verticalAlignment = alignment
        self.showDividers = showDividers
        self.dividerColor = dividerColor
        self.dividerThickness = dividerThickness
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if orientation == .vertical {
                verticalStack
            } else {
                horizontalStack
            }
        }
    }
    
    // MARK: - Private Views
    
    private var verticalStack: some View {
        Group {
            if showDividers {
                VStack(alignment: horizontalAlignment, spacing: 0) {
                    content
                        .modifier(DividerModifier(
                            orientation: .vertical,
                            spacing: spacing,
                            dividerColor: dividerColor,
                            dividerThickness: dividerThickness
                        ))
                }
            } else {
                VStack(alignment: horizontalAlignment, spacing: spacing) {
                    content
                }
            }
        }
    }
    
    private var horizontalStack: some View {
        Group {
            if showDividers {
                HStack(alignment: verticalAlignment, spacing: 0) {
                    content
                        .modifier(DividerModifier(
                            orientation: .horizontal,
                            spacing: spacing,
                            dividerColor: dividerColor,
                            dividerThickness: dividerThickness
                        ))
                }
            } else {
                HStack(alignment: verticalAlignment, spacing: spacing) {
                    content
                }
            }
        }
    }
}

// MARK: - Supporting Types

/// A view modifier that adds dividers between content items
private struct DividerModifier: ViewModifier {
    let orientation: CTStack<AnyView>.Orientation
    let spacing: CGFloat?
    let dividerColor: Color?
    let dividerThickness: CGFloat
    
    func body(content: Content) -> some View {
        if let tupleView = content as? TupleView<AnyView> {
            let count = Mirror(reflecting: tupleView.value).children.count
            
            ForEach(0..<count, id: \.self) { index in
                if index > 0 {
                    divider
                }
                content
            }
        } else {
            content
        }
    }
    
    private var divider: some View {
        Group {
            if let dividerColor = dividerColor {
                if orientation == .vertical {
                    CTDivider(
                        orientation: .horizontal,
                        color: dividerColor,
                        thickness: dividerThickness
                    )
                    .padding(.vertical, spacing ?? CTSpacing.xs)
                } else {
                    CTDivider(
                        orientation: .vertical,
                        color: dividerColor,
                        thickness: dividerThickness
                    )
                    .padding(.horizontal, spacing ?? CTSpacing.xs)
                }
            }
        }
    }
}

// MARK: - View Extensions

public extension View {
    /// Wrap this view in a vertical CTStack
    /// - Parameters:
    ///   - spacing: The spacing between items
    ///   - alignment: The horizontal alignment of the stack
    ///   - showDividers: Whether to show dividers between items
    /// - Returns: A CTStack containing this view
    func ctVStack(
        spacing: CGFloat? = nil,
        alignment: HorizontalAlignment = .center,
        showDividers: Bool = false
    ) -> CTStack<Self> {
        CTStack(
            vertical: spacing,
            alignment: alignment,
            showDividers: showDividers
        ) {
            self
        }
    }
    
    /// Wrap this view in a horizontal CTStack
    /// - Parameters:
    ///   - spacing: The spacing between items
    ///   - alignment: The vertical alignment of the stack
    ///   - showDividers: Whether to show dividers between items
    /// - Returns: A CTStack containing this view
    func ctHStack(
        spacing: CGFloat? = nil,
        alignment: VerticalAlignment = .center,
        showDividers: Bool = false
    ) -> CTStack<Self> {
        CTStack(
            horizontal: spacing,
            alignment: alignment,
            showDividers: showDividers
        ) {
            self
        }
    }
}

// MARK: - Previews

//struct CTStack_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(spacing: CTSpacing.l) {
//            // Vertical stack with default spacing
//            CTStack {
//                Text("Item 1").ctBody()
//                Text("Item 2").ctBody()
//                Text("Item 3").ctBody()
//            }
//            .padding()
//            .background(Color.ctSurface)
//            .cornerRadius(8)
//            .shadow(color: Color.ctShadow, radius: 4, x: 0, y: 2)
//            
//            // Horizontal stack with custom spacing
//            CTStack(orientation: .horizontal, spacing: CTSpacing.m) {
//                Text("Left").ctBody()
//                Text("Center").ctBody()
//                Text("Right").ctBody()
//            }
//            .padding()
//            .background(Color.ctSurface)
//            .cornerRadius(8)
//            .shadow(color: Color.ctShadow, radius: 4, x: 0, y: 2)
//            
//            // Vertical stack with dividers
//            CTStack(showDividers: true) {
//                Text("Section 1").ctBody()
//                Text("Section 2").ctBody()
//                Text("Section 3").ctBody()
//            }
//            .padding()
//            .background(Color.ctSurface)
//            .cornerRadius(8)
//            .shadow(color: Color.ctShadow, radius: 4, x: 0, y: 2)
//            
//            // Horizontal stack with dividers and custom color
//            CTStack(
//                orientation: .horizontal,
//                spacing: CTSpacing.s,
//                showDividers: true,
//                dividerColor: .ctPrimary,
//                dividerThickness: 2
//            ) {
//                Text("Tab 1").ctBody()
//                Text("Tab 2").ctBody()
//                Text("Tab 3").ctBody()
//            }
//            .padding()
//            .background(Color.ctSurface)
//            .cornerRadius(8)
//            .shadow(color: Color.ctShadow, radius: 4, x: 0, y: 2)
//        }
//        .padding()
//        .previewLayout(.sizeThatFits)
//        .previewDisplayName("Stack Examples")
//    }
//}
