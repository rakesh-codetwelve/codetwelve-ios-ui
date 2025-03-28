//
//  CTAccordion.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// An accordion component that can expand and collapse to show or hide content.
///
/// The `CTAccordion` component allows users to toggle between showing and hiding content,
/// making it ideal for sections that don't need to be visible at all times.
///
/// # Example
///
/// ```swift
/// CTAccordion(
///     label: "Section Title",
///     content: {
///         Text("This is the expandable content that will be shown when the accordion is expanded.")
///             .padding()
///     }
/// )
/// ```
///
/// You can also create a multi-section accordion:
///
/// ```swift
/// VStack(spacing: 0) {
///     CTAccordion(label: "Section 1") {
///         Text("Content for section 1")
///     }
///     CTAccordion(label: "Section 2") {
///         Text("Content for section 2")
///     }
///     CTAccordion(label: "Section 3") {
///         Text("Content for section 3")
///     }
/// }
/// ```
public struct CTAccordion<Content: View, HeaderContent: View>: View {
    // MARK: - Public Properties
    
    /// The header content to display
    private let headerContent: HeaderContent
    
    /// The label text when using string-based initializer
    private let label: String?
    
    /// The content to display when expanded
    private let content: Content
    
    /// The style of the accordion
    private let style: CTAccordionStyle
    
    /// Whether the accordion is initially expanded
    private let initiallyExpanded: Bool
    
    /// Whether the animation should be enabled
    private let animated: Bool
    
    /// Whether multiple items can be expanded at once
    private let allowMultipleExpanded: Bool
    
    /// Optional ID for accordion groups
    private let groupID: String?
    
    /// Whether to show a chevron icon in the header
    private let showChevron: Bool
    
    /// Custom padding for the content area
    private let contentPadding: EdgeInsets?
    
    // MARK: - Private Properties
    
    /// The current state of expansion
    @State private var isExpanded: Bool
    
    /// The height of the content
    @State private var contentHeight: CGFloat = 0
    
    /// The expanded state from the parent accordion group
    @Environment(\.ctAccordionGroupExpanded) private var groupExpanded
    
    /// The accordion group controller
    @Environment(\.ctAccordionGroupController) private var groupController
    
    /// Access to the theme
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize with a string label and content
    /// - Parameters:
    ///   - label: The label text to display in the header
    ///   - style: The style of the accordion
    ///   - initiallyExpanded: Whether the accordion is initially expanded
    ///   - animated: Whether the animation should be enabled
    ///   - allowMultipleExpanded: Whether multiple items can be expanded at once
    ///   - groupID: Optional group ID for accordion groups
    ///   - showChevron: Whether to show a chevron icon in the header
    ///   - contentPadding: Custom padding for the content area
    ///   - content: A view builder returning the content to display when expanded
    public init(
        label: String,
        style: CTAccordionStyle = .default,
        initiallyExpanded: Bool = false,
        animated: Bool = true,
        allowMultipleExpanded: Bool = true,
        groupID: String? = nil,
        showChevron: Bool = true,
        contentPadding: EdgeInsets? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) where HeaderContent == Text {
        self.headerContent = Text(label)
        self.label = label
        self.content = content()
        self.style = style
        self.initiallyExpanded = initiallyExpanded
        self.animated = animated
        self.allowMultipleExpanded = allowMultipleExpanded
        self.groupID = groupID
        self.showChevron = showChevron
        self.contentPadding = contentPadding
        self._isExpanded = State(initialValue: initiallyExpanded)
    }
    
    /// Initialize with a custom header view and content
    /// - Parameters:
    ///   - style: The style of the accordion
    ///   - initiallyExpanded: Whether the accordion is initially expanded
    ///   - animated: Whether the animation should be enabled
    ///   - allowMultipleExpanded: Whether multiple items can be expanded at once
    ///   - groupID: Optional group ID for accordion groups
    ///   - showChevron: Whether to show a chevron icon in the header
    ///   - contentPadding: Custom padding for the content area
    ///   - headerContent: A view builder returning the header content
    ///   - content: A view builder returning the content to display when expanded
    public init(
        style: CTAccordionStyle = .default,
        initiallyExpanded: Bool = false,
        animated: Bool = true,
        allowMultipleExpanded: Bool = true,
        groupID: String? = nil,
        showChevron: Bool = true,
        contentPadding: EdgeInsets? = nil,
        @ViewBuilder headerContent: @escaping () -> HeaderContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.headerContent = headerContent()
        self.label = nil
        self.content = content()
        self.style = style
        self.initiallyExpanded = initiallyExpanded
        self.animated = animated
        self.allowMultipleExpanded = allowMultipleExpanded
        self.groupID = groupID
        self.showChevron = showChevron
        self.contentPadding = contentPadding
        self._isExpanded = State(initialValue: initiallyExpanded)
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
                .contentShape(Rectangle())
                .onTapGesture(perform: toggleExpanded)
            
            // Content
            contentView
        }
        .onChange(of: groupExpanded) { newValue in
            if let groupID = groupID, let expandedID = newValue, groupID == expandedID {
                if !isExpanded {
                    withAnimation(animated ? CTAnimation.expand : .none) {
                        isExpanded = true
                    }
                }
            } else if isExpanded && !allowMultipleExpanded {
                withAnimation(animated ? CTAnimation.contract : .none) {
                    isExpanded = false
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Double tap to \(isExpanded ? "collapse" : "expand")")
        .accessibilityAddTraits(.isButton)
    }
    
    // MARK: - Private Views
    
    /// The header view containing the title and chevron
    private var headerView: some View {
        HStack {
            headerContent
                .font(style.font)
                .foregroundColor(style.headerColor(for: theme))
            
            Spacer()
            
            if showChevron {
                chevronIcon
            }
        }
        .padding(style.headerPadding)
        .background(style.headerBackgroundColor(for: theme))
        .cornerRadius(style.cornerRadius)
    }
    
    /// The content view that expands and collapses
    private var contentView: some View {
        VStack(spacing: 0) {
            if isExpanded {
                content
                    .padding(contentPadding ?? style.contentPadding)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(animated ? CTAnimation.expand : .none, value: isExpanded)
            }
        }
        .clipped()
    }
    
    /// The chevron icon that rotates based on expansion state
    private var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(style.headerColor(for: theme))
            .rotationEffect(.degrees(isExpanded ? 90 : 0))
            .animation(animated ? CTAnimation.easeInOut : .none, value: isExpanded)
    }
    
    // MARK: - Private Methods
    
    /// Toggle the expanded state of the accordion
    private func toggleExpanded() {
        if !isExpanded || allowMultipleExpanded {
            if let groupID = groupID, !allowMultipleExpanded {
                groupController?.setExpandedAccordion(id: groupID)
            }
            
            withAnimation(animated ? CTAnimation.expand : .none) {
                isExpanded.toggle()
            }
        } else if isExpanded {
            withAnimation(animated ? CTAnimation.contract : .none) {
                isExpanded = false
            }
        }
    }
    
    /// Generate an accessibility label for the accordion
    private var accessibilityLabel: String {
        if let label = label {
            return "Accordion \(label), \(isExpanded ? "expanded" : "collapsed")"
        }
        return "Accordion, \(isExpanded ? "expanded" : "collapsed")"
    }
}

// MARK: - Supporting Types

/// The style of the accordion
public enum CTAccordionStyle {
    /// The default style
    case `default`
    
    /// A bordered style
    case bordered
    
    /// A filled style
    case filled
    
    /// A subtle style
    case subtle
    
    /// A custom style
    case custom(
        headerColor: Color?,
        chevronColor: Color?,
        headerBackgroundColor: Color?,
        contentBackgroundColor: Color?,
        headerPadding: EdgeInsets,
        contentPadding: EdgeInsets,
        cornerRadius: CGFloat,
        font: Font
    )
    
    /// The header text color
    func headerColor(for theme: CTTheme) -> Color {
        switch self {
        case .default, .bordered, .subtle:
            return theme.text
        case .filled:
            return theme.textOnAccent
        case .custom(let headerColor, _, _, _, _, _, _, _):
            return headerColor ?? theme.text
        }
    }
    
    /// The chevron color
    func chevronColor(for theme: CTTheme) -> Color {
        switch self {
        case .default, .bordered, .subtle:
            return theme.textSecondary
        case .filled:
            return theme.textOnAccent.opacity(0.7)
        case .custom(_, let chevronColor, _, _, _, _, _, _):
            return chevronColor ?? theme.textSecondary
        }
    }
    
    /// The header background color
    func headerBackgroundColor(for theme: CTTheme) -> Color {
        switch self {
        case .default, .subtle:
            return Color.clear
        case .bordered:
            return theme.surface
        case .filled:
            return theme.primary
        case .custom(_, _, let headerBackgroundColor, _, _, _, _, _):
            return headerBackgroundColor ?? Color.clear
        }
    }
    
    /// The content background color
    func contentBackgroundColor(for theme: CTTheme) -> Color {
        switch self {
        case .default:
            return Color.clear
        case .bordered, .filled:
            return theme.surface
        case .subtle:
            return theme.surface.opacity(0.5)
        case .custom(_, _, _, let contentBackgroundColor, _, _, _, _):
            return contentBackgroundColor ?? Color.clear
        }
    }
    
    /// The header padding
    var headerPadding: EdgeInsets {
        switch self {
        case .default, .subtle:
            return EdgeInsets(top: CTSpacing.s, leading: CTSpacing.s, bottom: CTSpacing.s, trailing: CTSpacing.s)
        case .bordered, .filled:
            return EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m)
        case .custom(_, _, _, _, let headerPadding, _, _, _):
            return headerPadding
        }
    }
    
    /// The content padding
    var contentPadding: EdgeInsets {
        switch self {
        case .default, .subtle:
            return EdgeInsets(top: CTSpacing.xs, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m)
        case .bordered, .filled:
            return EdgeInsets(top: CTSpacing.s, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m)
        case .custom(_, _, _, _, _, let contentPadding, _, _):
            return contentPadding
        }
    }
    
    /// The corner radius
    var cornerRadius: CGFloat {
        switch self {
        case .default, .subtle:
            return 0
        case .bordered, .filled:
            return 8
        case .custom(_, _, _, _, _, _, let cornerRadius, _):
            return cornerRadius
        }
    }
    
    /// The font for the header
    var font: Font {
        switch self {
        case .default, .bordered, .subtle, .filled:
            return CTTypography.subtitle()
        case .custom(_, _, _, _, _, _, _, let font):
            return font
        }
    }
}

// MARK: - Accordion Group Environment Keys

/// The accordion group expanded key
struct AccordionGroupExpandedKey: EnvironmentKey {
    static let defaultValue: String? = nil
}

/// The accordion group controller key
struct AccordionGroupControllerKey: EnvironmentKey {
    static let defaultValue: AccordionGroupController? = nil
}

/// Environment values extension for accordion group
public extension EnvironmentValues {
    /// The ID of the currently expanded accordion in a group
    var ctAccordionGroupExpanded: String? {
        get { self[AccordionGroupExpandedKey.self] }
        set { self[AccordionGroupExpandedKey.self] = newValue }
    }
    
    /// The accordion group controller
    var ctAccordionGroupController: AccordionGroupController? {
        get { self[AccordionGroupControllerKey.self] }
        set { self[AccordionGroupControllerKey.self] = newValue }
    }
}

/// The accordion group controller class
public class AccordionGroupController: ObservableObject {
    /// The ID of the currently expanded accordion
    @Published public var expandedAccordionID: String?
    
    /// Initialize the controller
    public init(initialExpandedID: String? = nil) {
        self.expandedAccordionID = initialExpandedID
    }
    
    /// Set the expanded accordion by ID
    /// - Parameter id: The ID of the accordion to expand
    public func setExpandedAccordion(id: String) {
        if expandedAccordionID != id {
            expandedAccordionID = id
        }
    }
    
    /// Collapse all accordions
    public func collapseAll() {
        expandedAccordionID = nil
    }
}

/// A container for a group of accordions
public struct CTAccordionGroup<Content: View>: View {
    /// The content containing the accordions
    private let content: Content
    
    /// The controller for managing the group
    @StateObject private var controller: AccordionGroupController
    
    /// Initialize with content
    /// - Parameters:
    ///   - initialExpandedID: The ID of the initially expanded accordion
    ///   - content: A view builder returning the accordions
    public init(initialExpandedID: String? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._controller = StateObject(wrappedValue: AccordionGroupController(initialExpandedID: initialExpandedID))
    }
    
    public var body: some View {
        content
            .environment(\.ctAccordionGroupController, controller)
            .environment(\.ctAccordionGroupExpanded, controller.expandedAccordionID)
    }
}

// MARK: - Previews

struct CTAccordion_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            CTAccordion(label: "Default Style") {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("This is the content of the default style accordion.")
                    Text("It can contain any type of view.")
                    CTButton("A Button") {}
                }
            }
            
            CTAccordion(label: "Bordered Style", style: .bordered) {
                Text("This is the content of the bordered style accordion.")
            }
            
            CTAccordion(label: "Filled Style", style: .filled) {
                Text("This is the content of the filled style accordion.")
            }
            
            CTAccordion(label: "Subtle Style", style: .subtle) {
                Text("This is the content of the subtle style accordion.")
            }
            
            CTAccordion(
                style: .custom(
                    headerColor: .purple,
                    chevronColor: .orange,
                    headerBackgroundColor: .yellow.opacity(0.2),
                    contentBackgroundColor: .green.opacity(0.1),
                    headerPadding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
                    contentPadding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
                    cornerRadius: 12,
                    font: .title3.bold()
                ),
                headerContent: {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        Text("Custom Header")
                            .foregroundColor(.purple)
                    }
                },
                content: {
                    Text("This is a completely custom accordion.")
                }
            )
            
            Text("Accordion Group Example").font(.headline).padding(.top)
            
            CTAccordionGroup {
                CTAccordion(
                    label: "Section 1",
                    style: .bordered,
                    groupID: "section1",
                    showChevron: true
                ) {
                    Text("Content for section 1")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                CTAccordion(
                    label: "Section 2",
                    style: .bordered,
                    groupID: "section2",
                    showChevron: true
                ) {
                    Text("Content for section 2")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                CTAccordion(
                    label: "Section 3",
                    style: .bordered,
                    groupID: "section3",
                    showChevron: true
                ) {
                    Text("Content for section 3")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
