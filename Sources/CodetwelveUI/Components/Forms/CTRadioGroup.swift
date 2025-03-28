//
//  CTRadioGroup.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A radio group component for selecting a single option from multiple choices.
///
/// `CTRadioGroup` provides a consistent interface for single-selection controls
/// with support for different visual styles, orientations, and states.
///
/// # Example
///
/// ```swift
/// @State private var selectedOption = "option1"
/// let options = ["option1": "Option 1", "option2": "Option 2", "option3": "Option 3"]
///
/// CTRadioGroup(
///     options: options,
///     selectedOption: $selectedOption,
///     style: .primary
/// )
/// ```
///
public struct CTRadioGroup<ID: Hashable>: View {
    // MARK: - Public Properties
    
    /// Binding to the currently selected option
    @Binding private var selectedOption: ID
    
    // MARK: - Private Properties
    
    /// Dictionary of options with IDs as keys and display labels as values
    private let options: [ID: String]
    
    /// The visual style of the radio buttons
    private let style: CTRadioStyle
    
    /// The size of the radio buttons
    private let size: CTRadioSize
    
    /// The orientation of the radio group (vertical or horizontal)
    private let orientation: CTRadioOrientation
    
    /// The spacing between radio buttons
    private let spacing: CGFloat
    
    /// Whether the radio group is disabled
    private let isDisabled: Bool
    
    /// The action to perform when selection changes
    private let onChange: ((ID) -> Void)?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new radio group with options dictionary
    /// - Parameters:
    ///   - options: Dictionary with option IDs as keys and display labels as values
    ///   - selectedOption: Binding to the currently selected option ID
    ///   - style: The visual style of the radio buttons
    ///   - size: The size of the radio buttons
    ///   - orientation: The orientation of the radio group (vertical or horizontal)
    ///   - spacing: The spacing between radio buttons
    ///   - isDisabled: Whether the radio group is disabled
    ///   - onChange: The action to perform when selection changes
    public init(
        options: [ID: String],
        selectedOption: Binding<ID>,
        style: CTRadioStyle = .primary,
        size: CTRadioSize = .medium,
        orientation: CTRadioOrientation = .vertical,
        spacing: CGFloat? = nil,
        isDisabled: Bool = false,
        onChange: ((ID) -> Void)? = nil
    ) {
        self.options = options
        self._selectedOption = selectedOption
        self.style = style
        self.size = size
        self.orientation = orientation
        self.spacing = spacing ?? (orientation == .vertical ? CTSpacing.m : CTSpacing.l)
        self.isDisabled = isDisabled
        self.onChange = onChange
    }

// MARK: - Supporting Types

/// The visual style of the radio buttons
public enum CTRadioStyle {
    /// Primary style, using the primary theme color
    case primary
    
    /// Secondary style, using the secondary theme color
    case secondary
    
    /// Outline style with circular border and fill
    case outline
    
    /// Custom style with specific colors
    case custom(
        selectedFill: Color,
        selectedBorder: Color,
        unselectedBorder: Color
    )
    
    /// Get the selected fill color for a given theme
    func getSelectedFillColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .outline:
            return theme.primary
        case .custom(let selectedFill, _, _):
            return selectedFill
        }
    }
    
    /// Get the selected border color for a given theme
    func getSelectedBorderColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .outline:
            return theme.primary
        case .custom(_, let selectedBorder, _):
            return selectedBorder
        }
    }
    
    /// Get the unselected border color for a given theme
    func getUnselectedBorderColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary, .secondary, .outline:
            return theme.border
        case .custom(_, _, let unselectedBorder):
            return unselectedBorder
        }
    }
}

/// The size of the radio buttons
public enum CTRadioSize {
    /// Small radio buttons
    case small
    
    /// Medium radio buttons
    case medium
    
    /// Large radio buttons
    case large
    
    /// The font for the label based on the radio button size
    var font: Font {
        switch self {
        case .small:
            return CTTypography.caption()
        case .medium:
            return CTTypography.body()
        case .large:
            return CTTypography.subtitle()
        }
    }
}

/// The orientation of the radio group
public enum CTRadioOrientation {
    /// Vertical orientation (radio buttons stacked vertically)
    case vertical
    
    /// Horizontal orientation (radio buttons arranged horizontally)
    case horizontal
}

// MARK: - Previews

//struct CTRadioGroup_Previews: PreviewProvider {
//    struct RadioGroupPreview: View {
//        @State private var selectedOption1 = "option1"
//        @State private var selectedOption2 = "option2"
//        @State private var selectedOption3 = "option1"
//        @State private var selectedNumeric = 1
//        
//        let options = [
//            "option1": "Option 1",
//            "option2": "Option 2",
//            "option3": "Option 3"
//        ]
//        
//        let numericOptions = [
//            1: "Option 1",
//            2: "Option 2",
//            3: "Option 3",
//            4: "Option 4",
//            5: "Option 5"
//        ]
//        
//        var body: some View {
//            ScrollView {
//                VStack(alignment: .leading, spacing: CTSpacing.l) {
//                    Group {
//                        Text("Radio Group Styles")
//                            .font(CTTypography.heading2())
//                            .padding(.bottom, CTSpacing.s)
//                        
//                        CTRadioGroup(
//                            options: options,
//                            selectedOption: $selectedOption1,
//                            style: .primary
//                        )
//                        
//                        CTRadioGroup(
//                            options: options,
//                            selectedOption: $selectedOption2,
//                            style: .secondary
//                        )
//                        
//                        CTRadioGroup(
//                            options: options,
//                            selectedOption: $selectedOption3,
//                            style: .outline
//                        )
//                        
//                        CTRadioGroup(
//                            options: options,
//                            selectedOption: $selectedOption1,
//                            style: .custom(
//                                selectedFill: .purple,
//                                selectedBorder: .purple,
//                                unselectedBorder: .gray
//                            )
//                        )
//                    }
//                    
//                    Divider().padding(.vertical, CTSpacing.m)
//                    
//                    Group {
//                        Text("Radio Group Sizes")
//                            .font(CTTypography.heading2())
//                            .padding(.bottom, CTSpacing.s)
//                        
//                        CTRadioGroup(
//                            options: options,
//                            selectedOption: $selectedOption1,
//                            size: .small
//                        )
//                        
//                        CTRadioGroup(
//                            options: options,
//                            selectedOption: $selectedOption1,
//                            size: .medium
//                        )
//                        
//                        CTRadioGroup(
//                            options: options,
//                            selectedOption: $selectedOption1,
//                            size: .large
//                        )
//                    }
//                    
//                    Divider().padding(.vertical, CTSpacing.m)
//                    
//                    Group {
//                        Text("Radio Group Orientations")
//                            .font(CTTypography.heading2())
//                            .padding(.bottom, CTSpacing.s)
//                        
//                        CTRadioGroup(
//                            options: options,
//                            selectedOption: $selectedOption1,
//                            orientation: .vertical
//                        )
//                        
//                        CTRadioGroup(
//                            options: options,
//                            selectedOption: $selectedOption1,
//                            orientation: .horizontal
//                        )
//                    }
//                    
//                    Divider().padding(.vertical, CTSpacing.m)
//                    
//                    Group {
//                        Text("Numeric Radio Group")
//                            .font(CTTypography.heading2())
//                            .padding(.bottom, CTSpacing.s)
//                        
//                        CTRadioGroup(
//                            options: numericOptions,
//                            selectedOption: $selectedNumeric,
//                            style: .primary
//                        )
//                    }
//                }
//                .padding()
//            }
//        }
//    }
//    
//    static var previews: some View {
//        RadioGroupPreview()
//    }
//}
    
    /// Initialize a new radio group with options array
    /// - Parameters:
    ///   - options: Array of options where each option is used both as ID and display label
    ///   - selectedOption: Binding to the currently selected option
    ///   - style: The visual style of the radio buttons
    ///   - size: The size of the radio buttons
    ///   - orientation: The orientation of the radio group (vertical or horizontal)
    ///   - spacing: The spacing between radio buttons
    ///   - isDisabled: Whether the radio group is disabled
    ///   - onChange: The action to perform when selection changes
    public init(
        options: [ID],
        selectedOption: Binding<ID>,
        style: CTRadioStyle = .primary,
        size: CTRadioSize = .medium,
        orientation: CTRadioOrientation = .vertical,
        spacing: CGFloat? = nil,
        isDisabled: Bool = false,
        onChange: ((ID) -> Void)? = nil
    ) where ID: CustomStringConvertible {
        let optionsDictionary = Dictionary(uniqueKeysWithValues: options.map { ($0, $0.description) })
        self.init(
            options: optionsDictionary,
            selectedOption: selectedOption,
            style: style,
            size: size,
            orientation: orientation,
            spacing: spacing,
            isDisabled: isDisabled,
            onChange: onChange
        )
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if orientation == .vertical {
                VStack(alignment: .leading, spacing: spacing) {
                    ForEach(Array(options.keys), id: \.self) { id in
                        radioButton(for: id)
                    }
                }
            } else {
                HStack(spacing: spacing) {
                    ForEach(Array(options.keys), id: \.self) { id in
                        radioButton(for: id)
                    }
                }
            }
        }
        .disabled(isDisabled)
    }
    
    // MARK: - Private Views
    
    private func radioButton(for id: ID) -> some View {
        Button {
            selectedOption = id
            onChange?(id)
        } label: {
            HStack(spacing: CTSpacing.s) {
                Circle()
                    .strokeBorder(
                        style.getUnselectedBorderColor(for: theme),
                        lineWidth: 2
                    )
                    .background(
                        Circle()
                            .fill(selectedOption == id ? style.getSelectedFillColor(for: theme) : Color.clear)
                            .padding(4)
                    )
                
                Text(options[id] ?? "")
                    .font(size.font)
                    .foregroundColor(isDisabled ? theme.textSecondary : theme.text)
            }
        }
        .buttonStyle(.plain)
    }
}
