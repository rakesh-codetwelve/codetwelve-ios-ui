public struct CTDefaultTheme: CTTheme {
    // MARK: - Theme Identification
    public let name: String = "Default"
    
    // MARK: - Colors
    public let primary: Color = .accentColor
    public let secondary: Color = .gray
    public let background: Color = Color(.systemBackground)
    public let surface: Color = Color(.secondarySystemBackground)
    public let text: Color = Color(.label)
    public let textSecondary: Color = Color(.secondaryLabel)
    public let textOnAccent: Color = .white
    public let destructive: Color = .red
    public let success: Color = .green
    public let warning: Color = .yellow
    public let info: Color = .blue
    
    // MARK: - Borders
    public let border: Color = Color(.separator)
    public let borderWidth: CGFloat = 1
    public let borderRadius: CGFloat = 8
    
    // MARK: - Shadows
    public let shadowColor: Color = .black
    public let shadowOpacity: Double = 0.1
    public let shadowRadius: CGFloat = 4
    public let shadowOffset: CGSize = CGSize(width: 0, height: 2)
    
    // MARK: - Initialization
    public init() {}

    // MARK: - Button Styling
    public func buttonBackgroundColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .primary:
            return primary
        case .secondary:
            return secondary
        case .destructive:
            return destructive
        case .outline, .ghost, .link:
            return .clear
        }
    }
    
    public func buttonForegroundColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .primary, .secondary, .destructive:
            return textOnAccent
        case .outline:
            return primary
        case .ghost:
            return text
        case .link:
            return primary
        }
    }
    
    public func buttonBorderColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .outline:
            return primary
        case .primary, .secondary, .destructive, .ghost, .link:
            return .clear
        }
    }
} 