private struct DefaultPlaceholderTheme: CTTheme {
    // MARK: - Theme Identification
    var name: String = "Default Placeholder"
    
    // MARK: - Colors
    var primary: Color = .accentColor
    var secondary: Color = .gray
    var background: Color = Color(.systemBackground)
    var surface: Color = Color(.secondarySystemBackground)
    var text: Color = Color(.label)
    var textSecondary: Color = Color(.secondaryLabel)
    var textOnAccent: Color = .white
    var destructive: Color = .red
    var success: Color = .green
    var warning: Color = .yellow
    var info: Color = .blue
    
    // MARK: - Borders
    var border: Color = Color(.separator)
    var borderWidth: CGFloat = 1
    var borderRadius: CGFloat = 8
    
    // MARK: - Shadows
    var shadowColor: Color = .black
    var shadowOpacity: Double = 0.1
    var shadowRadius: CGFloat = 4
    var shadowOffset: CGSize = CGSize(width: 0, height: 2)
} 