//
//  CTBottomSheet.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A bottom sheet component that slides up from the bottom of the screen.
///
/// `CTBottomSheet` provides a draggable sheet that appears from the bottom of the screen,
/// commonly used for presenting additional options or content without navigating away from
/// the current context.
///
/// # Example
///
/// ```swift
/// @State private var isPresented = false
///
/// Button("Show Bottom Sheet") {
///     isPresented = true
/// }
/// .ctBottomSheet(isPresented: $isPresented) {
///     VStack(spacing: CTSpacing.m) {
///         Text("Bottom Sheet Content")
///             .ctHeading2()
///         Text("This is a bottom sheet with custom content.")
///             .ctBody()
///     }
///     .padding()
/// }
/// ```
public struct CTBottomSheet<SheetContent: View>: ViewModifier {
    // MARK: - Public Properties
    
    /// The content to display in the bottom sheet
    private let sheetContent: SheetContent
    
    /// Whether the bottom sheet is presented
    @Binding private var isPresented: Bool
    
    /// The style of the bottom sheet
    private let style: CTBottomSheetStyle
    
    /// The height of the bottom sheet
    private let height: CTBottomSheetHeight
    
    /// Whether the bottom sheet should have a drag indicator
    private let showsDragIndicator: Bool
    
    /// Whether tapping the backdrop dismisses the bottom sheet
    private let closeOnBackdropTap: Bool
    
    /// Whether the bottom sheet can be dismissed by dragging down
    private let allowDragDismiss: Bool
    
    /// Action to perform when the bottom sheet is dismissed
    private let onDismiss: (() -> Void)?
    
    // MARK: - Environment Properties
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Private Properties
    
    /// The current drag offset
    @State private var dragOffset: CGFloat = 0
    
    /// The animation state of the sheet
    @State private var animationState: AnimationState = .dismissed
    
    /// Whether the sheet is being dragged
    @State private var isDragging = false
    
    /// The drag threshold for dismissal (as a percentage of the sheet height)
    private let dismissThreshold: CGFloat = 0.2
    
    /// Whether the dynamic height is calculated
    @State private var dynamicHeight: CGFloat = 0
    
    // MARK: - Initializers
    
    /// Initialize a new bottom sheet
    /// - Parameters:
    ///   - isPresented: Binding to control whether the sheet is presented
    ///   - style: The style of the bottom sheet
    ///   - height: The height of the bottom sheet
    ///   - showsDragIndicator: Whether to show a drag indicator at the top of the sheet
    ///   - closeOnBackdropTap: Whether tapping the backdrop dismisses the sheet
    ///   - allowDragDismiss: Whether the sheet can be dismissed by dragging down
    ///   - onDismiss: Action to perform when the sheet is dismissed
    ///   - content: Content builder for the sheet
    public init(
        isPresented: Binding<Bool>,
        style: CTBottomSheetStyle = .default,
        height: CTBottomSheetHeight = .medium,
        showsDragIndicator: Bool = true,
        closeOnBackdropTap: Bool = true,
        allowDragDismiss: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.style = style
        self.height = height
        self.showsDragIndicator = showsDragIndicator
        self.closeOnBackdropTap = closeOnBackdropTap
        self.allowDragDismiss = allowDragDismiss
        self.onDismiss = onDismiss
        self.sheetContent = content()
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented || animationState != .dismissed {
                ZStack {
                    // Backdrop
                    Color.black.opacity(backdropOpacity)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            if closeOnBackdropTap {
                                dismiss()
                            }
                        }
                    
                    // Sheet
                    VStack(spacing: 0) {
                        Spacer()
                        
                        VStack(spacing: 0) {
                            if showsDragIndicator {
                                dragIndicator
                            }
                            
                            sheetContent
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: HeightPreferenceKey.self,
                                            value: geo.size.height
                                        )
                                    }
                                )
                        }
                        .background(sheetBackground)
                        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
                        .offset(y: calculateVerticalOffset())
                        .gesture(dragGesture)
                        .shadow(color: theme.shadowColor.opacity(theme.shadowOpacity), radius: theme.shadowRadius, y: theme.shadowOffset.height)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isModal)
                .transition(.opacity)
                .animation(CTAnimation.slideIn, value: isPresented)
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    self.dynamicHeight = height
                }
            }
        }
        .onChange(of: isPresented) { newValue in
            if newValue {
                animationState = .presented
            } else {
                withAnimation(CTAnimation.slideIn) {
                    animationState = .dismissed
                }
            }
        }
    }
    
    // MARK: - Private Views
    
    /// The drag indicator view
    private var dragIndicator: some View {
        Rectangle()
            .fill(style.indicatorColor)
            .frame(width: 36, height: 5)
            .cornerRadius(2.5)
            .padding(.vertical, CTSpacing.s)
    }
    
    /// The sheet background view
    private var sheetBackground: some View {
        style.backgroundColor
            .cornerRadius(style.cornerRadius, corners: [.topLeft, .topRight])
    }
    
    // MARK: - Private Properties and Methods
    
    /// The backdrop opacity
    private var backdropOpacity: Double {
        let baseOpacity = style.backdropOpacity
        
        if animationState == .dismissed {
            return 0.0
        } else if isDragging {
            let dragPercentage = min(1.0, max(0.0, dragOffset / getSheetHeight()))
            return baseOpacity * (1.0 - dragPercentage)
        } else {
            return baseOpacity
        }
    }
    
    /// The drag gesture for the sheet
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if allowDragDismiss {
                    isDragging = true
                    dragOffset = max(0, value.translation.height)
                }
            }
            .onEnded { value in
                isDragging = false
                
                handleDragEnd()
            }
    }
    
    /// Calculate the vertical offset for the sheet
    private func calculateVerticalOffset() -> CGFloat {
        if animationState == .dismissed && !isPresented {
            return getSheetHeight()
        } else {
            return dragOffset
        }
    }
    
    /// Get the sheet height based on the height setting
    private func getSheetHeight() -> CGFloat {
        switch height {
        case .small:
            return UIScreen.main.bounds.height * 0.25
        case .medium:
            return UIScreen.main.bounds.height * 0.4
        case .large:
            return UIScreen.main.bounds.height * 0.7
        case .custom(let height):
            return height
        case .dynamic:
            return dynamicHeight
        }
    }
    
    /// Dismiss the bottom sheet
    private func dismiss() {
        withAnimation(CTAnimation.slideIn) {
            isPresented = false
        }
        onDismiss?()
    }
    
    private func handleDragEnd() {
        let shouldDismiss = dragOffset > getSheetHeight() * dismissThreshold && allowDragDismiss
        
        withAnimation(CTAnimation.slideIn) {
            if shouldDismiss {
                isPresented = false
                onDismiss?()
            } else {
                dragOffset = 0
            }
        }
    }
}

// MARK: - Supporting Types

/// The animation state of the bottom sheet
private enum AnimationState {
    /// The sheet is fully dismissed
    case dismissed
    
    /// The sheet is in the process of being dismissed
    case dismissing
    
    /// The sheet is fully presented
    case presented
}

/// Preference key for tracking content height
private struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// The style of the bottom sheet
public struct CTBottomSheetStyle {
    /// The background color of the sheet
    public let backgroundColor: Color
    
    /// The corner radius of the sheet
    public let cornerRadius: CGFloat
    
    /// The color of the drag indicator
    public let indicatorColor: Color
    
    /// The opacity of the backdrop
    public let backdropOpacity: Double
    
    /// Default bottom sheet style
    public static var `default`: CTBottomSheetStyle {
        CTBottomSheetStyle(
            backgroundColor: Color.ctSurface,
            cornerRadius: 16,
            indicatorColor: .ctBorder,
            backdropOpacity: 0.4
        )
    }
    
    /// Create a custom bottom sheet style
    /// - Parameters:
    ///   - backgroundColor: The background color of the sheet
    ///   - cornerRadius: The corner radius of the sheet
    ///   - indicatorColor: The color of the drag indicator
    ///   - backdropOpacity: The opacity of the backdrop
    public init(
        backgroundColor: Color,
        cornerRadius: CGFloat,
        indicatorColor: Color,
        backdropOpacity: Double
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.indicatorColor = indicatorColor
        self.backdropOpacity = backdropOpacity
    }
}

/// The height of the bottom sheet
public enum CTBottomSheetHeight {
    /// Small height (25% of screen height)
    case small
    
    /// Medium height (40% of screen height)
    case medium
    
    /// Large height (70% of screen height)
    case large
    
    /// Custom height in points
    case custom(CGFloat)
    
    /// Dynamic height based on content
    case dynamic
}

// MARK: - View Extensions

public extension View {
    /// Presents a bottom sheet when a binding to a Boolean value is true.
    ///
    /// # Example
    ///
    /// ```swift
    /// @State private var isPresented = false
    ///
    /// Button("Show Bottom Sheet") {
    ///     isPresented = true
    /// }
    /// .ctBottomSheet(isPresented: $isPresented) {
    ///     // Bottom sheet content
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the bottom sheet.
    ///   - style: The style of the bottom sheet.
    ///   - height: The height of the bottom sheet.
    ///   - showsDragIndicator: Whether to show a drag indicator at the top of the sheet.
    ///   - closeOnBackdropTap: Whether tapping the backdrop dismisses the sheet.
    ///   - allowDragDismiss: Whether the sheet can be dismissed by dragging down.
    ///   - onDismiss: Action to perform when the sheet is dismissed.
    ///   - content: A closure that returns the content of the bottom sheet.
    /// - Returns: A view that presents a bottom sheet when `isPresented` is true.
    func ctBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        style: CTBottomSheetStyle = .default,
        height: CTBottomSheetHeight = .medium,
        showsDragIndicator: Bool = true,
        closeOnBackdropTap: Bool = true,
        allowDragDismiss: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        self.modifier(
            CTBottomSheet(
                isPresented: isPresented,
                style: style,
                height: height,
                showsDragIndicator: showsDragIndicator,
                closeOnBackdropTap: closeOnBackdropTap,
                allowDragDismiss: allowDragDismiss,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
}

// MARK: - Shape Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Previews

//struct CTBottomSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomSheetPreviewContainer()
//            .ctTheme(CTDefaultTheme())
//    }
//    
//    private struct BottomSheetPreviewContainer: View {
//        @State private var isSmallSheetPresented = false
//        @State private var isMediumSheetPresented = false
//        @State private var isLargeSheetPresented = false
//        @State private var isCustomSheetPresented = false
//        @State private var isFullScreenSheetPresented = false
//        @State private var isDynamicSheetPresented = false
//        @Environment(\.ctTheme) private var theme
//        
//        var body: some View {
//            ScrollView {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Bottom Sheet Examples").ctHeading2()
//                    
//                    Button("Show Small Sheet") {
//                        isSmallSheetPresented = true
//                    }
//                    .ctButton(style: .primary)
//                    
//                    Button("Show Medium Sheet") {
//                        isMediumSheetPresented = true
//                    }
//                    .ctButton(style: .secondary)
//                    
//                    Button("Show Large Sheet") {
//                        isLargeSheetPresented = true
//                    }
//                    .ctButton(style: .outline)
//                    
//                    Button("Show Custom Sheet") {
//                        isCustomSheetPresented = true
//                    }
//                    .ctButton(style: .ghost)
//                    
//                    Button("Show Full Screen Sheet") {
//                        isFullScreenSheetPresented = true
//                    }
//                    .ctButton(style: .link)
//                    
//                    Button("Show Dynamic Sheet") {
//                        isDynamicSheetPresented = true
//                    }
//                    .ctButton(style: .primary)
//                }
//                .padding()
//            }
//            .ctBottomSheet(isPresented: $isSmallSheetPresented, size: 200) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Small Bottom Sheet").ctHeading2()
//                    Text("This sheet has a fixed height of 200 points.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctBottomSheet(isPresented: $isMediumSheetPresented, size: 400) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Medium Bottom Sheet").ctHeading2()
//                    Text("This sheet has a fixed height of 400 points.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctBottomSheet(isPresented: $isLargeSheetPresented, size: 600) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Large Bottom Sheet").ctHeading2()
//                    Text("This sheet has a fixed height of 600 points.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctBottomSheet(
//                isPresented: $isCustomSheetPresented,
//                style: CTBottomSheetStyle(
//                    backgroundColor: theme.primary,
//                    cornerRadius: 24,
//                    indicatorColor: .white
//                )
//            ) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Custom Bottom Sheet").ctHeading2()
//                        .foregroundColor(.white)
//                    Text("This sheet has custom styling with a primary color background.")
//                        .ctBody()
//                        .foregroundColor(.white)
//                }
//                .padding()
//            }
//            .ctBottomSheet(isPresented: $isFullScreenSheetPresented, size: nil) {
//                VStack(spacing: CTSpacing.m) {
//                    Text("Full Screen Bottom Sheet").ctHeading2()
//                    Text("This sheet takes up the entire screen.")
//                        .ctBody()
//                }
//                .padding()
//            }
//            .ctBottomSheet(isPresented: $isDynamicSheetPresented, size: nil) {
//                VStack(alignment: .leading, spacing: CTSpacing.m) {
//                    Text("Dynamic Bottom Sheet").ctHeading2()
//                    Text("This sheet adjusts its height based on the content.")
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

extension Color {
    static var sheetBackground: Color {
        Color(.systemBackground)
    }
}
