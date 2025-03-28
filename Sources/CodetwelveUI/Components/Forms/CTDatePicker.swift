//
//  CTDatePicker.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable date picker component.
///
/// `CTDatePicker` provides a consistent date selection interface throughout your application
/// with support for different visual styles, date ranges, and formats.
///
/// # Example
///
/// ```swift
/// @State private var selectedDate = Date()
///
/// CTDatePicker(
///     "Event Date",
///     selection: $selectedDate,
///     style: .bordered
/// )
/// ```
///
/// With date range and custom format:
///
/// ```swift
/// @State private var birthDate = Date()
///
/// CTDatePicker(
///     "Date of Birth",
///     selection: $birthDate,
///     displayedComponents: .date,
///     minDate: Calendar.current.date(byAdding: .year, value: -100, to: Date()),
///     maxDate: Date(),
///     style: .underlined,
///     dateFormatter: { date in
///         let formatter = DateFormatter()
///         formatter.dateStyle = .long
///         return formatter.string(from: date)
///     }
/// )
/// ```
public struct CTDatePicker: View {
    // MARK: - Properties
    
    /// The selected date
    @Binding private var selection: Date
    
    /// The label for the date picker
    private let label: String
    
    /// The displayed components of the date picker
    private let displayedComponents: DatePickerComponents
    
    /// The minimum selectable date
    private let minDate: Date?
    
    /// The maximum selectable date
    private let maxDate: Date?
    
    /// The visual style of the date picker
    private let style: CTDatePickerStyle
    
    /// Whether the date picker is required
    private let isRequired: Bool
    
    /// Whether the date picker is disabled
    private let isDisabled: Bool
    
    /// Function to format the date for display
    private let dateFormatter: ((Date) -> String)?
    
    /// The action to perform when the date changes
    private let onChange: ((Date) -> Void)?
    
    /// Whether the field is focused
    @State private var isFocused: Bool = false
    
    /// Theme from environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a date picker with standard options
    ///
    /// - Parameters:
    ///   - label: The label for the date picker
    ///   - selection: Binding to the selected date
    ///   - displayedComponents: The components to display (date, time, or both)
    ///   - minDate: Optional minimum selectable date
    ///   - maxDate: Optional maximum selectable date
    ///   - style: The visual style of the date picker
    ///   - isRequired: Whether the date picker is required
    ///   - isDisabled: Whether the date picker is disabled
    ///   - dateFormatter: Optional function to format the date for display
    ///   - onChange: Optional action to perform when the date changes
    public init(
        _ label: String,
        selection: Binding<Date>,
        displayedComponents: DatePickerComponents = [.date, .hourAndMinute],
        minDate: Date? = nil,
        maxDate: Date? = nil,
        style: CTDatePickerStyle = .bordered,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        dateFormatter: ((Date) -> String)? = nil,
        onChange: ((Date) -> Void)? = nil
    ) {
        self.label = label
        self._selection = selection
        self.displayedComponents = displayedComponents
        self.minDate = minDate
        self.maxDate = maxDate
        self.style = style
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.dateFormatter = dateFormatter
        self.onChange = onChange
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CTSpacing.xs) {
            // Label
            if !label.isEmpty {
                HStack(spacing: CTSpacing.xxs) {
                    Text(label)
                        .font(CTTypography.caption())
                        .foregroundColor(labelColor)
                    
                    if isRequired {
                        Text("*")
                            .font(CTTypography.caption())
                            .foregroundColor(theme.destructive)
                    }
                }
            }
            
            // Date Picker
            DatePicker(
                "",
                selection: Binding(
                    get: { selection },
                    set: { newDate in
                        selection = newDate
                        onChange?(newDate)
                    }
                ),
                in: dateRange,
                displayedComponents: displayedComponents
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .accentColor(style.accentColor(for: theme))
            .padding(fieldPadding)
            .background(backgroundColor)
            .cornerRadius(fieldCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: fieldCornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .opacity(isDisabled ? 0.6 : 1.0)
            .disabled(isDisabled)
            
            // Formatted date display if formatter provided
            if let formatter = dateFormatter {
                Text(formatter(selection))
                    .font(CTTypography.bodySmall())
                    .foregroundColor(theme.textSecondary)
                    .padding(.top, CTSpacing.xxs)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
        .accessibilityHint("Double tap to edit \(displayedComponents.contains(.date) ? "date" : "")\(displayedComponents.contains(.hourAndMinute) ? (displayedComponents.contains(.date) ? " and time" : "time") : "")")
    }
    
    // MARK: - Computed Properties
    
    /// The date range for the picker
    private var dateRange: ClosedRange<Date> {
        let min = minDate ?? Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let max = maxDate ?? Date(timeIntervalSince1970: 4102444800) // Jan 1, 2100
        return min...max
    }
    
    /// The field padding based on style
    private var fieldPadding: EdgeInsets {
        switch style {
        case .bordered, .underlined, .filled:
            return EdgeInsets(top: CTSpacing.s, leading: CTSpacing.m, bottom: CTSpacing.s, trailing: CTSpacing.m)
        case .plain:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }
    
    /// The field corner radius based on style
    private var fieldCornerRadius: CGFloat {
        switch style {
        case .bordered, .filled:
            return theme.borderRadius
        case .underlined, .plain:
            return 0
        }
    }
    
    /// The border width based on style
    private var borderWidth: CGFloat {
        switch style {
        case .bordered:
            return theme.borderWidth
        case .underlined:
            return theme.borderWidth
        case .filled, .plain:
            return 0
        }
    }
    
    /// The background color based on style
    private var backgroundColor: Color {
        switch style {
        case .bordered, .underlined, .plain:
            return Color.clear
        case .filled:
            return theme.background
        }
    }
    
    /// The border color based on style and state
    private var borderColor: Color {
        switch style {
        case .bordered:
            return isFocused ? theme.primary : theme.border
        case .underlined:
            return isFocused ? theme.primary : theme.border
        case .filled, .plain:
            return Color.clear
        }
    }
    
    /// The label color based on state
    private var labelColor: Color {
        isDisabled ? theme.textSecondary : theme.text
    }
    
    /// The accessibility label
    private var accessibilityLabel: String {
        var baseLabel = label
        if isRequired {
            baseLabel += ", required"
        }
        
        if isDisabled {
            baseLabel += ", disabled"
        }
        
        return baseLabel
    }
    
    /// The accessibility value
    private var accessibilityValue: String {
        if let formatter = dateFormatter {
            return formatter(selection)
        } else {
            let formatter = DateFormatter()
            if displayedComponents.contains(.date) && displayedComponents.contains(.hourAndMinute) {
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
            } else if displayedComponents.contains(.date) {
                formatter.dateStyle = .long
                formatter.timeStyle = .none
            } else {
                formatter.dateStyle = .none
                formatter.timeStyle = .short
            }
            return formatter.string(from: selection)
        }
    }
}

// MARK: - Date Picker Style Enum

/// The visual style of the date picker
public enum CTDatePickerStyle {
    /// Standard bordered style
    case bordered
    
    /// Underlined style with a line at the bottom
    case underlined
    
    /// Filled style with a background
    case filled
    
    /// Plain style with no border or background
    case plain
    
    /// Get the accent color for the style
    func accentColor(for theme: CTTheme) -> Color {
        return theme.primary
    }
}

// MARK: - Previews

struct CTDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            Group {
                Text("Date Picker Styles")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                DatePickerPreview(title: "Bordered Style", style: .bordered)
                DatePickerPreview(title: "Underlined Style", style: .underlined)
                DatePickerPreview(title: "Filled Style", style: .filled)
                DatePickerPreview(title: "Plain Style", style: .plain)
            }
            
            Divider()
            
            Group {
                Text("Date Picker Components")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                DatePickerPreview(title: "Date Only", displayedComponents: .date)
                DatePickerPreview(title: "Time Only", displayedComponents: .hourAndMinute)
                DatePickerPreview(title: "Date and Time", displayedComponents: [.date, .hourAndMinute])
            }
            
            Divider()
            
            Group {
                Text("Date Picker Features")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                DatePickerPreview(title: "Required Field", isRequired: true)
                DatePickerPreview(title: "Disabled State", isDisabled: true)
                DatePickerPreview(title: "With Date Range", hasDateRange: true)
                DatePickerPreview(title: "With Custom Formatter", hasFormatter: true)
            }
        }
        .padding()
    }
    
    struct DatePickerPreview: View {
        let title: String
        let style: CTDatePickerStyle
        let displayedComponents: DatePickerComponents
        let isRequired: Bool
        let isDisabled: Bool
        let hasDateRange: Bool
        let hasFormatter: Bool
        
        @State private var selectedDate = Date()
        
        init(
            title: String,
            style: CTDatePickerStyle = .bordered,
            displayedComponents: DatePickerComponents = [.date, .hourAndMinute],
            isRequired: Bool = false,
            isDisabled: Bool = false,
            hasDateRange: Bool = false,
            hasFormatter: Bool = false
        ) {
            self.title = title
            self.style = style
            self.displayedComponents = displayedComponents
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.hasDateRange = hasDateRange
            self.hasFormatter = hasFormatter
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                
                if hasDateRange && hasFormatter {
                    CTDatePicker(
                        "Selected Date",
                        selection: $selectedDate,
                        displayedComponents: displayedComponents,
                        minDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()),
                        maxDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
                        style: style,
                        isRequired: isRequired,
                        isDisabled: isDisabled,
                        dateFormatter: { date in
                            let formatter = DateFormatter()
                            formatter.dateStyle = .long
                            formatter.timeStyle = displayedComponents.contains(.hourAndMinute) ? .short : .none
                            return formatter.string(from: date)
                        }
                    ) { newDate in
                        print("\(title) date changed to: \(newDate)")
                    }
                } else if hasDateRange {
                    CTDatePicker(
                        "Selected Date",
                        selection: $selectedDate,
                        displayedComponents: displayedComponents,
                        minDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()),
                        maxDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
                        style: style,
                        isRequired: isRequired,
                        isDisabled: isDisabled
                    ) { newDate in
                        print("\(title) date changed to: \(newDate)")
                    }
                } else if hasFormatter {
                    CTDatePicker(
                        "Selected Date",
                        selection: $selectedDate,
                        displayedComponents: displayedComponents,
                        style: style,
                        isRequired: isRequired,
                        isDisabled: isDisabled,
                        dateFormatter: { date in
                            let formatter = DateFormatter()
                            formatter.dateStyle = .long
                            formatter.timeStyle = displayedComponents.contains(.hourAndMinute) ? .short : .none
                            return formatter.string(from: date)
                        }
                    ) { newDate in
                        print("\(title) date changed to: \(newDate)")
                    }
                } else {
                    CTDatePicker(
                        "Selected Date",
                        selection: $selectedDate,
                        displayedComponents: displayedComponents,
                        style: style,
                        isRequired: isRequired,
                        isDisabled: isDisabled
                    ) { newDate in
                        print("\(title) date changed to: \(newDate)")
                    }
                }
            }
        }
    }
}