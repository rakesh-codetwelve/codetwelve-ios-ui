//
//  CTCarousel.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI
import Combine

/// A customizable carousel component for displaying multiple items in a slideshow format.
///
/// `CTCarousel` provides a consistent carousel interface throughout your application
/// with support for different styles, auto-advancing, indicators, and navigation controls.
///
/// # Example
///
/// ```swift
/// // Simple carousel with images
/// CTCarousel(
///     items: [Image("slide1"), Image("slide2"), Image("slide3")],
///     itemContent: { image in
///         image
///             .resizable()
///             .aspectRatio(contentMode: .fill)
///     }
/// )
///
/// // Custom content carousel with auto-advance
/// CTCarousel(
///     items: ["First", "Second", "Third"],
///     itemContent: { text in
///         Text(text)
///             .font(.largeTitle)
///             .frame(maxWidth: .infinity, maxHeight: .infinity)
///             .background(Color.blue.opacity(0.2))
///     },
///     autoAdvance: true,
///     autoAdvanceInterval: 3.0
/// )
/// ```
public struct CTCarousel<Item, Content: View>: View {
    // MARK: - Public Properties
    
    /// The style of the carousel
    public enum Style: Equatable {
        /// Default style with standard appearance
        case `default`
        
        /// Modern style with enhanced visual effects
        case modern
        
        /// Minimal style with reduced visual elements
        case minimal
        
        /// Cards style with visible adjacent cards
        case cards
        
        /// Custom style with specific configuration
        case custom(
            backgroundColor: Color,
            cornerRadius: CGFloat,
            shadowRadius: CGFloat,
            shadowOpacity: Double,
            indicatorActiveColor: Color,
            indicatorInactiveColor: Color
        )
        
        /// Get the background color for a given theme
        func getBackgroundColor(for theme: CTTheme) -> Color {
            switch self {
            case .default, .modern, .minimal, .cards:
                return theme.surface
            case .custom(let backgroundColor, _, _, _, _, _):
                return backgroundColor
            }
        }
        
        /// Get the corner radius for a given theme
        func getCornerRadius(for theme: CTTheme) -> CGFloat {
            switch self {
            case .default:
                return theme.borderRadius
            case .modern:
                return theme.borderRadius * 1.5
            case .minimal:
                return theme.borderRadius / 2
            case .cards:
                return theme.borderRadius * 2
            case .custom(_, let customRadius, _, _, _, _):
                return customRadius
            }
        }
        
        /// Get the shadow radius for a given theme
        func getShadowRadius(for theme: CTTheme) -> CGFloat {
            switch self {
            case .default:
                return 4
            case .modern:
                return 8
            case .minimal:
                return 2
            case .cards:
                return 6
            case .custom(_, _, let customShadowRadius, _, _, _):
                return customShadowRadius
            }
        }
        
        /// Get the shadow opacity for a given theme
        func getShadowOpacity(for theme: CTTheme) -> Double {
            switch self {
            case .default:
                return 0.1
            case .modern:
                return 0.15
            case .minimal:
                return 0.05
            case .cards:
                return 0.12
            case .custom(_, _, _, let customShadowOpacity, _, _):
                return customShadowOpacity
            }
        }
        
        /// Get the active indicator color for a given theme
        func getIndicatorActiveColor(for theme: CTTheme) -> Color {
            switch self {
            case .default, .modern, .cards:
                return theme.primary
            case .minimal:
                return theme.text.opacity(0.8)
            case .custom(_, _, _, _, let activeColor, _):
                return activeColor
            }
        }
        
        /// Get the inactive indicator color for a given theme
        func getIndicatorInactiveColor(for theme: CTTheme) -> Color {
            switch self {
            case .default, .modern, .cards:
                return theme.border
            case .minimal:
                return theme.text.opacity(0.2)
            case .custom(_, _, _, _, _, let inactiveColor):
                return inactiveColor
            }
        }
    }
    
    /// The size of the carousel
    public enum Size {
        /// Automatic size based on content
        case auto
        
        /// Square aspect ratio (1:1)
        case square
        
        /// Standard aspect ratio (4:3)
        case standard
        
        /// Widescreen aspect ratio (16:9)
        case widescreen
        
        /// Custom aspect ratio or fixed height
        case custom(aspectRatio: CGFloat?, height: CGFloat?)
        
        /// The aspect ratio value
        var aspectRatio: CGFloat? {
            switch self {
            case .square:
                return 1.0
            case .standard:
                return 4.0/3.0
            case .widescreen:
                return 16.0/9.0
            case .custom(let ratio, _):
                return ratio
            case .auto:
                return nil
            }
        }
        
        /// The fixed height value
        var height: CGFloat? {
            switch self {
            case .custom(_, let height):
                return height
            default:
                return nil
            }
        }
    }
    
    /// The position of the indicators
    public enum IndicatorPosition {
        /// Indicators at the bottom of the carousel
        case bottom
        
        /// Indicators at the top of the carousel
        case top
        
        /// No indicators shown
        case none
    }
    
    /// The position of the navigation buttons
    public enum NavigationPosition {
        /// Navigation buttons at the sides of the carousel
        case sides
        
        /// Navigation buttons overlaying the carousel content
        case overlay
        
        /// No navigation buttons shown
        case none
    }
    
    // MARK: - Private Properties
    
    /// The items to display in the carousel
    private let items: [Item]
    
    /// A closure that produces a view for each item
    private let itemContent: (Item) -> Content
    
    /// The visual style of the carousel
    private let style: Style
    
    /// The size configuration of the carousel
    private let size: Size
    
    /// Whether to show indicators
    private let indicatorPosition: IndicatorPosition
    
    /// Whether to show navigation buttons
    private let navigationPosition: NavigationPosition
    
    /// Whether to auto-advance the carousel
    private let autoAdvance: Bool
    
    /// The interval for auto-advancing in seconds
    private let autoAdvanceInterval: TimeInterval
    
    /// Whether the carousel should loop
    private let infiniteScroll: Bool
    
    /// Whether the carousel should bounce at the edges when not infinite
    private let bounces: Bool
    
    /// The spacing between cards when using cards style
    private let cardSpacing: CGFloat
    
    /// The scale factor for adjacent cards when using cards style
    private let adjacentCardScale: CGFloat
    
    /// The current index of the displayed item
    @Binding private var currentIndex: Int
    
    /// Whether the carousel is currently being dragged
    @State private var dragging: Bool = false
    
    /// The current drag offset
    @State private var dragOffset: CGFloat = 0
    
    /// The width of the carousel
    @State private var carouselWidth: CGFloat = 0
    
    /// Timer for auto-advancing
    @State private var autoAdvanceTimer: AnyCancellable?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new carousel with the specified items and content
    ///
    /// - Parameters:
    ///   - items: The items to display in the carousel
    ///   - currentIndex: Binding to track/control the current item index
    ///   - style: The visual style of the carousel
    ///   - size: The size configuration of the carousel
    ///   - indicatorPosition: The position of the indicators
    ///   - navigationPosition: The position of the navigation buttons
    ///   - autoAdvance: Whether to auto-advance the carousel
    ///   - autoAdvanceInterval: The interval for auto-advancing in seconds
    ///   - infiniteScroll: Whether the carousel should loop
    ///   - bounces: Whether the carousel should bounce at the edges when not infinite
    ///   - cardSpacing: The spacing between cards when using cards style
    ///   - adjacentCardScale: The scale factor for adjacent cards when using cards style
    ///   - itemContent: A closure that produces a view for each item
    public init(
        items: [Item],
        currentIndex: Binding<Int> = .constant(0),
        style: Style = .default,
        size: Size = .auto,
        indicatorPosition: IndicatorPosition = .bottom,
        navigationPosition: NavigationPosition = .overlay,
        autoAdvance: Bool = false,
        autoAdvanceInterval: TimeInterval = 5.0,
        infiniteScroll: Bool = false,
        bounces: Bool = true,
        cardSpacing: CGFloat = 10,
        adjacentCardScale: CGFloat = 0.85,
        @ViewBuilder itemContent: @escaping (Item) -> Content
    ) {
        self.items = items
        self._currentIndex = currentIndex
        self.style = style
        self.size = size
        self.indicatorPosition = indicatorPosition
        self.navigationPosition = navigationPosition
        self.autoAdvance = autoAdvance
        self.autoAdvanceInterval = autoAdvanceInterval
        self.infiniteScroll = infiniteScroll
        self.bounces = bounces
        self.cardSpacing = cardSpacing
        self.adjacentCardScale = adjacentCardScale
        self.itemContent = itemContent
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top indicators if needed
                if indicatorPosition == .top {
                    pageIndicators
                        .padding(.bottom, CTSpacing.s)
                }
                
                // Main carousel content
                carouselContent(in: geometry)
                
                // Bottom indicators if needed
                if indicatorPosition == .bottom {
                    pageIndicators
                        .padding(.top, CTSpacing.s)
                }
            }
            .onAppear {
                carouselWidth = geometry.size.width
                setupAutoAdvanceTimer()
            }
            .onChange(of: geometry.size.width) { newWidth in
                carouselWidth = newWidth
            }
            .onChange(of: autoAdvance) { isAutoAdvancing in
                if isAutoAdvancing {
                    setupAutoAdvanceTimer()
                } else {
                    autoAdvanceTimer?.cancel()
                }
            }
            .onChange(of: dragging) { isDragging in
                // Pause auto-advance while dragging
                if isDragging {
                    autoAdvanceTimer?.cancel()
                } else if autoAdvance {
                    setupAutoAdvanceTimer()
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Carousel with \(items.count) items")
        }
        .aspectRatio(size.aspectRatio, contentMode: .fit)
        .frame(height: size.height)
    }
    
    // MARK: - Private Views
    
    /// Build the main carousel content
    /// - Parameter geometry: The geometry proxy for size calculations
    /// - Returns: The carousel content view
    private func carouselContent(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        
        return ZStack {
            // Main content
            if style == .cards {
                // Cards style with visible adjacent cards
                cardsStyleCarousel(width: width)
            } else {
                // Standard full-width carousel
                standardCarousel(width: width)
            }
            
            // Navigation buttons if needed
            if navigationPosition != .none && items.count > 1 {
                HStack {
                    // Previous button
                    if navigationPosition == .sides || currentIndex > 0 || infiniteScroll {
                        navigationButton(direction: .previous)
                    }
                    
                    Spacer()
                    
                    // Next button
                    if navigationPosition == .sides || currentIndex < items.count - 1 || infiniteScroll {
                        navigationButton(direction: .next)
                    }
                }
                .padding(.horizontal, navigationPosition == .sides ? 0 : CTSpacing.m)
            }
        }
    }
    
    /// Build a standard full-width carousel
    /// - Parameter width: The width of the carousel
    /// - Returns: The standard carousel view
    private func standardCarousel(width: CGFloat) -> some View {
        let itemCount = items.count
        let offset = CGFloat(currentIndex) * width
        
        return HStack(spacing: 0) {
            ForEach(0..<itemCount, id: \.self) { index in
                itemContent(items[index])
                    .frame(width: width)
                    .clipped()
            }
        }
        .offset(x: -offset + dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragging = true
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    dragging = false
                    let predictedEnd = value.predictedEndTranslation.width
                    let dragThreshold = width / 3
                    
                    withAnimation(CTAnimation.slideIn) {
                        if predictedEnd < -dragThreshold && (currentIndex < itemCount - 1 || infiniteScroll) {
                            // Swipe left
                            nextItem()
                        } else if predictedEnd > dragThreshold && (currentIndex > 0 || infiniteScroll) {
                            // Swipe right
                            previousItem()
                        }
                        
                        // Reset drag offset
                        dragOffset = 0
                    }
                }
        )
    }
    
    /// Build a cards-style carousel with visible adjacent cards
    /// - Parameter width: The width of the carousel
    /// - Returns: The cards-style carousel view
    private func cardsStyleCarousel(width: CGFloat) -> some View {
        let cardWidth = width * 0.8
        let sideInset = (width - cardWidth) / 2
        
        return ZStack {
            ForEach(0..<items.count, id: \.self) { index in
                let isCurrentIndex = index == currentIndex
                let distance = abs(CGFloat(index - currentIndex))
                
                itemContent(items[index])
                    .frame(width: cardWidth)
                    .scaleEffect(isCurrentIndex ? 1.0 : adjacentCardScale)
                    .opacity(distance <= 1 ? 1.0 : 0.0)
                    .zIndex(isCurrentIndex ? 1 : 0)
                    .offset(x: calculateCardOffset(for: index, cardWidth: cardWidth, sideInset: sideInset))
                    .animation(CTAnimation.slideIn, value: currentIndex)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragging = true
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    dragging = false
                    let predictedEnd = value.predictedEndTranslation.width
                    let dragThreshold = cardWidth / 3
                    
                    withAnimation(CTAnimation.slideIn) {
                        if predictedEnd < -dragThreshold && (currentIndex < items.count - 1 || infiniteScroll) {
                            // Swipe left
                            nextItem()
                        } else if predictedEnd > dragThreshold && (currentIndex > 0 || infiniteScroll) {
                            // Swipe right
                            previousItem()
                        }
                        
                        // Reset drag offset
                        dragOffset = 0
                    }
                }
        )
    }
    
    /// Calculate the offset for a card in the cards-style carousel
    /// - Parameters:
    ///   - index: The index of the card
    ///   - cardWidth: The width of each card
    ///   - sideInset: The inset from the sides of the carousel
    /// - Returns: The horizontal offset for the card
    private func calculateCardOffset(for index: Int, cardWidth: CGFloat, sideInset: CGFloat) -> CGFloat {
        let baseOffset = CGFloat(index - currentIndex) * (cardWidth + cardSpacing)
        return baseOffset + dragOffset
    }
    
    /// The page indicators view
    private var pageIndicators: some View {
        Group {
            if items.count > 1 {
                HStack(spacing: CTSpacing.xs) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? 
                                style.getIndicatorActiveColor(for: theme) : 
                                style.getIndicatorInactiveColor(for: theme))
                            .frame(width: 8, height: 8)
                            .onTapGesture {
                                withAnimation(CTAnimation.slideIn) {
                                    currentIndex = index
                                }
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("Page \(index + 1) of \(items.count)")
                            .accessibilityAddTraits(index == currentIndex ? [.isSelected] : [])
                            .accessibilityHint("Double tap to go to page \(index + 1)")
                    }
                }
                .padding(.vertical, CTSpacing.xs)
            }
        }
    }
    
    /// Navigation direction enum
    private enum NavigationDirection {
        case previous
        case next
    }
    
    /// Create a navigation button for the carousel
    /// - Parameter direction: The direction of the navigation button
    /// - Returns: A navigation button view
    private func navigationButton(direction: NavigationDirection) -> some View {
        let iconName = direction == .previous ? "chevron.left" : "chevron.right"
        let action = direction == .previous ? previousItem : nextItem
        let label = direction == .previous ? "Previous" : "Next"
        
        return Button(action: {
            withAnimation(CTAnimation.slideIn) {
                action()
            }
        }) {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(8)
                .background(Circle().fill(Color.black.opacity(0.5)))
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
        .accessibilityLabel(label)
    }
    
    // MARK: - Private Methods
    
    /// Move to the next item in the carousel
    private func nextItem() {
        if currentIndex < items.count - 1 {
            currentIndex += 1
        } else if infiniteScroll {
            currentIndex = 0
        }
    }
    
    /// Move to the previous item in the carousel
    private func previousItem() {
        if currentIndex > 0 {
            currentIndex -= 1
        } else if infiniteScroll {
            currentIndex = items.count - 1
        }
    }
    
    /// Set up the auto-advance timer
    private func setupAutoAdvanceTimer() {
        guard autoAdvance, items.count > 1 else { return }
        
        autoAdvanceTimer?.cancel()
        
        autoAdvanceTimer = Timer.publish(every: autoAdvanceInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation(CTAnimation.slideIn) {
                    if currentIndex < items.count - 1 {
                        currentIndex += 1
                    } else if infiniteScroll {
                        currentIndex = 0
                    }
                }
            }
    }
    
    // MARK: - Private Computed Properties
    
    /// The active indicator color based on the carousel style and theme
    private var indicatorActiveColor: Color {
        switch style {
        case .default, .modern, .cards:
            return theme.primary
        case .minimal:
            return theme.text.opacity(0.8)
        case .custom(_, _, _, _, let activeColor, _):
            return activeColor
        }
    }
    
    /// The inactive indicator color based on the carousel style and theme
    private var indicatorInactiveColor: Color {
        switch style {
        case .default, .modern, .cards:
            return theme.border
        case .minimal:
            return theme.text.opacity(0.2)
        case .custom(_, _, _, _, _, let inactiveColor):
            return inactiveColor
        }
    }
}

// MARK: - Previews

struct CTCarousel_Previews: PreviewProvider {
    struct PreviewItem: Identifiable {
        let id = UUID()
        let color: Color
        let title: String
    }
    
    static let previewItems = [
        PreviewItem(color: .blue, title: "First Slide"),
        PreviewItem(color: .green, title: "Second Slide"),
        PreviewItem(color: .orange, title: "Third Slide"),
        PreviewItem(color: .purple, title: "Fourth Slide")
    ]
    
    static var previews: some View {
        Group {
            // Default style
            CTCarousel(items: previewItems) { item in
                ZStack {
                    Rectangle()
                        .fill(item.color.opacity(0.3))
                    Text(item.title)
                        .ctHeading1()
                }
            }
            .padding()
            .frame(height: 200)
            .previewDisplayName("Default Style")
            
            // Cards style
            CTCarousel(
                items: previewItems,
                style: .cards,
                navigationPosition: .sides
            ) { item in
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(item.color.opacity(0.3))
                    Text(item.title)
                        .ctHeading1()
                }
            }
            .padding()
            .frame(height: 200)
            .previewDisplayName("Cards Style")
            
            // Minimal style with auto-advance
            CTCarousel(
                items: previewItems,
                style: .minimal,
                size: .standard,
                autoAdvance: true,
                autoAdvanceInterval: 2.0,
                infiniteScroll: true
            ) { item in
                ZStack {
                    Rectangle()
                        .fill(item.color.opacity(0.3))
                    Text(item.title)
                        .ctHeading1()
                }
            }
            .padding()
            .previewDisplayName("Minimal Style with Auto-Advance")
            
            // Custom style
            CTCarousel(
                items: previewItems,
                style: .custom(
                    backgroundColor: .white,
                    cornerRadius: 12,
                    shadowRadius: 8,
                    shadowOpacity: 0.15,
                    indicatorActiveColor: .red,
                    indicatorInactiveColor: .gray.opacity(0.3)
                ),
                size: .widescreen,
                indicatorPosition: .top,
                navigationPosition: .overlay
            ) { item in
                ZStack {
                    Rectangle()
                        .fill(item.color.opacity(0.3))
                    Text(item.title)
                        .ctHeading1()
                }
            }
            .padding()
            .previewDisplayName("Custom Style")
            
            // Image carousel
            CTCarousel(
                items: [
                    "photo",
                    "photo.fill",
                    "photo.on.rectangle",
                    "photo.on.rectangle.angled"
                ]
            ) { systemName in
                ZStack {
                    Color.ctSecondary.opacity(0.2)
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(CTSpacing.xl)
                        .foregroundColor(.ctPrimary)
                }
            }
            .padding()
            .frame(height: 200)
            .previewDisplayName("Image Carousel")
        }
    }
}