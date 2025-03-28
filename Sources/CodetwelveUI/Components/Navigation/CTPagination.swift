//
//  CTPagination.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable pagination component for navigating through pages of content.
///
/// `CTPagination` provides a consistent pagination interface with support for
/// different styles, sizes, and page navigation behaviors.
///
/// # Example
///
/// ```swift
/// CTPagination(
///     currentPage: $currentPage,
///     totalPages: 10,
///     style: .primary
/// )
///
/// // With custom page range and truncation
/// CTPagination(
///     currentPage: $currentPage,
///     totalPages: 20,
///     style: .secondary,
///     pageRange: 3
/// )
/// ```
public struct CTPagination: View {
    /// Pagination styles
    public enum PaginationStyle {
        /// Default primary style with standard appearance
        case primary
        /// Secondary style with alternative visual design
        case secondary
        /// Minimal style with reduced visual emphasis
        case minimal
        /// Custom style with specific color options
        case custom(Color)
    }
    
    /// Pagination size variants
    public enum PaginationSize {
        /// Small pagination size
        case small
        /// Medium pagination size (default)
        case medium
        /// Large pagination size
        case large
        
        /// Font size for the pagination
        var fontSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 14
            case .large: return 16
            }
        }
        
        /// Padding for pagination buttons
        var padding: EdgeInsets {
            switch self {
            case .small:
                return EdgeInsets(top: CTSpacing.xs, leading: CTSpacing.s, bottom: CTSpacing.xs, trailing: CTSpacing.s)
            case .medium:
                return EdgeInsets(top: CTSpacing.s, leading: CTSpacing.m, bottom: CTSpacing.s, trailing: CTSpacing.m)
            case .large:
                return EdgeInsets(top: CTSpacing.m, leading: CTSpacing.l, bottom: CTSpacing.m, trailing: CTSpacing.l)
            }
        }
    }
    
    // MARK: - Private Properties
    
    /// Binding to current page
    @Binding private var currentPage: Int
    
    /// Total number of pages
    private let totalPages: Int
    
    /// Pagination style
    private let style: PaginationStyle
    
    /// Pagination size
    private let size: PaginationSize
    
    /// Number of pages to show around the current page
    private let pageRange: Int
    
    /// Whether to show first and last page buttons
    private let showEdgeButtons: Bool
    
    /// Optional action when page changes
    private let onPageChange: ((Int) -> Void)?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new pagination component
    /// - Parameters:
    ///   - currentPage: Binding to the current page
    ///   - totalPages: Total number of pages
    ///   - style: Pagination style (default: .primary)
    ///   - size: Pagination size (default: .medium)
    ///   - pageRange: Number of pages to show around current page (default: 2)
    ///   - showEdgeButtons: Whether to show first and last page buttons (default: true)
    ///   - onPageChange: Optional callback when page changes
    public init(
        currentPage: Binding<Int>,
        totalPages: Int,
        style: PaginationStyle = .primary,
        size: PaginationSize = .medium,
        pageRange: Int = 2,
        showEdgeButtons: Bool = true,
        onPageChange: ((Int) -> Void)? = nil
    ) {
        self._currentPage = currentPage
        self.totalPages = max(1, totalPages)
        self.style = style
        self.size = size
        self.pageRange = max(0, pageRange)
        self.showEdgeButtons = showEdgeButtons
        self.onPageChange = onPageChange
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: CTSpacing.s) {
            // First page button
            if showEdgeButtons && currentPage > 1 {
                pageButton(page: 1, label: "First")
            }
            
            // Previous page button
            if currentPage > 1 {
                navigationButton(
                    systemName: "chevron.left",
                    isEnabled: currentPage > 1,
                    action: { changePage(to: currentPage - 1) }
                )
            }
            
            // Page buttons
            pageButtonGroup
            
            // Next page button
            if currentPage < totalPages {
                navigationButton(
                    systemName: "chevron.right",
                    isEnabled: currentPage < totalPages,
                    action: { changePage(to: currentPage + 1) }
                )
            }
            
            // Last page button
            if showEdgeButtons && currentPage < totalPages {
                pageButton(page: totalPages, label: "Last")
            }
        }
        .accessibilityLabel("Pagination. Page \(currentPage) of \(totalPages)")
    }
    
    // MARK: - Private Methods
    
    /// Generate page buttons around the current page
    private var pageButtonGroup: some View {
        Group {
            // First section with ellipsis
            if currentPage - pageRange > 1 {
                pageButton(page: 1)
                pageButton(label: "...")
            }
            
            // Page buttons around current page
            ForEach(visiblePages, id: \.self) { page in
                pageButton(page: page)
            }
            
            // Last section with ellipsis
            if currentPage + pageRange < totalPages {
                pageButton(label: "...")
                pageButton(page: totalPages)
            }
        }
    }
    
    /// Calculate visible pages around current page
    private var visiblePages: [Int] {
        let range = (max(1, currentPage - pageRange)...min(totalPages, currentPage + pageRange))
        return range.filter { $0 != 1 && $0 != totalPages }
    }
    
    /// Create a page button
    private func pageButton(page: Int? = nil, label: String? = nil) -> some View {
        Button(action: {
            if let page = page {
                changePage(to: page)
            }
        }) {
            Text(label ?? "\(page!)")
                .font(.system(size: size.fontSize, weight: page == currentPage ? .bold : .regular))
                .foregroundColor(pageButtonColor(for: page))
                .padding(size.padding)
                .background(pageButtonBackground(for: page))
                .cornerRadius(theme.borderRadius)
                .animation(.default, value: currentPage)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(page == currentPage)
        .accessibilityLabel(accessibilityLabel(for: page, label: label))
    }
    
    /// Create a navigation button (previous/next)
    private func navigationButton(
        systemName: String,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundColor(isEnabled ? buttonColor : .gray)
                .font(.system(size: size.fontSize))
                .padding(size.padding)
                .background(buttonBackgroundColor)
                .cornerRadius(theme.borderRadius)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .accessibilityLabel(systemName == "chevron.left" ? "Previous page" : "Next page")
    }
    
    /// Change the current page and trigger optional callback
    private func changePage(to page: Int) {
        guard page >= 1 && page <= totalPages else { return }
        currentPage = page
        onPageChange?(page)
    }
    
    /// Generate color for page buttons based on current state
    private func pageButtonColor(for page: Int?) -> Color {
        guard let page = page else { return buttonColor }
        
        if page == currentPage {
            switch style {
            case .primary: return .white
            case .secondary: return theme.primary
            case .minimal: return theme.primary
            case .custom(let color): return color
            }
        }
        
        return buttonColor
    }
    
    /// Generate background color for page buttons
    private func pageButtonBackground(for page: Int?) -> Color {
        guard let page = page else { return .clear }
        
        if page == currentPage {
            switch style {
            case .primary: return theme.primary
            case .secondary: return theme.primary.opacity(0.1)
            case .minimal: return .clear
            case .custom(let color): return color.opacity(0.1)
            }
        }
        
        return .clear
    }
    
    /// Accessibility label for pages
    private func accessibilityLabel(for page: Int?, label: String?) -> String {
        if let label = label {
            return label
        } else if let page = page {
            return page == currentPage ? "Current page \(page)" : "Go to page \(page)"
        }
        return ""
    }
    
    /// Button color based on style
    private var buttonColor: Color {
        switch style {
        case .primary: return theme.primary
        case .secondary: return theme.text
        case .minimal: return theme.text
        case .custom(let color): return color
        }
    }
    
    /// Button background color
    private var buttonBackgroundColor: Color {
        switch style {
        case .primary: return theme.primary.opacity(0.1)
        case .secondary: return .clear
        case .minimal: return .clear
        case .custom(let color): return color.opacity(0.1)
        }
    }
}

// MARK: - Previews

struct CTPagination_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            Group {
                PreviewContainer(label: "Primary Style") {
                    CTPagination(currentPage: .constant(5), totalPages: 10)
                }
                
                PreviewContainer(label: "Secondary Style") {
                    CTPagination(currentPage: .constant(5), totalPages: 10, style: .secondary)
                }
                
                PreviewContainer(label: "Minimal Style") {
                    CTPagination(currentPage: .constant(5), totalPages: 10, style: .minimal)
                }
                
                PreviewContainer(label: "Different Sizes") {
                    VStack(spacing: CTSpacing.m) {
                        CTPagination(currentPage: .constant(5), totalPages: 10, size: .small)
                        CTPagination(currentPage: .constant(5), totalPages: 10, size: .medium)
                        CTPagination(currentPage: .constant(5), totalPages: 10, size: .large)
                    }
                }
                
                PreviewContainer(label: "Page Range and Edge Buttons") {
                    CTPagination(
                        currentPage: .constant(5),
                        totalPages: 20,
                        pageRange: 3,
                        showEdgeButtons: false
                    )
                }
            }
        }
        .padding()
    }
    
    struct PreviewContainer<Content: View>: View {
        let label: String
        let content: Content
        
        init(label: String, @ViewBuilder content: () -> Content) {
            self.label = label
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(label).ctCaption()
                content
            }
        }
    }
}