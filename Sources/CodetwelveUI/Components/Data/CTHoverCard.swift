//
//  CTHoverCard.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A hover card component for displaying additional information when hovering over an element.
///
/// `CTHoverCard` provides a way to show additional context or preview information
/// when the user hovers over or long-presses an element. It's useful for providing
/// supplementary information without requiring navigation to a new screen.
///
/// # Example
///
/// ```swift
/// // Basic hover card
/// Text("Hover over me")
///     .ctHoverCard {
///         VStack(alignment: .leading) {
///             Text("Hover Card Title").bold()
///             Text("This is additional information that appears on hover.")
///         }
///         .padding()
///     }
///
/// // Hover card with custom settings
/// Text("Advanced hover example")
///     .ctHoverCard(
///         placement: .bottom,
///         showDelay: 0.3,
///         hideDelay: 0.1
///     ) {
///         Text("Custom hover card content")
///     }
/// ```
public struct CTHoverCard<Content: View, HoverContent: View>: View {
    // MARK: - Public Properties
    
    /// The placement of the hover card relative to the trigger
    public enum Placement {
        /// Above the trigger
        case top
        
        /// Below the trigger
        case bottom
        
        /// To the left of the trigger
        case leading
        
        /// To the right of the trigger
        case trailing
        
        /// Automatically determined based on available space
        case automatic
    }
    
    // MARK: - Private Properties
    
    /// The trigger content
    private let content: Content
    
    /// The hover card content
    private let hoverContent: HoverContent
    
    /// The placement of the hover card
    private let placement: Placement
    
    /// The width of the hover card (nil for automatic)
    private let width: CGFloat?
    
    /// The offset from the trigger
    private let offset: CGPoint
    
    /// Delay before showing the hover card
    private let showDelay: Double
    
    /// Delay before hiding the hover card
    private let hideDelay: Double
    
    /// Whether the hover card can be dismissed by tapping outside
    private let dismissible: Bool
    
    /// State tracking whether the hover card is visible
    @State private var isHovering: Bool = false
    
    /// State tracking whether the hover card should be shown
    @State private var shouldShow: Bool = false
    
    /// State tracking whether the long press gesture has fired (for iOS)
    @State private var hasLongPressed: Bool = false
    
    /// Timer for delayed show/hide
    @State private var hoverTimer: Timer? = nil
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new hover card
    /// - Parameters:
    ///   - placement: The placement of the hover card
    ///   - width: The width of the hover card (nil for automatic)
    ///   - offset: The offset from the trigger
    ///   - showDelay: Delay before showing the hover card
    ///   - hideDelay: Delay before hiding the hover card
    ///   - dismissible: Whether the hover card can be dismissed by tapping outside
    ///   - content: The trigger content
    ///   - hoverContent: The hover card content
    public init(
        placement: Placement = .automatic,
        width: CGFloat? = nil,
        offset: CGPoint = CGPoint(x: 0, y: 10),
        showDelay: Double = 0.2,
        hideDelay: Double = 0.3,
        dismissible: Bool = true,
        @ViewBuilder content: () -> Content,
        @ViewBuilder hoverContent: () -> HoverContent
    ) {
        self.content = content()
        self.hoverContent = hoverContent()
        self.placement = placement
        self.width = width
        self.offset = offset
        self.showDelay = showDelay
        self.hideDelay = hideDelay
        self.dismissible = dismissible
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .center) {
            // Trigger content
            content
                // Use gestures for different platforms
                #if os(iOS)
                // On iOS, use long press gesture
                .onLongPressGesture(minimumDuration: 0.5) {
                    handleHoverStart()
                    hasLongPressed = true
                }
                .onTapGesture {
                    if hasLongPressed {
                        hasLongPressed = false
                    } else {
                        // Regular tap behavior can go here if needed
                    }
                }
                #else
                // On macOS, use hover gestures
                .onHover { hovering in
                    if hovering {
                        handleHoverStart()
                    } else {
                        handleHoverEnd()
                    }
                }
                #endif
                .zIndex(1)
                .overlay(
                    GeometryReader { geometry in
                        ZStack {
                            if shouldShow {
                                // Background overlay for dismissal
                                if dismissible {
                                    Color.clear
                                        .contentShape(Rectangle())
                                        .ignoresSafeArea()
                                        .onTapGesture {
                                            withAnimation {
                                                shouldShow = false
                                                hasLongPressed = false
                                            }
                                        }
                                }
                                
                                // Hover card content
                                hoverCardView
                                    .animation(.easeInOut(duration: 0.2), value: shouldShow)
                                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                                    .position(
                                        calculatePosition(
                                            for: placement,
                                            in: geometry
                                        )
                                    )
                            }
                        }
                    }
                )
        }
    }
    
    // MARK: - Private Views
    
    /// The hover card view with styling
    private var hoverCardView: some View {
        hoverContent
            .padding()
            .frame(width: width)
            .background(theme.surface)
            .cornerRadius(theme.borderRadius)
            .overlay(
                RoundedRectangle(cornerRadius: theme.borderRadius)
                    .stroke(theme.border, lineWidth: theme.borderWidth)
            )
            .shadow(
                color: theme.shadowColor.opacity(theme.shadowOpacity),
                radius: theme.shadowRadius,
                x: theme.shadowOffset.width,
                y: theme.shadowOffset.height
            )
    }
    
    // MARK: - Private Methods
    
    /// Handle the start of a hover event
    private func handleHoverStart() {
        // Cancel any existing timer
        hoverTimer?.invalidate()
        
        // Create a new timer for showing
        hoverTimer = Timer.scheduledTimer(withTimeInterval: showDelay, repeats: false) { _ in
            withAnimation {
                shouldShow = true
            }
        }
    }
    
    /// Handle the end of a hover event
    private func handleHoverEnd() {
        // Cancel any existing timer
        hoverTimer?.invalidate()
        
        // Create a new timer for hiding
        hoverTimer = Timer.scheduledTimer(withTimeInterval: hideDelay, repeats: false) { _ in
            withAnimation {
                shouldShow = false
            }
        }
    }
    
    /// Calculate the position of the hover card based on the placement
    /// - Parameters:
    ///   - placement: The desired placement
    ///   - geometry: The geometry of the trigger view
    /// - Returns: The position for the hover card
    private func calculatePosition(for placement: Placement, in geometry: GeometryProxy) -> CGPoint {
        let rect = geometry.frame(in: .global)
        
        // Default values
        var x = rect.midX + offset.x
        var y = rect.midY + offset.y
        
        // Determine placement based on available space
        var effectivePlacement = placement
        
        if placement == .automatic {
            // Simplified automatic placement logic - could be enhanced with more space checking
            let screenHeight = UIScreen.main.bounds.height
            let spaceBelow = screenHeight - rect.maxY
            
            if spaceBelow < 200 && rect.minY > spaceBelow {
                effectivePlacement = .top
            } else {
                effectivePlacement = .bottom
            }
        }
        
        // Apply position based on placement
        switch effectivePlacement {
        case .top:
            y = rect.minY - 20 + offset.y
        case .bottom:
            y = rect.maxY + 20 + offset.y
        case .leading:
            x = rect.minX - 20 + offset.x
            y = rect.midY + offset.y
        case .trailing:
            x = rect.maxX + 20 + offset.x
            y = rect.midY + offset.y
        case .automatic:
            // Already handled above
            break
        }
        
        return CGPoint(x: x, y: y)
    }
}

// MARK: - View Extensions

public extension View {
    /// Apply a hover card to a view
    ///
    /// This modifier adds a hover card that appears when the user hovers over
    /// or long-presses the view.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Hover over me")
    ///     .ctHoverCard {
    ///         VStack(alignment: .leading) {
    ///             Text("Hover Card Title").bold()
    ///             Text("This is additional information that appears on hover.")
    ///         }
    ///         .padding()
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - placement: The placement of the hover card
    ///   - width: The width of the hover card (nil for automatic)
    ///   - offset: The offset from the trigger
    ///   - showDelay: Delay before showing the hover card
    ///   - hideDelay: Delay before hiding the hover card
    ///   - dismissible: Whether the hover card can be dismissed by tapping outside
    ///   - hoverContent: The hover card content
    /// - Returns: The view with the hover card modifier applied
    func ctHoverCard<HoverContent: View>(
        placement: CTHoverCard<Self, HoverContent>.Placement = .automatic,
        width: CGFloat? = nil,
        offset: CGPoint = CGPoint(x: 0, y: 10),
        showDelay: Double = 0.2,
        hideDelay: Double = 0.3,
        dismissible: Bool = true,
        @ViewBuilder hoverContent: @escaping () -> HoverContent
    ) -> some View {
        CTHoverCard(
            placement: placement,
            width: width,
            offset: offset,
            showDelay: showDelay,
            hideDelay: hideDelay,
            dismissible: dismissible,
            content: { self },
            hoverContent: hoverContent
        )
    }
}

// MARK: - Previews

struct CTHoverCard_Previews: PreviewProvider {
    static var previews: some View {
        HoverCardPreviewContainer()
    }
    
    struct HoverCardPreviewContainer: View {
        var body: some View {
            ScrollView {
                VStack(spacing: CTSpacing.xl) {
                    Text("Hover Card Examples").ctHeading2()
                    
                    // Basic example
                    VStack(spacing: CTSpacing.m) {
                        Text("Basic Hover Card").ctHeading3()
                        
                        Text("Long press me (on iOS) or hover over me (on macOS)")
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                            .ctHoverCard {
                                VStack(alignment: .leading, spacing: CTSpacing.s) {
                                    Text("Basic Hover Card").ctBodyBold()
                                    Text("This card appears when you interact with the text above.")
                                        .ctBody()
                                        .foregroundColor(.ctTextSecondary)
                                }
                            }
                    }
                    .padding()
                    
                    // Different placements
                    VStack(spacing: CTSpacing.m) {
                        Text("Placement Options").ctHeading3()
                        
                        HStack(spacing: CTSpacing.xl) {
                            // Top placement
                            Text("Top")
                                .padding()
                                .background(Color.ctBackground)
                                .cornerRadius(8)
                                .ctHoverCard(placement: .top) {
                                    Text("Top placement")
                                }
                            
                            // Bottom placement
                            Text("Bottom")
                                .padding()
                                .background(Color.ctBackground)
                                .cornerRadius(8)
                                .ctHoverCard(placement: .bottom) {
                                    Text("Bottom placement")
                                }
                        }
                        
                        HStack(spacing: CTSpacing.xl) {
                            // Leading placement
                            Text("Leading")
                                .padding()
                                .background(Color.ctBackground)
                                .cornerRadius(8)
                                .ctHoverCard(placement: .leading) {
                                    Text("Leading placement")
                                }
                            
                            // Trailing placement
                            Text("Trailing")
                                .padding()
                                .background(Color.ctBackground)
                                .cornerRadius(8)
                                .ctHoverCard(placement: .trailing) {
                                    Text("Trailing placement")
                                }
                        }
                    }
                    .padding()
                    
                    // Rich content example
                    VStack(spacing: CTSpacing.m) {
                        Text("Rich Content Example").ctHeading3()
                        
                        Text("User Profile")
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                            .ctHoverCard(width: 300) {
                                VStack(alignment: .leading, spacing: CTSpacing.m) {
                                    HStack {
                                        // Using an SF Symbol as a placeholder for a profile image
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.ctPrimary)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Jane Doe").ctBodyBold()
                                            Text("Product Designer").ctBodySmall()
                                                .foregroundColor(.ctTextSecondary)
                                        }
                                    }
                                    
                                    Text("Jane has been with the company for 3 years and specializes in UI/UX design for mobile applications.")
                                        .ctBody()
                                    
                                    HStack {
                                        Label("24 Projects", systemImage: "folder.fill")
                                            .ctBodySmall()
                                        
                                        Spacer()
                                        
                                        Label("156 Followers", systemImage: "person.2.fill")
                                            .ctBodySmall()
                                    }
                                    .foregroundColor(.ctTextSecondary)
                                    
                                    Button("View Full Profile") {
                                        print("View profile tapped")
                                    }
                                    .ctButtonSmall()
                                    .frame(maxWidth: .infinity)
                                }
                            }
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}