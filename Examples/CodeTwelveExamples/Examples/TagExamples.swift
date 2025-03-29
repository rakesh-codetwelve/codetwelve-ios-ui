//
//  TagExamples.swift
//  CodeTwelveExamples
//
//  Created on 29/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view showcasing various examples of the `CTTag` component.
struct TagExamples: View {
    // MARK: - State Properties
    
    @State private var selectedStyle: TagStyle = .default
    @State private var selectedSize: CTTag.Size = .medium
    @State private var tagText: String = "Tag"
    @State private var tagIcon: String = "tag.fill"
    @State private var showIcon: Bool = false
    @State private var isRemovable: Bool = false
    @State private var showCode: Bool = false
    @State private var removedTags: [String] = []
    @State private var customTagColor: Color = .purple
    
    // Custom tags for the removal example
    @State private var tags = [
        "Design",
        "Development",
        "UI/UX",
        "Swift",
        "SwiftUI"
    ]
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.xl) {
                // Basic Usage
                Group {
                    SectionHeader(title: "Basic Usage", showCode: $showCode)
                    
                    Text("Tags are small components used to visually label and categorize content.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    basicUsageSection
                    
                    if showCode {
                        CodePreview(code: """
                        // Basic tag
                        CTTag("Tag")
                        
                        // Tag with icon
                        CTTag("Design", icon: "pencil")
                        
                        // Removable tag
                        CTTag("Remove", isRemovable: true) {
                            // Handle removal
                        }
                        """)
                    }
                }
                
                // Tag Styles
                Group {
                    Text("Tag Styles").ctHeading2()
                    
                    Text("Tags come in different styles to convey different meanings.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    tagStylesSection
                    
                    if showCode {
                        CodePreview(code: """
                        CTTag("Default", style: .default)
                        CTTag("Primary", style: .primary)
                        CTTag("Secondary", style: .secondary)
                        CTTag("Success", style: .success)
                        CTTag("Warning", style: .warning)
                        CTTag("Error", style: .error)
                        """)
                    }
                }
                
                // Tag Sizes
                Group {
                    Text("Tag Sizes").ctHeading2()
                    
                    Text("Tags are available in different sizes.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    tagSizesSection
                    
                    if showCode {
                        CodePreview(code: """
                        CTTag("Small", size: .small)
                        CTTag("Medium", size: .medium)
                        CTTag("Large", size: .large)
                        """)
                    }
                }
                
                // Tags with Icons
                Group {
                    Text("Tags with Icons").ctHeading2()
                    
                    Text("Tags can include icons to provide additional visual cues.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    tagsWithIconsSection
                    
                    if showCode {
                        CodePreview(code: """
                        CTTag("Design", icon: "pencil")
                        CTTag("Important", icon: "star.fill", style: .primary)
                        CTTag("Warning", icon: "exclamationmark.triangle.fill", style: .warning)
                        CTTag("Error", icon: "xmark.circle.fill", style: .error)
                        """)
                    }
                }
                
                // Removable Tags
                Group {
                    Text("Removable Tags").ctHeading2()
                    
                    Text("Tags can be removable with an X button that triggers an action.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    removableTagsSection
                    
                    if showCode {
                        CodePreview(code: """
                        CTTag("Remove Me", isRemovable: true) {
                            // Handle removal
                        }
                        """)
                    }
                }
                
                // Custom Tags
                Group {
                    Text("Custom Tags").ctHeading2()
                    
                    Text("Tags can be customized with your own colors.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    customTagsSection
                    
                    if showCode {
                        CodePreview(code: """
                        CTTag("Custom", 
                              style: .custom(
                                backgroundColor: Color.purple.opacity(0.1),
                                foregroundColor: Color.purple
                              )
                        )
                        """)
                    }
                }
                
                // Tag Builder
                Group {
                    Text("Tag Builder").ctHeading2()
                    
                    Text("Build your own tag using the controls below.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    tagBuilderSection
                    
                    generatedTag
                    
                    if showCode {
                        CodePreview(code: generateTagCode())
                    }
                }
                
                // Real-world Example
                Group {
                    Text("Real-world Example").ctHeading2()
                    
                    Text("An example of tags in a real-world scenario.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    realWorldExample
                }
            }
            .padding()
        }
        .navigationTitle("Tag")
    }
    
    // MARK: - Example Sections
    
    private var basicUsageSection: some View {
        HStack(spacing: CTSpacing.l) {
            CTTag("Tag")
            
            CTTag("Design", icon: "pencil")
            
            CTTag("Remove", isRemovable: true) {
                // In a real app, this would remove the tag
                print("Tag removed")
            }
        }
        .padding(.vertical)
    }
    
    private var tagStylesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: CTSpacing.m) {
                CTTag("Default", style: .default)
                CTTag("Primary", style: .primary)
                CTTag("Secondary", style: .secondary)
                CTTag("Success", style: .success)
                CTTag("Warning", style: .warning)
                CTTag("Error", style: .error)
            }
            .padding(.vertical)
        }
    }
    
    private var tagSizesSection: some View {
        HStack(spacing: CTSpacing.l) {
            CTTag("Small", size: .small)
            CTTag("Medium", size: .medium)
            CTTag("Large", size: .large)
        }
        .padding(.vertical)
    }
    
    private var tagsWithIconsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: CTSpacing.m) {
                CTTag("Design", icon: "pencil")
                CTTag("Important", icon: "star.fill", style: .primary)
                CTTag("Warning", icon: "exclamationmark.triangle.fill", style: .warning)
                CTTag("Error", icon: "xmark.circle.fill", style: .error)
                CTTag("Locked", icon: "lock.fill", style: .secondary)
                CTTag("Success", icon: "checkmark.circle.fill", style: .success)
            }
            .padding(.vertical)
        }
    }
    
    private var removableTagsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: CTSpacing.m) {
                    ForEach(tags.filter { !removedTags.contains($0) }, id: \.self) { tag in
                        CTTag(tag, style: .primary, isRemovable: true) {
                            withAnimation {
                                removedTags.append(tag)
                            }
                        }
                    }
                    
                    if tags.count == removedTags.count {
                        Text("All tags removed")
                            .ctBodySmall()
                            .foregroundColor(.ctTextSecondary)
                    }
                }
                .padding(.vertical)
            }
            
            if !removedTags.isEmpty {
                Button("Reset Tags") {
                    withAnimation {
                        removedTags.removeAll()
                    }
                }
            }
        }
    }
    
    private var customTagsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            HStack(spacing: CTSpacing.m) {
                CTTag("Custom Purple",
                      style: .custom(
                        backgroundColor: Color.purple.opacity(0.1),
                        foregroundColor: Color.purple
                      ))
                
                CTTag("Custom Orange",
                      icon: "tag.fill",
                      style: .custom(
                        backgroundColor: Color.orange.opacity(0.1),
                        foregroundColor: Color.orange
                      ))
                
                CTTag("Custom Teal",
                      style: .custom(
                        backgroundColor: Color.teal.opacity(0.1),
                        foregroundColor: Color.teal
                      ),
                      isRemovable: true) {
                    print("Custom tag removed")
                }
            }
            
            ColorPicker("Choose a custom color:", selection: $customTagColor)
                .padding(.top)
            
            CTTag("Custom Color",
                  style: .custom(
                    backgroundColor: customTagColor.opacity(0.1),
                    foregroundColor: customTagColor
                  ))
        }
        .padding(.vertical)
    }
    
    private var tagBuilderSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Text input
            HStack {
                Text("Text:").ctBody().frame(width: 120, alignment: .leading)
                
                TextField("Tag Text", text: $tagText)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Style selector
            HStack {
                Text("Style:").ctBody().frame(width: 120, alignment: .leading)
                
                Picker("Style", selection: $selectedStyle) {
                    Text("Default").tag(TagStyle.default)
                    Text("Primary").tag(TagStyle.primary)
                    Text("Secondary").tag(TagStyle.secondary)
                    Text("Success").tag(TagStyle.success)
                    Text("Warning").tag(TagStyle.warning)
                    Text("Error").tag(TagStyle.error)
                    Text("Custom").tag(TagStyle.custom)
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            // Size selector
            HStack {
                Text("Size:").ctBody().frame(width: 120, alignment: .leading)
                
                Picker("Size", selection: $selectedSize) {
                    Text("Small").tag(CTTag.Size.small)
                    Text("Medium").tag(CTTag.Size.medium)
                    Text("Large").tag(CTTag.Size.large)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Icon options
            HStack {
                Toggle("Show Icon", isOn: $showIcon)
                    .frame(width: 120, alignment: .leading)
                
                if showIcon {
                    TextField("SF Symbol Name", text: $tagIcon)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            // Custom color (if custom style is selected)
            if selectedStyle == .custom {
                ColorPicker("Custom Color:", selection: $customTagColor)
            }
            
            // Removable toggle
            Toggle("Removable", isOn: $isRemovable)
        }
        .padding()
        .background(Color.ctBackground)
        .cornerRadius(8)
    }
    
    private var generatedTag: some View {
        VStack {
            Group {
                switch selectedStyle {
                case .default:
                    CTTag(
                        tagText,
                        icon: showIcon ? tagIcon : nil,
                        style: .default,
                        size: selectedSize,
                        isRemovable: isRemovable
                    ) {
                        print("Tag removed")
                    }
                case .primary:
                    CTTag(
                        tagText,
                        icon: showIcon ? tagIcon : nil,
                        style: .primary,
                        size: selectedSize,
                        isRemovable: isRemovable
                    ) {
                        print("Tag removed")
                    }
                case .secondary:
                    CTTag(
                        tagText,
                        icon: showIcon ? tagIcon : nil,
                        style: .secondary,
                        size: selectedSize,
                        isRemovable: isRemovable
                    ) {
                        print("Tag removed")
                    }
                case .success:
                    CTTag(
                        tagText,
                        icon: showIcon ? tagIcon : nil,
                        style: .success,
                        size: selectedSize,
                        isRemovable: isRemovable
                    ) {
                        print("Tag removed")
                    }
                case .warning:
                    CTTag(
                        tagText,
                        icon: showIcon ? tagIcon : nil,
                        style: .warning,
                        size: selectedSize,
                        isRemovable: isRemovable
                    ) {
                        print("Tag removed")
                    }
                case .error:
                    CTTag(
                        tagText,
                        icon: showIcon ? tagIcon : nil,
                        style: .error,
                        size: selectedSize,
                        isRemovable: isRemovable
                    ) {
                        print("Tag removed")
                    }
                case .custom:
                    CTTag(
                        tagText,
                        icon: showIcon ? tagIcon : nil,
                        style: .custom(
                            backgroundColor: customTagColor.opacity(0.1),
                            foregroundColor: customTagColor
                        ),
                        size: selectedSize,
                        isRemovable: isRemovable
                    ) {
                        print("Tag removed")
                    }
                }
            }
            
            Text("Generated Tag")
                .ctBody()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.ctBackground)
        .cornerRadius(8)
    }
    
    private var realWorldExample: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Blog Post Categories")
                .ctHeading3()
            
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: CTSpacing.xs) {
                        CTTag("Swift", icon: "swift", style: .primary)
                        CTTag("iOS", icon: "apple.logo", style: .secondary)
                        CTTag("SwiftUI", icon: "app.badge", style: .primary)
                        CTTag("Tutorial", icon: "book.fill", style: .success)
                        CTTag("Advanced", icon: "star.fill", style: .warning)
                    }
                }
            }
            
            Divider().padding(.vertical, CTSpacing.s)
            
            Text("Product Filtering")
                .ctHeading3()
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Selected Filters:").ctBodyBold()
                
                HStack {
                    CTTag("In Stock", icon: "checkmark.circle.fill", style: .success, isRemovable: true) { }
                    CTTag("Free Shipping", icon: "shippingbox.fill", style: .primary, isRemovable: true) { }
                    CTTag("On Sale", icon: "tag.fill", style: .error, isRemovable: true) { }
                }
            }
            .padding()
            .background(Color.ctBackground)
            .cornerRadius(8)
        }
        .padding(.vertical)
    }
    
    // MARK: - Helper Methods
    
    private func generateTagCode() -> String {
        let iconParam = showIcon ? "icon: \"\(tagIcon)\"," : ""
        
        let styleParam: String
        switch selectedStyle {
        case .default:
            styleParam = "style: .default,"
        case .primary:
            styleParam = "style: .primary,"
        case .secondary:
            styleParam = "style: .secondary,"
        case .success:
            styleParam = "style: .success,"
        case .warning:
            styleParam = "style: .warning,"
        case .error:
            styleParam = "style: .error,"
        case .custom:
            styleParam = """
            style: .custom(
                backgroundColor: Color("\(colorToHex(customTagColor))").opacity(0.1),
                foregroundColor: Color("\(colorToHex(customTagColor))")
            ),
            """
        }
        
        let sizeParam: String
        switch selectedSize {
        case .small:
            sizeParam = "size: .small,"
        case .medium:
            sizeParam = "size: .medium,"
        case .large:
            sizeParam = "size: .large,"
        }
        
        let removableParam = isRemovable ? "isRemovable: true" : ""
        
        let actionParam = isRemovable ? """
        ) {
            // Handle tag removal
        }
        """ : ")"
        
        return """
        CTTag(
            "\(tagText)",
            \(iconParam)
            \(styleParam)
            \(sizeParam)
            \(removableParam)
        \(actionParam)
        """
    }
    
    private func colorToHex(_ color: Color) -> String {
        // This is a simplified placeholder - in a real app, you would use
        // a proper color-to-hex conversion method
        return "#color"
    }
}

// MARK: - Supporting Types

enum TagStyle {
    case `default`
    case primary
    case secondary
    case success
    case warning
    case error
    case custom
}

// MARK: - Previews

struct TagExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TagExamples()
        }
    }
}
