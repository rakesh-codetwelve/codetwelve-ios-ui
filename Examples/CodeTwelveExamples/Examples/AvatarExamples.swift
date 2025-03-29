//
//  AvatarExamples.swift
//  CodeTwelveExamples
//
//  Created on 29/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view showcasing various examples of the `CTAvatar` component.
struct AvatarExamples: View {
    // MARK: - State Properties
    
    @State private var selectedSize: CTAvatar.Size = .medium
    @State private var selectedShape: ShapeOption = .circle
    @State private var selectedType: ContentType = .initials
    @State private var selectedBackgroundColor: Color = .ctPrimary
    @State private var showBorder: Bool = false
    @State private var showStatus: Bool = false
    @State private var statusColor: Color = .ctSuccess
    @State private var isInteractive: Bool = false
    @State private var initialsText: String = "AB"
    @State private var iconName: String = "person.fill"
    @State private var borderWidth: CGFloat = 2
    @State private var borderColor: Color = .ctPrimary
    @State private var tapCounter: Int = 0
    @State private var showCode: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.xl) {
                // Basic Usage Section
                Group {
                    SectionHeader(title: "Basic Usage", showCode: $showCode)
                    
                    Text("The CTAvatar component displays user avatars in different formats.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    basicUsageSection
                    
                    if showCode {
                        CodePreview("""
                        // Avatar with initials
                        CTAvatar(initials: "AB")
                        
                        // Avatar with SF Symbol icon
                        CTAvatar(icon: "person.fill")
                        
                        // Avatar with Image
                        CTAvatar(image: Image(systemName: "person.crop.circle.fill"))
                        """)
                    }
                }
                
                // Sizes Section
                Group {
                    Text("Sizes").ctHeading2()
                    
                    Text("Avatars come in various predefined sizes.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    sizesSection
                    
                    if showCode {
                        CodePreview("""
                        CTAvatar(initials: "XS", size: .extraSmall)
                        CTAvatar(initials: "SM", size: .small)
                        CTAvatar(initials: "MD", size: .medium)
                        CTAvatar(initials: "LG", size: .large)
                        CTAvatar(initials: "XL", size: .extraLarge)
                        CTAvatar(initials: "CU", size: .custom(72))
                        """)
                    }
                }
                
                // Shapes Section
                Group {
                    Text("Shapes").ctHeading2()
                    
                    Text("Avatars can be displayed in different shapes.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    shapesSection
                    
                    if showCode {
                        CodePreview("""
                        CTAvatar(initials: "AB", shape: .circle)
                        CTAvatar(initials: "AB", shape: .rounded(cornerRadius: 8))
                        CTAvatar(initials: "AB", shape: .square)
                        """)
                    }
                }
                
                // Variants Section
                Group {
                    Text("Variants").ctHeading2()
                    
                    Text("Avatars can include additional styling options.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    variantsSection
                    
                    if showCode {
                        CodePreview("""
                        // With border
                        CTAvatar(
                            initials: "AB", 
                            borderWidth: 2,
                            borderColor: .ctPrimary
                        )
                        
                        // With status indicator
                        CTAvatar(
                            initials: "AB",
                            showStatus: true,
                            statusColor: .ctSuccess
                        )
                        """)
                    }
                }
                
                // Interactive Avatar
                Group {
                    Text("Interactive Avatar").ctHeading2()
                    
                    Text("Avatars can be interactive to handle tap gestures.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    interactiveSection
                    
                    if showCode {
                        CodePreview("""
                        CTAvatar(
                            initials: "AB",
                            isInteractive: true
                        ) {
                            // Handle avatar tap
                            print("Avatar tapped")
                        }
                        """)
                    }
                }
                
                // Interactive Builder
                Group {
                    Text("Interactive Builder").ctHeading2()
                    
                    Text("Build your own avatar using the controls below.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    interactiveBuilderSection
                    
                    generatedAvatar
                    
                    if showCode {
                        CodePreview(generateAvatarCode())
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Avatar")
    }
    
    // MARK: - Example Sections
    
    private var basicUsageSection: some View {
        HStack(spacing: CTSpacing.l) {
            VStack {
                CTAvatar(initials: "AB")
                Text("Initials").ctCaption()
            }
            
            VStack {
                CTAvatar(icon: "person.fill")
                Text("Icon").ctCaption()
            }
            
            VStack {
                // Using an SF Symbol as a placeholder for a real image
                CTAvatar(image: Image(systemName: "person.crop.circle.fill"))
                Text("Image").ctCaption()
            }
        }
        .padding(.vertical)
    }
    
    private var sizesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: CTSpacing.l) {
                VStack {
                    CTAvatar(initials: "XS", size: .extraSmall)
                    Text("Extra Small").ctCaption()
                }
                
                VStack {
                    CTAvatar(initials: "SM", size: .small)
                    Text("Small").ctCaption()
                }
                
                VStack {
                    CTAvatar(initials: "MD", size: .medium)
                    Text("Medium").ctCaption()
                }
                
                VStack {
                    CTAvatar(initials: "LG", size: .large)
                    Text("Large").ctCaption()
                }
                
                VStack {
                    CTAvatar(initials: "XL", size: .extraLarge)
                    Text("Extra Large").ctCaption()
                }
                
                VStack {
                    CTAvatar(initials: "CU", size: .custom(72))
                    Text("Custom (72)").ctCaption()
                }
            }
            .padding(.vertical)
        }
    }
    
    private var shapesSection: some View {
        HStack(spacing: CTSpacing.l) {
            VStack {
                CTAvatar(initials: "AB", shape: .circle)
                Text("Circle").ctCaption()
            }
            
            VStack {
                CTAvatar(initials: "AB", shape: .rounded(cornerRadius: 8))
                Text("Rounded").ctCaption()
            }
            
            VStack {
                CTAvatar(initials: "AB", shape: .square)
                Text("Square").ctCaption()
            }
        }
        .padding(.vertical)
    }
    
    private var variantsSection: some View {
        HStack(spacing: CTSpacing.l) {
            VStack {
                CTAvatar(
                    initials: "AB",
                    borderWidth: 2,
                    borderColor: .ctPrimary
                )
                Text("With Border").ctCaption()
            }
            
            VStack {
                CTAvatar(
                    initials: "AB",
                    showStatus: true
                )
                Text("With Status").ctCaption()
            }
            
            VStack {
                CTAvatar(
                    initials: "AB",
                    showStatus: true,
                    statusColor: .ctWarning
                )
                Text("Custom Status").ctCaption()
            }
            
            VStack {
                CTAvatar(
                    initials: "AB",
                    backgroundColor: .purple
                )
                Text("Custom Color").ctCaption()
            }
        }
        .padding(.vertical)
    }
    
    private var interactiveSection: some View {
        HStack {
            VStack {
                CTAvatar(
                    initials: "AB",
                    size: .large,
                    borderWidth: 2,
                    borderColor: .ctPrimary,
                    isInteractive: true
                ) {
                    tapCounter += 1
                }
                
                Text("Tapped \(tapCounter) times").ctCaption()
            }
            
            Text("This avatar responds to taps. Try tapping it!")
                .ctBody()
                .padding()
                .background(Color.ctBackground)
                .cornerRadius(8)
        }
        .padding(.vertical)
    }
    
    private var interactiveBuilderSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Content type selector
            HStack {
                Text("Content Type:").ctBody().frame(width: 120, alignment: .leading)
                
                Picker("Content Type", selection: $selectedType) {
                    Text("Initials").tag(ContentType.initials)
                    Text("Icon").tag(ContentType.icon)
                    Text("Image").tag(ContentType.image)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Size selector
            HStack {
                Text("Size:").ctBody().frame(width: 120, alignment: .leading)
                
                Picker("Size", selection: $selectedSize) {
                    Text("XS").tag(CTAvatar.Size.extraSmall)
                    Text("S").tag(CTAvatar.Size.small)
                    Text("M").tag(CTAvatar.Size.medium)
                    Text("L").tag(CTAvatar.Size.large)
                    Text("XL").tag(CTAvatar.Size.extraLarge)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Shape selector
            HStack {
                Text("Shape:").ctBody().frame(width: 120, alignment: .leading)
                
                Picker("Shape", selection: $selectedShape) {
                    Text("Circle").tag(ShapeOption.circle)
                    Text("Rounded").tag(ShapeOption.rounded)
                    Text("Square").tag(ShapeOption.square)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Content-specific options
            if selectedType == .initials {
                HStack {
                    Text("Initials:").ctBody().frame(width: 120, alignment: .leading)
                    
                    TextField("Initials", text: $initialsText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                }
            } else if selectedType == .icon {
                HStack {
                    Text("Icon:").ctBody().frame(width: 120, alignment: .leading)
                    
                    TextField("SF Symbol Name", text: $iconName)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            // Color picker
            HStack {
                Text("Background:").ctBody().frame(width: 120, alignment: .leading)
                
                ColorPicker("", selection: $selectedBackgroundColor)
            }
            
            // Border options
            HStack {
                Toggle("Show Border", isOn: $showBorder)
                    .frame(width: 120, alignment: .leading)
                
                if showBorder {
                    ColorPicker("", selection: $borderColor)
                        .padding(.trailing)
                    
                    Stepper("Width: \(Int(borderWidth))", value: $borderWidth, in: 1...5, step: 1)
                }
            }
            
            // Status options
            HStack {
                Toggle("Show Status", isOn: $showStatus)
                    .frame(width: 120, alignment: .leading)
                
                if showStatus {
                    ColorPicker("", selection: $statusColor)
                }
            }
            
            // Interactive
            Toggle("Interactive", isOn: $isInteractive)
        }
        .padding()
        .background(Color.ctBackground)
        .cornerRadius(8)
    }
    
    // MARK: - Helper Views and Methods
    
    private var generatedAvatar: some View {
        VStack {
            Group {
                switch selectedType {
                case .initials:
                    CTAvatar(
                        initials: initialsText,
                        size: selectedSize,
                        shape: selectedShape.toAvatarShape(),
                        backgroundColor: selectedBackgroundColor,
                        borderWidth: showBorder ? borderWidth : 0,
                        borderColor: borderColor,
                        showStatus: showStatus,
                        statusColor: statusColor,
                        isInteractive: isInteractive
                    ) {
                        print("Interactive avatar tapped")
                    }
                case .icon:
                    CTAvatar(
                        icon: iconName,
                        size: selectedSize,
                        shape: selectedShape.toAvatarShape(),
                        backgroundColor: selectedBackgroundColor,
                        borderWidth: showBorder ? borderWidth : 0,
                        borderColor: borderColor,
                        showStatus: showStatus,
                        statusColor: statusColor,
                        isInteractive: isInteractive
                    ) {
                        print("Interactive avatar tapped")
                    }
                case .image:
                    CTAvatar(
                        image: Image(systemName: "person.crop.circle.fill"),
                        size: selectedSize,
                        shape: selectedShape.toAvatarShape(),
                        borderWidth: showBorder ? borderWidth : 0,
                        borderColor: borderColor,
                        showStatus: showStatus,
                        statusColor: statusColor,
                        isInteractive: isInteractive
                    ) {
                        print("Interactive avatar tapped")
                    }
                }
            }
            .frame(height: 100)
            
            Text("Generated Avatar")
                .ctBody()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.ctBackground)
        .cornerRadius(8)
    }
    
    private func generateAvatarCode() -> String {
        let sizeString: String
        switch selectedSize {
        case .extraSmall:
            sizeString = "size: .extraSmall"
        case .small:
            sizeString = "size: .small"
        case .medium:
            sizeString = "size: .medium"
        case .large:
            sizeString = "size: .large"
        case .extraLarge:
            sizeString = "size: .extraLarge"
        case .custom(let size):
            sizeString = "size: .custom(\(size))"
        }
        
        let shapeString: String
        switch selectedShape {
        case .circle:
            shapeString = "shape: .circle"
        case .rounded:
            shapeString = "shape: .rounded(cornerRadius: 8)"
        case .square:
            shapeString = "shape: .square"
        }
        
        let commonParams = [
            sizeString,
            shapeString,
            selectedType != .image ? "backgroundColor: Color(\"\(colorToHex(selectedBackgroundColor))\")" : nil,
            showBorder ? "borderWidth: \(borderWidth)" : nil,
            showBorder ? "borderColor: Color(\"\(colorToHex(borderColor))\")" : nil,
            showStatus ? "showStatus: true" : nil,
            showStatus ? "statusColor: Color(\"\(colorToHex(statusColor))\")" : nil,
            isInteractive ? "isInteractive: true" : nil
        ].compactMap { $0 }
        
        let contentParam: String
        switch selectedType {
        case .initials:
            contentParam = "initials: \"\(initialsText)\""
        case .icon:
            contentParam = "icon: \"\(iconName)\""
        case .image:
            contentParam = "image: Image(systemName: \"person.crop.circle.fill\")"
        }
        
        let actionParam = isInteractive ? """
        ) {
            // Handle tap action
        }
        """ : ")"
        
        return """
        CTAvatar(
            \(contentParam),
            \(commonParams.joined(separator: ",\n    "))
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

/// Options for the avatar content type
enum ContentType: Hashable {
    case initials
    case icon
    case image
}

/// Options for the avatar shape
enum ShapeOption: Hashable {
    case circle
    case rounded
    case square
    
    func toAvatarShape() -> CTAvatar.Shape {
        switch self {
        case .circle:
            return .circle
        case .rounded:
            return .rounded(cornerRadius: 8)
        case .square:
            return .square
        }
    }
}

// MARK: - Previews

struct AvatarExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AvatarExamples()
        }
    }
}
