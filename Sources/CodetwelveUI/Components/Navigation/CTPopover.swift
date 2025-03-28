//
//  CTPopover.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// The arrow position relative to the popover
public enum CTPopoverArrowPosition {
    /// Arrow positioned at the top center
    case top
    
    /// Arrow positioned at the bottom center
    case bottom
    
    /// Arrow positioned at the leading edge
    case leading
    
    /// Arrow positioned at the trailing edge
    case trailing
    
    /// Calculates the x position for the arrow based on the geometry
    func xPosition(in geometry: GeometryProxy) -> CGFloat {
        switch self {
        case .top, .bottom:
            return geometry.size.width / 2
        case .leading:
            return 20
        case .trailing:
            return geometry.size.width - 20
        }
    }
    
    /// Calculates the y position for the arrow based on the geometry
    func yPosition(in geometry: GeometryProxy) -> CGFloat {
        switch self {
        case .top:
            return 0
        case .bottom:
            return geometry.size.height
        case .leading, .trailing:
            return geometry.size.height / 2
        }
    }
}

/// A customizable popover component for displaying content in a floating container.
///
/// `CTPopover` provides a consistent popover interface throughout your application
/// with support for different sizes, arrow positioning, and dismissal behaviors.
///
/// # Example
///
/// ```swift
/// CTPopover(isPresented: $showPopover) {
///     VStack {
///         Text("Popover Content")
///         CTButton("Close") {
///             showPopover = false
///         }
///     }
/// }
///
/// // With custom configuration
/// CTPopover(
///     isPresented: $showPopover,
///     arrowPosition: .bottom,
///     style: .modern,
///     dismissOnTap: true
/// ) {
///     CustomPopoverContent()
/// }
/// ```
public struct CTPopover<Content: View>: View {
    // MARK: - Public Properties
    
    /// The style of the popover
    public enum CTPopoverStyle {
        /// Default style with subtle background and shadow
        case `default`
        
        /// Modern style with more pronounced background and softer edges
        case modern
        
        /// Minimal style with minimal background and no shadow
        case minimal
        
        /// Custom style with specific configuration
        case custom(
            backgroundColor: Color,
            cornerRadius: CGFloat,
            shadowRadius: CGFloat,
            shadowOpacity: Double
        )
    }
    
    // MARK: - Private Properties
    
    @Binding private var isPresented: Bool
    private let content: Content
    private let arrowPosition: CTPopoverArrowPosition
    private let style: CTPopoverStyle
    private let dismissOnBackgroundTap: Bool
    private let width: CGFloat?
    private let maxHeight: CGFloat?
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new popover with content
    /// - Parameters:
    ///   - isPresented: Binding to control popover visibility
    ///   - arrowPosition: Position of the arrow relative to the popover
    ///   - style: Visual style of the popover
    ///   - dismissOnBackgroundTap: Whether tapping outside dismisses the popover
    ///   - width: Optional fixed width for the popover
    ///   - maxHeight: Optional maximum height for the popover
    ///   - horizontalPadding: Horizontal padding within the popover
    ///   - verticalPadding: Vertical padding within the popover
    ///   - content: Content builder for the popover
    public init(
        isPresented: Binding<Bool>,
        arrowPosition: CTPopoverArrowPosition = .top,
        style: CTPopoverStyle = .default,
        dismissOnBackgroundTap: Bool = true,
        width: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        horizontalPadding: CGFloat = CTSpacing.m,
        verticalPadding: CGFloat = CTSpacing.m,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.content = content()
        self.arrowPosition = arrowPosition
        self.style = style
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.width = width
        self.maxHeight = maxHeight
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            if isPresented {
                backdropView
                    .ctAnimation(CTAnimation.fadeIn, value: isPresented)
                
                popoverContentView
                    .ctAnimation(CTAnimation.slideIn, value: isPresented)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: - Private Views
    
    private var backdropView: some View {
        Color.black
            .opacity(0.3)
            .onTapGesture {
                if dismissOnBackgroundTap {
                    withAnimation {
                        isPresented = false
                    }
                }
            }
    }
    
    private var popoverContentView: some View {
        VStack {
            content
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .frame(width: width)
        .frame(maxHeight: maxHeight)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .shadow(
            color: shadowColor,
            radius: shadowRadius,
            x: 0,
            y: 2
        )
        .overlay(
            arrowView
                .position(arrowPosition)
        )
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        ))
        .zIndex(1000)
        .accessibilityLabel("Popover")
    }
    
    private var arrowView: some View {
        Triangle()
            .fill(backgroundColor)
            .frame(width: 20, height: 10)
    }
    
    // MARK: - Style Configuration
    
    private var backgroundColor: Color {
        switch style {
        case .default:
            return theme.surface
        case .modern:
            return theme.surface
        case .minimal:
            return theme.surface.opacity(0.9)
        case .custom(let backgroundColor, _, _, _):
            return backgroundColor
        }
    }
    
    private var cornerRadius: CGFloat {
        switch style {
        case .default:
            return theme.borderRadius
        case .modern:
            return theme.borderRadius * 1.5
        case .minimal:
            return theme.borderRadius / 2
        case .custom(_, let customRadius, _, _):
            return customRadius
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .default:
            return 4
        case .modern:
            return 8
        case .minimal:
            return 2
        case .custom(_, _, let customShadowRadius, _):
            return customShadowRadius
        }
    }
    
    private var shadowColor: Color {
        theme.shadowColor
    }
}

// MARK: - Supporting Views and Extensions

/// A custom triangle view for popover arrow
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/// Extension to position the arrow view based on specified position
private extension View {
    func position(_ position: CTPopoverArrowPosition) -> some View {
        GeometryReader { geometry in
            self.position(
                x: position.xPosition(in: geometry),
                y: position.yPosition(in: geometry)
            )
        }
    }
}

// MARK: - Previews

struct CTPopover_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Basic popover
            CTPopover(
                isPresented: .constant(true),
                arrowPosition: .top,
                content: {
                    Text("Basic Popover")
                        .padding()
                }
            )
            .previewDisplayName("Basic Popover")
            
            // Popover with custom style
            CTPopover(
                isPresented: .constant(true),
                arrowPosition: .bottom,
                style: .custom(
                    backgroundColor: .blue,
                    cornerRadius: 16,
                    shadowRadius: 8,
                    shadowOpacity: 0.3
                ),
                content: {
                    Text("Custom Style Popover")
                        .foregroundColor(.white)
                        .padding()
                }
            )
            .previewDisplayName("Custom Style Popover")
            
            // Popover with different arrow positions
            HStack(spacing: 20) {
                CTPopover(
                    isPresented: .constant(true),
                    arrowPosition: .leading,
                    content: {
                        Text("Left Arrow")
                            .padding()
                    }
                )
                
                CTPopover(
                    isPresented: .constant(true),
                    arrowPosition: .trailing,
                    content: {
                        Text("Right Arrow")
                            .padding()
                    }
                )
            }
            .previewDisplayName("Arrow Positions")
        }
        .padding()
    }
}

// MARK: - View Extension

public extension View {
    /// Convenience method to attach a popover to a view
    func ctPopover<PopoverContent: View>(
        isPresented: Binding<Bool>,
        arrowPosition: CTPopoverArrowPosition = .top,
        style: CTPopover<PopoverContent>.CTPopoverStyle = .default,
        dismissOnBackgroundTap: Bool = true,
        width: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        horizontalPadding: CGFloat = CTSpacing.m,
        verticalPadding: CGFloat = CTSpacing.m,
        @ViewBuilder content: @escaping () -> PopoverContent
    ) -> some View {
        self.overlay(
            CTPopover(
                isPresented: isPresented,
                arrowPosition: arrowPosition,
                style: style,
                dismissOnBackgroundTap: dismissOnBackgroundTap,
                width: width,
                maxHeight: maxHeight,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                content: content
            )
        )
    }
}