//
//  CTScrollArea.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable scroll area component that extends ScrollView with additional features.
///
/// `CTScrollArea` provides an enhanced scrolling experience with customizable scrollbars,
/// padding, and improved accessibility.
///
/// # Example
///
/// ```swift
/// CTScrollArea(.vertical) {
///     VStack(spacing: CTSpacing.m) {
///         ForEach(0..<20) { index in
///             Text("Item \(index)")
///                 .padding()
///                 .frame(maxWidth: .infinity)
///                 .background(Color.ctSurface)
///                 .cornerRadius(8)
///         }
///     }
///     .padding()
/// }
/// ```
public struct CTScrollArea<Content: View>: View {
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let scrollBarStyle: CTScrollBarStyle
    private let scrollBarColor: Color?
    private let scrollBarWidth: CGFloat
    private let scrollBarPadding: EdgeInsets
    private let scrollPadding: EdgeInsets
    private let content: Content
    
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Creates a new scroll area with the specified axes and content.
    ///
    /// - Parameters:
    ///   - axes: The scroll axes to allow (default: .vertical).
    ///   - showsIndicators: Whether to show the scroll indicators (default: true).
    ///   - scrollBarStyle: The style of the scroll bars (default: .automatic).
    ///   - scrollBarColor: The color of the scroll bars (default: nil, uses theme border color).
    ///   - scrollBarWidth: The width of the scroll bars (default: 4).
    ///   - scrollBarPadding: The padding around the scroll bars (default: EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)).
    ///   - scrollPadding: The padding around the content (default: .zero).
    ///   - content: The content to display in the scroll area.
    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        scrollBarStyle: CTScrollBarStyle = .automatic,
        scrollBarColor: Color? = nil,
        scrollBarWidth: CGFloat = 4,
        scrollBarPadding: EdgeInsets = EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2),
        scrollPadding: EdgeInsets = EdgeInsets(),
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.scrollBarStyle = scrollBarStyle
        self.scrollBarColor = scrollBarColor
        self.scrollBarWidth = scrollBarWidth
        self.scrollBarPadding = scrollBarPadding
        self.scrollPadding = scrollPadding
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators && scrollBarStyle == .default) {
            content
                .padding(scrollPadding)
        }
        .scrollBarStyle(
            style: scrollBarStyle,
            color: scrollBarColor ?? theme.border,
            width: scrollBarWidth,
            padding: scrollBarPadding
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("CTScrollArea")
    }
}

// MARK: - Supporting Types

/// The style of scroll bars to use in a scroll area.
public enum CTScrollBarStyle {
    /// The default system scroll indicators.
    case `default`
    
    /// Custom styled scroll indicators.
    case custom
    
    /// Choose the appropriate scroll indicators based on the platform.
    case automatic
}

// MARK: - Extension for ScrollBarStyle

private extension View {
    /// Applies a custom scroll bar style to a ScrollView.
    ///
    /// - Parameters:
    ///   - style: The style of the scroll bars.
    ///   - color: The color of the scroll bars.
    ///   - width: The width of the scroll bars.
    ///   - padding: The padding around the scroll bars.
    /// - Returns: A View with the applied scroll bar style.
    @ViewBuilder
    func scrollBarStyle(style: CTScrollBarStyle, color: Color, width: CGFloat, padding: EdgeInsets) -> some View {
        if #available(iOS 16.0, *), style == .custom || (style == .automatic && UIDevice.current.userInterfaceIdiom == .pad) {
            self.scrollIndicators(.hidden)
                .modifier(ScrollViewIndicatorOverlay(
                    color: color,
                    width: width,
                    padding: padding
                ))
                .opacity(0.8)
        } else {
            self
        }
    }
}

/// A custom overlay that displays scroll indicators for a ScrollView.
private struct ScrollViewIndicatorOverlay: ViewModifier {
    @State private var scrollOffset: CGPoint = .zero
    @State private var contentSize: CGSize = .zero
    @State private var viewportSize: CGSize = .zero
    
    let color: Color
    let width: CGFloat
    let padding: EdgeInsets
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollViewSizePreferenceKey.self,
                        value: ScrollViewSizePreference(
                            contentSize: geometry.size,
                            viewportSize: geometry.frame(in: .global).size
                        )
                    )
                }
            )
            .onPreferenceChange(ScrollViewSizePreferenceKey.self) { preference in
                self.contentSize = preference.contentSize
                self.viewportSize = preference.viewportSize
            }
            .overlay(
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        // Horizontal scrollbar
                        if contentSize.width > viewportSize.width {
                            HStack {
                                Spacer()
                                
                                Rectangle()
                                    .fill(color)
                                    .frame(
                                        width: max(30, (viewportSize.width / contentSize.width) * viewportSize.width),
                                        height: width
                                    )
                                    .cornerRadius(width / 2)
                                    .offset(x: (scrollOffset.x / (contentSize.width - viewportSize.width)) * (viewportSize.width - (viewportSize.width / contentSize.width) * viewportSize.width))
                                    .padding(padding)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    // Vertical scrollbar
                    if contentSize.height > viewportSize.height {
                        VStack {
                            Rectangle()
                                .fill(color)
                                .frame(
                                    width: width,
                                    height: max(30, (viewportSize.height / contentSize.height) * viewportSize.height)
                                )
                                .cornerRadius(width / 2)
                                .offset(y: (scrollOffset.y / (contentSize.height - viewportSize.height)) * (viewportSize.height - (viewportSize.height / contentSize.height) * viewportSize.height))
                                .padding(padding)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Spacer()
                        }
                    }
                }
            )
    }
}

// MARK: - Preference Keys

private struct ScrollViewSizePreference: Equatable {
    let contentSize: CGSize
    let viewportSize: CGSize
}

private struct ScrollViewSizePreferenceKey: PreferenceKey {
    static var defaultValue: ScrollViewSizePreference = ScrollViewSizePreference(contentSize: .zero, viewportSize: .zero)
    
    static func reduce(value: inout ScrollViewSizePreference, nextValue: () -> ScrollViewSizePreference) {
        value = nextValue()
    }
}

// MARK: - Extensions

extension View {
    /// Applies a custom scroll area to a view with vertical scrolling.
    ///
    /// - Parameters:
    ///   - showsIndicators: Whether to show the scroll indicators.
    ///   - style: The style of the scroll bars.
    /// - Returns: A ScrollArea containing this view.
    public func ctScrollAreaVertical(
        showsIndicators: Bool = true,
        style: CTScrollBarStyle = .automatic
    ) -> some View {
        CTScrollArea(
            .vertical,
            showsIndicators: showsIndicators,
            scrollBarStyle: style,
            content: { self }
        )
    }
    
    /// Applies a custom scroll area to a view with horizontal scrolling.
    ///
    /// - Parameters:
    ///   - showsIndicators: Whether to show the scroll indicators.
    ///   - style: The style of the scroll bars.
    /// - Returns: A ScrollArea containing this view.
    public func ctScrollAreaHorizontal(
        showsIndicators: Bool = true,
        style: CTScrollBarStyle = .automatic
    ) -> some View {
        CTScrollArea(
            .horizontal,
            showsIndicators: showsIndicators,
            scrollBarStyle: style,
            content: { self }
        )
    }
}

// MARK: - Previews

struct CTScrollArea_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CTScrollArea(.vertical) {
                VStack(spacing: CTSpacing.m) {
                    ForEach(0..<20) { index in
                        Text("Item \(index)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.ctSurface)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .frame(height: 300)
            .background(Color.ctBackground)
            .cornerRadius(12)
            .previewDisplayName("Vertical Scroll Area")
            
            CTScrollArea(.horizontal, scrollBarStyle: .custom) {
                HStack(spacing: CTSpacing.m) {
                    ForEach(0..<20) { index in
                        Text("Item \(index)")
                            .padding()
                            .frame(width: 150, height: 100)
                            .background(Color.ctSurface)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .frame(height: 150)
            .background(Color.ctBackground)
            .cornerRadius(12)
            .previewDisplayName("Horizontal Scroll Area with Custom Scrollbar")
        }
        .padding()
    }
}