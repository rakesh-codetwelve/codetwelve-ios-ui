//
//  CTDrawer.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A drawer component that slides in from the edge of the screen.
///
/// `CTDrawer` provides a drawer navigation pattern commonly used in mobile applications,
/// allowing content to slide in from any edge of the screen with a backdrop overlay.
///
/// # Example
///
/// ```swift
/// @State private var isDrawerOpen = false
///
/// Button("Open Drawer") {
///     isDrawerOpen = true
/// }
/// .ctDrawer(isPresented: $isDrawerOpen, edge: .leading) {
///     VStack(alignment: .leading, spacing: CTSpacing.m) {
///         Text("Drawer Menu").ctHeading2()
///         
///         Button("Home") {
///             // Navigate to home
///             isDrawerOpen = false
///         }
///         
///         Button("Settings") {
///             // Navigate to settings
///             isDrawerOpen = false
///         }
///     }
///     .padding()
///     .frame(width: 250)
/// }
/// ```
public struct CTDrawer<Content: View>: ViewModifier {
    // MARK: - Type Aliases
    
    /// The type of view representing the body of this view modifier
    public typealias Body = Never
    
    // MARK: - Public Properties
    
    /// The content to display in the drawer
    private let content: Content
    
    /// Whether the drawer is presented
    @Binding private var isPresented: Bool
    
    /// The edge from which the drawer appears
    private let edge: Edge
    
    /// The style of the drawer
    private let style: CTDrawerStyle
    
    /// The width or height of the drawer (depending on the edge)
    private let size: CGFloat?
    
    /// Whether tapping the backdrop dismisses the drawer
    private let closeOnBackdropTap: Bool
    
    /// Action to perform when the drawer is dismissed
    private let onDismiss: (() -> Void)?
    
    // MARK: - Environment Properties
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Private Properties
    
    /// The offset for the drawer animation
    @State private var offset: CGFloat = 0
    
    /// The animation state of the drawer
    @State private var animationState: AnimationState = .dismissed
    
    // MARK: - Initializers
    
    /// Initialize a new drawer
    /// - Parameters:
    ///   - isPresented: Binding to control whether the drawer is presented
    ///   - edge: The edge from which the drawer appears
    ///   - style: The style of the drawer
    ///   - size: The width or height of the drawer (depending on the edge)
    ///   - closeOnBackdropTap: Whether tapping the backdrop dismisses the drawer
    ///   - onDismiss: Action to perform when the drawer is dismissed
    ///   - content: Content builder for the drawer
    public init(
        isPresented: Binding<Bool>,
        edge: Edge,
        style: CTDrawerStyle = .default,
        size: CGFloat? = nil,
        closeOnBackdropTap: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.edge = edge
        self.style = style
        self.size = size
        self.closeOnBackdropTap = closeOnBackdropTap
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isPresented {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .transition(.opacity)
                            .animation(.easeInOut, value: isPresented)
                    }
                }
            )
            .overlay(
                Group {
                    if isPresented {
                        GeometryReader { geometry in
                            drawerContent(in: geometry)
                        }
                        .transition(.move(edge: edge))
                        .animation(.easeInOut(duration: 0.3), value: offset)
                    }
                }
            )
    }
    
    // MARK: - Private Views
    
    /// Create the drawer content with appropriate positioning and styling
    @ViewBuilder
    private func drawerContent(in geometry: GeometryProxy) -> some View {
        let drawerSize = self.calculateDrawerSize(geometry)
        
        content
            .frame(
                width: isHorizontalEdge ? drawerSize : nil,
                height: isHorizontalEdge ? nil : drawerSize
            )
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius, corners: calculateCorners(for: edge))
            .shadow(
                color: theme.shadowColor.opacity(theme.shadowOpacity),
                radius: theme.shadowRadius,
                x: calculateShadowOffset().width,
                y: calculateShadowOffset().height
            )
            .frame(
                width: isHorizontalEdge ? nil : geometry.size.width,
                height: isHorizontalEdge ? geometry.size.height : nil,
                alignment: calculateAlignment(for: edge)
            )
            .offset(calculateOffset())
    }
    
    // MARK: - Private Helper Properties
    
    /// Whether the drawer appears from a horizontal edge (leading or trailing)
    private var isHorizontalEdge: Bool {
        return edge == .leading || edge == .trailing
    }
    
    // MARK: - Private Helper Methods
    
    /// Calculate the size of the drawer based on the geometry and provided size
    private func calculateDrawerSize(_ geometry: GeometryProxy) -> CGFloat {
        if let size = self.size {
            return size
        } else if isHorizontalEdge {
            return min(geometry.size.width * 0.85, 350)
        } else {
            return geometry.size.height * 0.5
        }
    }
    
    /// Calculate the edge offset for animation
    private func calculateEdgeOffset(_ edge: Edge) -> CGFloat {
        switch edge {
        case .leading, .top:
            return -1000
        case .trailing, .bottom:
            return 1000
        }
    }
    
    /// Calculate the corners to round based on the edge
    private func calculateCorners(for edge: Edge) -> UIRectCorner {
        switch edge {
        case .leading:
            return [.topRight, .bottomRight]
        case .trailing:
            return [.topLeft, .bottomLeft]
        case .top:
            return [.bottomLeft, .bottomRight]
        case .bottom:
            return [.topLeft, .topRight]
        }
    }
    
    /// Calculate the alignment for positioning the drawer
    private func calculateAlignment(for edge: Edge) -> Alignment {
        switch edge {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
    
    /// Calculate the offset for the drawer animation
    private func calculateOffset() -> CGSize {
        let value = animationState == .presented ? 0 : offset
        
        switch edge {
        case .leading:
            return CGSize(width: value, height: 0)
        case .trailing:
            return CGSize(width: value, height: 0)
        case .top:
            return CGSize(width: 0, height: value)
        case .bottom:
            return CGSize(width: 0, height: value)
        }
    }
    
    /// Calculate the shadow offset based on the edge
    private func calculateShadowOffset() -> CGSize {
        switch edge {
        case .leading:
            return CGSize(width: 2, height: 0)
        case .trailing:
            return CGSize(width: -2, height: 0)
        case .top:
            return CGSize(width: 0, height: 2)
        case .bottom:
            return CGSize(width: 0, height: -2)
        }
    }
    
    /// Dismiss the drawer
    private func dismiss() {
        isPresented = false
        onDismiss?()
    }
}

// MARK: - Supporting Types

/// The animation state of the drawer
private enum AnimationState {
    /// The drawer is fully dismissed
    case dismissed
    
    /// The drawer is in the process of being dismissed
    case dismissing
    
    /// The drawer is fully presented
    case presented
}

/// The style of the drawer
public struct CTDrawerStyle {
    /// The background color of the drawer
    public let backgroundColor: Color
    
    /// The corner radius of the drawer
    public let cornerRadius: CGFloat
    
    /// The opacity of the backdrop
    public let backdropOpacity: Double
    
    /// Default drawer style
    public static var `default`: CTDrawerStyle {
        CTDrawerStyle(
            backgroundColor: Color.ctSurface,
            cornerRadius: 12,
            backdropOpacity: 0.4
        )
    }
    
    /// Create a custom drawer style
    /// - Parameters:
    ///   - backgroundColor: The background color of the drawer
    ///   - cornerRadius: The corner radius of the drawer
    ///   - backdropOpacity: The opacity of the backdrop
    public init(
        backgroundColor: Color,
        cornerRadius: CGFloat,
        backdropOpacity: Double
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.backdropOpacity = backdropOpacity
    }
}

// MARK: - View Extensions

public extension View {
    /// Presents a drawer when a binding to a Boolean value is true.
    ///
    /// # Example
    ///
    /// ```swift
    /// @State private var isDrawerOpen = false
    ///
    /// Button("Open Drawer") {
    ///     isDrawerOpen = true
    /// }
    /// .ctDrawer(isPresented: $isDrawerOpen, edge: .leading) {
    ///     // Drawer content
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the drawer.
    ///   - edge: The edge from which the drawer appears.
    ///   - style: The style of the drawer.
    ///   - size: The width or height of the drawer (depending on the edge).
    ///   - closeOnBackdropTap: Whether tapping the backdrop dismisses the drawer.
    ///   - onDismiss: Action to perform when the drawer is dismissed.
    ///   - content: A closure that returns the content of the drawer.
    /// - Returns: A view that presents a drawer when `isPresented` is true.
    func ctDrawer<Content: View>(
        isPresented: Binding<Bool>,
        edge: Edge,
        style: CTDrawerStyle = .default,
        size: CGFloat? = nil,
        closeOnBackdropTap: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            CTDrawer(
                isPresented: isPresented,
                edge: edge,
                style: style,
                size: size,
                closeOnBackdropTap: closeOnBackdropTap,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
    
    /// Presents a drawer from the leading edge when a binding to a Boolean value is true.
    ///
    /// # Example
    ///
    /// ```swift
    /// @State private var isDrawerOpen = false
    ///
    /// Button("Open Drawer") {
    ///     isDrawerOpen = true
    /// }
    /// .ctLeadingDrawer(isPresented: $isDrawerOpen) {
    ///     // Drawer content
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the drawer.
    ///   - style: The style of the drawer.
    ///   - width: The width of the drawer.
    ///   - closeOnBackdropTap: Whether tapping the backdrop dismisses the drawer.
    ///   - onDismiss: Action to perform when the drawer is dismissed.
    ///   - content: A closure that returns the content of the drawer.
    /// - Returns: A view that presents a drawer from the leading edge when `isPresented` is true.
    func ctLeadingDrawer<Content: View>(
        isPresented: Binding<Bool>,
        style: CTDrawerStyle = .default,
        width: CGFloat? = nil,
        closeOnBackdropTap: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.ctDrawer(
            isPresented: isPresented,
            edge: .leading,
            style: style,
            size: width,
            closeOnBackdropTap: closeOnBackdropTap,
            onDismiss: onDismiss,
            content: content
        )
    }
    
    /// Presents a drawer from the trailing edge when a binding to a Boolean value is true.
    ///
    /// # Example
    ///
    /// ```swift
    /// @State private var isDrawerOpen = false
    ///
    /// Button("Open Drawer") {
    ///     isDrawerOpen = true
    /// }
    /// .ctTrailingDrawer(isPresented: $isDrawerOpen) {
    ///     // Drawer content
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the drawer.
    ///   - style: The style of the drawer.
    ///   - width: The width of the drawer.
    ///   - closeOnBackdropTap: Whether tapping the backdrop dismisses the drawer.
    ///   - onDismiss: Action to perform when the drawer is dismissed.
    ///   - content: A closure that returns the content of the drawer.
    /// - Returns: A view that presents a drawer from the trailing edge when `isPresented` is true.
    func ctTrailingDrawer<Content: View>(
        isPresented: Binding<Bool>,
        style: CTDrawerStyle = .default,
        width: CGFloat? = nil,
        closeOnBackdropTap: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.ctDrawer(
            isPresented: isPresented,
            edge: .trailing,
            style: style,
            size: width,
            closeOnBackdropTap: closeOnBackdropTap,
            onDismiss: onDismiss,
            content: content
        )
    }
    
    /// Presents a drawer from the top edge when a binding to a Boolean value is true.
    ///
    /// # Example
    ///
    /// ```swift
    /// @State private var isDrawerOpen = false
    ///
    /// Button("Open Drawer") {
    ///     isDrawerOpen = true
    /// }
    /// .ctTopDrawer(isPresented: $isDrawerOpen) {
    ///     // Drawer content
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the drawer.
    ///   - style: The style of the drawer.
    ///   - height: The height of the drawer.
    ///   - closeOnBackdropTap: Whether tapping the backdrop dismisses the drawer.
    ///   - onDismiss: Action to perform when the drawer is dismissed.
    ///   - content: A closure that returns the content of the drawer.
    /// - Returns: A view that presents a drawer from the top edge when `isPresented` is true.
    func ctTopDrawer<Content: View>(
        isPresented: Binding<Bool>,
        style: CTDrawerStyle = .default,
        height: CGFloat? = nil,
        closeOnBackdropTap: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.ctDrawer(
            isPresented: isPresented,
            edge: .top,
            style: style,
            size: height,
            closeOnBackdropTap: closeOnBackdropTap,
            onDismiss: onDismiss,
            content: content
        )
    }
    
    /// Presents a drawer from the bottom edge when a binding to a Boolean value is true.
    ///
    /// # Example
    ///
    /// ```swift
    /// @State private var isDrawerOpen = false
    ///
    /// Button("Open Drawer") {
    ///     isDrawerOpen = true
    /// }
    /// .ctBottomDrawer(isPresented: $isDrawerOpen) {
    ///     // Drawer content
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the drawer.
    ///   - style: The style of the drawer.
    ///   - height: The height of the drawer.
    ///   - closeOnBackdropTap: Whether tapping the backdrop dismisses the drawer.
    ///   - onDismiss: Action to perform when the drawer is dismissed.
    ///   - content: A closure that returns the content of the drawer.
    /// - Returns: A view that presents a drawer from the bottom edge when `isPresented` is true.
    func ctBottomDrawer<Content: View>(
        isPresented: Binding<Bool>,
        style: CTDrawerStyle = .default,
        height: CGFloat? = nil,
        closeOnBackdropTap: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.ctDrawer(
            isPresented: isPresented,
            edge: .bottom,
            style: style,
            size: height,
            closeOnBackdropTap: closeOnBackdropTap,
            onDismiss: onDismiss,
            content: content
        )
    }
}

// MARK: - Previews

//struct CTDrawer_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawerPreviewContainer()
//            .ctTheme(CTDefaultTheme())
//    }
//    
//    private struct DrawerPreviewContainer: View {
//        @State private var isLeadingDrawerPresented = false
//        @State private var isTrailingDrawerPresented = false
//        @State private var isTopDrawerPresented = false
//        @State private var isBottomDrawerPresented = false
//        @State private var isCustomDrawerPresented = false
//        @State private var isLargeDrawerPresented = false
//        @State private var isSmallDrawerPresented = false
//        @State private var isDynamicDrawerPresented = false
//        @Environment(\.ctTheme) private var theme
//        
//        var body: some View {
//            ScrollView {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Drawer Examples").ctHeading2()
//                    
//                    Button("Show Leading Drawer") {
//                        isLeadingDrawerPresented = true
//                    }
//                    .ctButton(style: .primary)
//                    
//                    Button("Show Trailing Drawer") {
//                        isTrailingDrawerPresented = true
//                    }
//                    .ctButton(style: .secondary)
//                    
//                    Button("Show Top Drawer") {
//                        isTopDrawerPresented = true
//                    }
//                    .ctButton(style: .outline)
//                    
//                    Button("Show Bottom Drawer") {
//                        isBottomDrawerPresented = true
//                    }
//                    .ctButton(style: .ghost)
//                    
//                    Button("Show Custom Drawer") {
//                        isCustomDrawerPresented = true
//                    }
//                    .ctButton(style: .link)
//                    
//                    Button("Show Large Drawer") {
//                        isLargeDrawerPresented = true
//                    }
//                    .ctButton(style: .primary)
//                    
//                    Button("Show Small Drawer") {
//                        isSmallDrawerPresented = true
//                    }
//                    .ctButton(style: .secondary)
//                    
//                    Button("Show Dynamic Drawer") {
//                        isDynamicDrawerPresented = true
//                    }
//                    .ctButton(style: .outline)
//                }
//                .padding()
//            }
//            .ctDrawer(isPresented: $isLeadingDrawerPresented, edge: .leading) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Leading Drawer").ctHeading2()
//                    Text("This drawer slides in from the leading edge.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctDrawer(isPresented: $isTrailingDrawerPresented, edge: .trailing) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Trailing Drawer").ctHeading2()
//                    Text("This drawer slides in from the trailing edge.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctDrawer(isPresented: $isTopDrawerPresented, edge: .top) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Top Drawer").ctHeading2()
//                    Text("This drawer slides in from the top edge.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctDrawer(isPresented: $isBottomDrawerPresented, edge: .bottom) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Bottom Drawer").ctHeading2()
//                    Text("This drawer slides in from the bottom edge.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctDrawer(
//                isPresented: $isCustomDrawerPresented,
//                edge: .leading,
//                style: CTDrawerStyle(
//                    backgroundColor: theme.primary,
//                    cornerRadius: 24,
//                    backdropOpacity: 0.6
//                )
//            ) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Custom Drawer").ctHeading2()
//                        .foregroundColor(.white)
//                    Text("This drawer has custom styling with a primary color background.")
//                        .ctBody()
//                        .foregroundColor(.white)
//                }
//                .padding()
//            }
//            .ctDrawer(isPresented: $isLargeDrawerPresented, edge: .leading, size: 300) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Large Drawer").ctHeading2()
//                    Text("This drawer has a fixed width of 300 points.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctDrawer(isPresented: $isSmallDrawerPresented, edge: .leading, size: 200) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Small Drawer").ctHeading2()
//                    Text("This drawer has a fixed width of 200 points.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctDrawer(isPresented: $isDynamicDrawerPresented, edge: .leading, size: nil) {
//                VStack(alignment: .leading, spacing: CTSpacing.m) {
//                    Text("Dynamic Drawer").ctHeading2()
//                    Text("This drawer adjusts its width based on the content.")
//                        .ctBody()
//                    
//                    ForEach(1..<8) { index in
//                        HStack {
//                            Image(systemName: "\(index).circle.fill")
//                            Text("Item \(index)")
//                                .ctBody()
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(theme.surface)
//                        .cornerRadius(8)
//                    }
//                }
//                .padding()
//            }
//        }
//    }
//}
