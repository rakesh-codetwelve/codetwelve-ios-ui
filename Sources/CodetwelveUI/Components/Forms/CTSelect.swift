//
//  CTSelect.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable dropdown selection component.
///
/// `CTSelect` provides a dropdown menu for selecting an option from a list of choices.
/// It supports various styles, sizes, and customization options.
///
/// # Example
///
/// ```swift
/// @State private var selectedOption = "apple"
/// let options = ["apple": "Apple", "orange": "Orange", "banana": "Banana"]
///
/// CTSelect(
///     "Favorite Fruit",
///     options: options,
///     selection: $selectedOption
/// )
/// ```
///
/// With icons:
///
/// ```swift
/// let optionsWithIcons = [
///     "apple": CTSelectOption(label: "Apple", icon: "leaf"),
///     "orange": CTSelectOption(label: "Orange", icon: "circle.fill"),
///     "banana": CTSelectOption(label: "Banana", icon: "star")
/// ]
///
/// CTSelect(
///     "Favorite Fruit",
///     optionsWithIcons: optionsWithIcons,
///     selection: $selectedOption
/// )
/// ```
public struct CTSelect<ID: Hashable>: View {
    // MARK: - Properties
    
    /// The label for the select field
    private let label: String
    
    /// The placeholder text
    private let placeholder: String
    
    /// Whether the select is required
    private let isRequired: Bool
    
    /// The style of the select
    private let style: CTSelectStyle
    
    /// The size of the select
    private let size: CTSelectSize
    
    /// Whether the select is disabled
    private let isDisabled: Bool
    
    /// The binding to the selected option ID
    @Binding private var selection: ID
    
    /// The options mapping IDs to display labels
    private let options: [ID: String]
    
    /// The options mapping IDs to option objects with label and icon
    private let optionsWithIcons: [ID: CTSelectOption]?
    
    /// The error message
    @Binding private var error: String?
    
    /// Optional callback when selection changes
    private let onChange: ((ID) -> Void)?
    
    /// Whether the dropdown is currently visible
    @State private var isDropdownVisible = false
    
    /// Whether the field is focused
    @State private var isFocused = false
    
    /// Theme from environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a select with string options
    ///
    /// - Parameters:
    ///   - label: The label for the select field
    ///   - options: Dictionary mapping option IDs to display labels
    ///   - selection: Binding to the currently selected option ID
    ///   - placeholder: The placeholder text to display when no selection
    ///   - error: Binding to error message
    ///   - style: The visual style of the select
    ///   - size: The size of the select
    ///   - isRequired: Whether the select is required
    ///   - isDisabled: Whether the select is disabled
    ///   - onChange: Callback when selection changes
    public init(
        _ label: String,
        options: [ID: String],
        selection: Binding<ID>,
        placeholder: String = "Select an option",
        error: Binding<String?> = .constant(nil),
        style: CTSelectStyle = .default,
        size: CTSelectSize = .medium,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        onChange: ((ID) -> Void)? = nil
    ) {
        self.label = label
        self.options = options
        self._selection = selection
        self.placeholder = placeholder
        self._error = error
        self.style = style
        self.size = size
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.onChange = onChange
        self.optionsWithIcons = nil
    }
    
    /// Initialize a select with options that include icons
    ///
    /// - Parameters:
    ///   - label: The label for the select field
    ///   - optionsWithIcons: Dictionary mapping option IDs to option objects with label and icon
    ///   - selection: Binding to the currently selected option ID
    ///   - placeholder: The placeholder text to display when no selection
    ///   - error: Binding to error message
    ///   - style: The visual style of the select
    ///   - size: The size of the select
    ///   - isRequired: Whether the select is required
    ///   - isDisabled: Whether the select is disabled
    ///   - onChange: Callback when selection changes
    public init(
        _ label: String,
        optionsWithIcons: [ID: CTSelectOption],
        selection: Binding<ID>,
        placeholder: String = "Select an option",
        error: Binding<String?> = .constant(nil),
        style: CTSelectStyle = .default,
        size: CTSelectSize = .medium,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        onChange: ((ID) -> Void)? = nil
    ) {
        self.label = label
        self.options = [:]
        self._selection = selection
        self.placeholder = placeholder
        self._error = error
        self.style = style
        self.size = size
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.onChange = onChange
        self.optionsWithIcons = optionsWithIcons
    }
    
    /// Initialize a select with array of options
    ///
    /// - Parameters:
    ///   - label: The label for the select field
    ///   - options: Array of options where each option is its own ID
    ///   - selection: Binding to the currently selected option
    ///   - placeholder: The placeholder text to display when no selection
    ///   - error: Binding to error message
    ///   - style: The visual style of the select
    ///   - size: The size of the select
    ///   - isRequired: Whether the select is required
    ///   - isDisabled: Whether the select is disabled
    ///   - onChange: Callback when selection changes
    public init(
        _ label: String,
        options: [ID],
        selection: Binding<ID>,
        placeholder: String = "Select an option",
        error: Binding<String?> = .constant(nil),
        style: CTSelectStyle = .default,
        size: CTSelectSize = .medium,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        onChange: ((ID) -> Void)? = nil
    ) where ID: CustomStringConvertible {
        let optionsDict = Dictionary(uniqueKeysWithValues: options.map { ($0, $0.description) })
        self.label = label
        self.options = optionsDict
        self._selection = selection
        self.placeholder = placeholder
        self._error = error
        self.style = style
        self.size = size
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.onChange = onChange
        self.optionsWithIcons = nil
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CTSpacing.xs) {
            // Field Label
            if !label.isEmpty {
                HStack(spacing: CTSpacing.xxs) {
                    Text(label)
                        .font(size.labelFont)
                        .foregroundColor(labelColor)
                    
                    if isRequired {
                        Text("*")
                            .font(size.labelFont)
                            .foregroundColor(theme.destructive)
                    }
                }
            }
            
            // Select Field
            ZStack {
                selectField
                    .overlay(
                        RoundedRectangle(cornerRadius: fieldBorderRadius)
                            .stroke(borderColor, lineWidth: fieldBorderWidth)
                    )
                    .background(backgroundColor)
                    .cornerRadius(fieldBorderRadius)
                
                // Dropdown overlay when expanded
                if isDropdownVisible {
                    VStack {
                        Spacer(minLength: size.height + CTSpacing.s)
                        dropdownList
                    }
                    .zIndex(10)
                }
            }
            
            // Error Message
            if let error = error, !error.isEmpty {
                Text(error)
                    .font(size.errorFont)
                    .foregroundColor(theme.destructive)
                    .padding(.top, CTSpacing.xxs)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(selectedValueText)
        .accessibilityHint("Double tap to open dropdown")
        .accessibilityAddTraits(isDisabled ? .isButton : [])
        .disabled(isDisabled)
    }
    
    // MARK: - Supporting Views
    
    /// The select field view
    private var selectField: some View {
        HStack {
            // Selected value or placeholder
            if optionsWithIcons != nil {
                selectedOptionWithIcon
            } else {
                Text(selectedValueText)
                    .font(size.valueFont)
                    .foregroundColor(selectedValueColor)
            }
            
            Spacer()
            
            // Chevron icon
            Image(systemName: "chevron.down")
                .font(size.iconFont)
                .foregroundColor(iconColor)
                .rotationEffect(isDropdownVisible ? .degrees(180) : .degrees(0))
                .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isDropdownVisible)
        }
        .padding(fieldPadding)
        .frame(height: size.height)
        .background(backgroundColor)
        .contentShape(Rectangle())
        .onTapGesture {
            if !isDisabled {
                withAnimation {
                    isDropdownVisible.toggle()
                }
            }
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
    
    /// The dropdown list view
    private var dropdownList: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(optionsList, id: \.0) { optionId, optionValue in
                        optionRow(optionId: optionId, optionValue: optionValue)
                    }
                }
            }
            .frame(maxHeight: 200)
        }
        .background(theme.surface)
        .cornerRadius(fieldBorderRadius)
        .overlay(
            RoundedRectangle(cornerRadius: fieldBorderRadius)
                .stroke(theme.border, lineWidth: 1)
        )
        .shadow(color: theme.shadowColor.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, -CTSpacing.xxs)
        .zIndex(100)
        .onTapGesture {
            // Prevent clicks on the dropdown container from closing it
        }
        .onAppear {
            CTAccessibilityUtilities.announce("Dropdown menu opened")
        }
        .onDisappear {
            CTAccessibilityUtilities.announce("Dropdown menu closed")
        }
    }
    
    /// Creates a row view for an option in the dropdown
    @ViewBuilder
    private func optionRow(optionId: ID, optionValue: String) -> some View {
        if let optionsWithIcons = optionsWithIcons,
           let option = optionsWithIcons[optionId] {
            // Row with icon
            optionRowWithIcon(id: optionId, option: option)
        } else {
            // Standard row
            HStack {
                Text(optionValue)
                    .font(size.valueFont)
                    .foregroundColor(theme.text)
                
                Spacer()
                
                if optionId == selection {
                    Image(systemName: "checkmark")
                        .font(size.iconFont)
                        .foregroundColor(theme.primary)
                }
            }
            .padding(.vertical, CTSpacing.s)
            .padding(.horizontal, CTSpacing.m)
            .background(
                optionId == selection ?
                theme.primary.opacity(0.1) :
                Color.clear
            )
            .contentShape(Rectangle())
            .onTapGesture {
                selectOption(optionId)
            }
            .ctSelectedAccessibility(isSelected: optionId == selection)
        }
    }
    
    /// Creates a row view for an option with icon in the dropdown
    private func optionRowWithIcon(id: ID, option: CTSelectOption) -> some View {
        HStack(spacing: CTSpacing.s) {
            if let icon = option.icon {
                Image(systemName: icon)
                    .font(size.iconFont)
                    .foregroundColor(theme.text)
                    .frame(width: 20, height: 20)
                    .ctImageAccessibility(label: "", isDecorative: true)
            }
            
            Text(option.label)
                .font(size.valueFont)
                .foregroundColor(theme.text)
            
            Spacer()
            
            if id == selection {
                Image(systemName: "checkmark")
                    .font(size.iconFont)
                    .foregroundColor(theme.primary)
            }
        }
        .padding(.vertical, CTSpacing.s)
        .padding(.horizontal, CTSpacing.m)
        .background(
            id == selection ?
            theme.primary.opacity(0.1) :
            Color.clear
        )
        .contentShape(Rectangle())
        .onTapGesture {
            selectOption(id)
        }
        .ctSelectedAccessibility(isSelected: id == selection)
    }
    
    /// The selected option with icon
    @ViewBuilder
    private var selectedOptionWithIcon: some View {
        if let optionsWithIcons = optionsWithIcons,
           let selectedId = optionsWithIcons[selection] {
            HStack(spacing: CTSpacing.s) {
                if let icon = selectedId.icon {
                    Image(systemName: icon)
                        .font(size.iconFont)
                        .foregroundColor(iconColor)
                        .frame(width: 20, height: 20)
                        .ctImageAccessibility(label: "", isDecorative: true)
                }
                
                Text(selectedId.label)
                    .font(size.valueFont)
                    .foregroundColor(selectedValueColor)
            }
        } else {
            Text(selectedValueText)
                .font(size.valueFont)
                .foregroundColor(selectedValueColor)
        }
    }
    
    // MARK: - Action Methods
    
    /// Select an option and close the dropdown
    private func selectOption(_ optionId: ID) {
        selection = optionId
        withAnimation {
            isDropdownVisible = false
        }
        onChange?(optionId)
        
        // Announce selection to screen readers
        if let optionLabel = getOptionLabel(for: optionId) {
            CTAccessibilityUtilities.announce("Selected \(optionLabel)")
        }
    }
    
    /// Get the label for an option ID
    private func getOptionLabel(for id: ID) -> String? {
        if let optionsWithIcons = optionsWithIcons {
            return optionsWithIcons[id]?.label
        } else {
            return options[id]
        }
    }
    
    // MARK: - Computed Properties
    
    /// The list of options in the dropdown
    private var optionsList: [(ID, String)] {
        if let optionsWithIcons = optionsWithIcons {
            return optionsWithIcons.map { id, option in
                (id, option.label)
            }.sorted { $0.1 < $1.1 } // Sort alphabetically by label
        } else {
            return options.map { key, value in
                (key, value)
            }.sorted { $0.1 < $1.1 } // Sort alphabetically by label
        }
    }
    
    /// The selected value text or placeholder
    private var selectedValueText: String {
        if let optionsWithIcons = optionsWithIcons,
           let selectedOption = optionsWithIcons[selection] {
            return selectedOption.label
        } else if let selectedText = options[selection] {
            return selectedText
        } else {
            return placeholder
        }
    }
    
    /// Whether there is a valid selection
    private var hasSelection: Bool {
        if let optionsWithIcons = optionsWithIcons {
            return optionsWithIcons[selection] != nil
        } else {
            return options[selection] != nil
        }
    }
    
    /// The color of the selected value or placeholder text
    private var selectedValueColor: Color {
        if hasSelection {
            return textColor
        } else {
            return placeholderColor
        }
    }
    
    /// The color of the label
    private var labelColor: Color {
        isDisabled ? theme.textSecondary : theme.text
    }
    
    /// The color of the text
    private var textColor: Color {
        isDisabled ? theme.textSecondary : theme.text
    }
    
    /// The color of the placeholder
    private var placeholderColor: Color {
        theme.textSecondary.opacity(0.8)
    }
    
    /// The color of the icons
    private var iconColor: Color {
        isDisabled ? theme.textSecondary : theme.textSecondary
    }
    
    /// The background color of the select field
    private var backgroundColor: Color {
        switch style {
        case .default:
            return Color.clear
        case .filled:
            return theme.surface
        case .outlined:
            return Color.clear
        }
    }
    
    /// The border color of the select field
    private var borderColor: Color {
        if let error = error, !error.isEmpty {
            return theme.destructive
        } else if isFocused || isDropdownVisible {
            return theme.primary
        } else {
            switch style {
            case .default, .filled:
                return theme.border.opacity(0.7)
            case .outlined:
                return theme.border
            }
        }
    }
    
    /// The border width of the select field
    private var fieldBorderWidth: CGFloat {
        switch style {
        case .default:
            return 1
        case .filled:
            return error != nil ? 1 : 0
        case .outlined:
            return 1
        }
    }
    
    /// The border radius of the select field
    private var fieldBorderRadius: CGFloat {
        switch style {
        case .default, .outlined:
            return theme.borderRadius
        case .filled:
            return theme.borderRadius
        }
    }
    
    /// The padding of the select field
    private var fieldPadding: EdgeInsets {
        switch size {
        case .small:
            return EdgeInsets(top: CTSpacing.xs, leading: CTSpacing.s, bottom: CTSpacing.xs, trailing: CTSpacing.s)
        case .medium:
            return EdgeInsets(top: CTSpacing.s, leading: CTSpacing.m, bottom: CTSpacing.s, trailing: CTSpacing.m)
        case .large:
            return EdgeInsets(top: CTSpacing.m, leading: CTSpacing.l, bottom: CTSpacing.m, trailing: CTSpacing.l)
        }
    }
    
    /// The accessibility label for the select
    private var accessibilityLabel: String {
        var baseLabel = label
        if isRequired {
            baseLabel += ", required"
        }
        
        if let error = error, !error.isEmpty {
            baseLabel += ", Error: \(error)"
        }
        
        return baseLabel
    }
}

// MARK: - Select Option

/// Represents an option in a select dropdown with an optional icon
public struct CTSelectOption {
    /// The display label for the option
    public let label: String
    
    /// The optional SF Symbol icon name
    public let icon: String?
    
    /// Initialize a select option
    /// - Parameters:
    ///   - label: The display label
    ///   - icon: Optional SF Symbol icon name
    public init(label: String, icon: String? = nil) {
        self.label = label
        self.icon = icon
    }
}

// MARK: - Select Style Enum

/// The available styles for CTSelect
public enum CTSelectStyle {
    /// Standard style with a subtle border
    case `default`
    
    /// Filled background style
    case filled
    
    /// Outlined style with pronounced border
    case outlined
}

// MARK: - Select Size Enum

/// The available sizes for CTSelect
public enum CTSelectSize {
    /// Small select
    case small
    
    /// Medium select (default)
    case medium
    
    /// Large select
    case large
    
    /// The height of the select field
    var height: CGFloat {
        switch self {
        case .small:
            return 36
        case .medium:
            return 44
        case .large:
            return 56
        }
    }
    
    /// The font for the select field value
    var valueFont: Font {
        switch self {
        case .small:
            return CTTypography.bodySmall()
        case .medium:
            return CTTypography.body()
        case .large:
            return CTTypography.subtitle()
        }
    }
    
    /// The font for the select field label
    var labelFont: Font {
        switch self {
        case .small:
            return CTTypography.captionSmall()
        case .medium:
            return CTTypography.caption()
        case .large:
            return CTTypography.bodySmall()
        }
    }
    
    /// The font for error messages
    var errorFont: Font {
        switch self {
        case .small, .medium:
            return CTTypography.captionSmall()
        case .large:
            return CTTypography.caption()
        }
    }
    
    /// The font for icons
    var iconFont: Font {
        switch self {
        case .small:
            return .system(size: 12, weight: .regular)
        case .medium:
            return .system(size: 14, weight: .regular)
        case .large:
            return .system(size: 16, weight: .regular)
        }
    }
}

// MARK: - Previews

struct CTSelect_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Group {
                    Text("Select Field Examples")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    // String options
                    SelectPreview(title: "Default Select")
                    SelectPreview(title: "Filled Style", style: .filled)
                    SelectPreview(title: "Outlined Style", style: .outlined)
                }
                
                Divider().padding(.vertical)
                
                Group {
                    Text("Size Variations")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    SelectPreview(title: "Small Size", size: .small)
                    SelectPreview(title: "Medium Size", size: .medium)
                    SelectPreview(title: "Large Size", size: .large)
                }
                
                Divider().padding(.vertical)
                
                Group {
                    Text("State Variations")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    SelectPreview(title: "Required Field", isRequired: true)
                    SelectPreview(title: "With Error", hasError: true)
                    SelectPreview(title: "Disabled Field", isDisabled: true)
                    
                    // With Icons
                    Text("With Icons")
                        .font(.headline)
                        .padding(.top)
                    
                    SelectWithIconsPreview()
                }
                
                Divider().padding(.vertical)
                
                Group {
                    Text("Array-based Options")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    SelectWithArrayPreview()
                }
            }
            .padding()
        }
    }
    
    // Preview for string-based options
    struct SelectPreview: View {
        let title: String
        let style: CTSelectStyle
        let size: CTSelectSize
        let isRequired: Bool
        let isDisabled: Bool
        let hasError: Bool
        
        @State private var selection: String = "option1"
        @State private var error: String? = nil
        
        let options = [
            "option1": "Option 1",
            "option2": "Option 2",
            "option3": "Option 3",
            "option4": "Option 4",
            "option5": "Option 5"
        ]
        
        init(
            title: String,
            style: CTSelectStyle = .default,
            size: CTSelectSize = .medium,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            hasError: Bool = false
        ) {
            self.title = title
            self.style = style
            self.size = size
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.hasError = hasError
            
            if hasError {
                self._error = State(initialValue: "This field has an error")
            } else {
                self._error = State(initialValue: nil)
            }
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .padding(.bottom, 4)
                
                CTSelect(
                    "Select Field",
                    options: options,
                    selection: $selection,
                    error: $error,
                    style: style,
                    size: size,
                    isRequired: isRequired,
                    isDisabled: isDisabled
                ) { newValue in
                    print("Selected: \(newValue)")
                }
            }
        }
    }
    
    // Preview for options with icons
    struct SelectWithIconsPreview: View {
        @State private var selection: String = "apple"
        
        let optionsWithIcons: [String: CTSelectOption] = [
            "apple": CTSelectOption(label: "Apple", icon: "apple.logo"),
            "cloud": CTSelectOption(label: "Cloud", icon: "cloud.fill"),
            "star": CTSelectOption(label: "Star", icon: "star.fill"),
            "heart": CTSelectOption(label: "Heart", icon: "heart.fill"),
            "bolt": CTSelectOption(label: "Lightning", icon: "bolt.fill")
        ]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("With Icons")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                CTSelect(
                    "Select with Icons",
                    optionsWithIcons: optionsWithIcons,
                    selection: $selection,
                    style: .filled
                ) { newValue in
                    print("Selected: \(newValue)")
                }
            }
        }
    }
    
    // Preview for array-based options
    struct SelectWithArrayPreview: View {
        @State private var selection: Int = 1
        
        let options = [1, 2, 3, 4, 5]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Array Options")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                CTSelect(
                    "Select a Number",
                    options: options,
                    selection: $selection,
                    style: .outlined
                ) { newValue in
                    print("Selected: \(newValue)")
                }
            }
        }
    }
}