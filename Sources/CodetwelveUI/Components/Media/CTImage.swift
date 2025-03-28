//
//  CTImage.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable image component with loading states and fallback options.
///
/// `CTImage` provides a consistent image interface throughout your application
/// with support for both local and remote images, loading states, and fallback displays
/// when an image is unavailable or loading.
///
/// # Example
///
/// ```swift
/// // Local image
/// CTImage(image: Image("logo"))
///
/// // Remote image with URL
/// CTImage(url: URL(string: "https://example.com/image.jpg"))
///
/// // With placeholder
/// CTImage(
///     url: URL(string: "https://example.com/image.jpg"),
///     placeholder: Image(systemName: "photo")
/// )
///
/// // With custom styling
/// CTImage(image: Image("profile"))
///     .cornerRadius(40)
///     .bordered()
///     .shadowed()
/// ```
public struct CTImage: View {
    // MARK: - Public Properties
    
    /// The loading state of the image
    public enum LoadState {
        /// Image is loading from a URL
        case loading
        
        /// Image has been successfully loaded
        case loaded
        
        /// Failed to load image
        case failed
        
        /// Image is available and ready to display
        case ready
    }
    
    /// The content mode for the image
    public enum ContentMode {
        /// Fill the available space, potentially cropping the image
        case fill
        
        /// Fit the image within the available space, potentially showing empty space
        case fit
        
        /// Matching SwiftUI ContentMode value
        var swiftUIContentMode: SwiftUI.ContentMode {
            switch self {
            case .fill:
                return .fill
            case .fit:
                return .fit
            }
        }
    }
    
    // MARK: - Private Properties
    
    /// The local image
    private let image: Image?
    
    /// The remote image URL
    private let url: URL?
    
    /// The placeholder image when no image is available or during loading
    private let placeholder: Image?
    
    /// The content mode for the image
    private let contentMode: ContentMode
    
    /// Whether to show a loading indicator during image loading
    private let showLoadingIndicator: Bool
    
    /// The corner radius for the image
    private let cornerRadius: CGFloat
    
    /// Whether to apply a border to the image
    private let hasBorder: Bool
    
    /// The border color for the image
    private let borderColor: Color?
    
    /// The border width for the image
    private let borderWidth: CGFloat
    
    /// Whether to apply a shadow to the image
    private let hasShadow: Bool
    
    /// The shadow radius for the image
    private let shadowRadius: CGFloat
    
    /// The accessibility label for the image
    private let accessibilityLabel: String?
    
    /// Whether the image is decorative (for accessibility)
    private let isDecorative: Bool
    
    /// The current loading state of the image
    @State private var loadState: LoadState = .ready
    
    /// The loaded remote image
    @State private var loadedImage: Image? = nil
    
    /// The error message if image loading fails
    @State private var errorMessage: String? = nil
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize with a local image
    /// - Parameters:
    ///   - image: The local image to display
    ///   - contentMode: The content mode for the image
    ///   - cornerRadius: The corner radius for the image
    ///   - hasBorder: Whether to apply a border to the image
    ///   - borderColor: The border color for the image
    ///   - borderWidth: The border width for the image
    ///   - hasShadow: Whether to apply a shadow to the image
    ///   - shadowRadius: The shadow radius for the image
    ///   - accessibilityLabel: The accessibility label for the image
    ///   - isDecorative: Whether the image is decorative (for accessibility)
    public init(
        image: Image,
        contentMode: ContentMode = .fit,
        cornerRadius: CGFloat = 0,
        hasBorder: Bool = false,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        hasShadow: Bool = false,
        shadowRadius: CGFloat = 4,
        accessibilityLabel: String? = nil,
        isDecorative: Bool = false
    ) {
        self.image = image
        self.url = nil
        self.placeholder = nil
        self.contentMode = contentMode
        self.showLoadingIndicator = false
        self.cornerRadius = cornerRadius
        self.hasBorder = hasBorder
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.hasShadow = hasShadow
        self.shadowRadius = shadowRadius
        self.accessibilityLabel = accessibilityLabel
        self.isDecorative = isDecorative
    }
    
    /// Initialize with a URL for a remote image
    /// - Parameters:
    ///   - url: The URL for the remote image
    ///   - placeholder: The placeholder image to show during loading or on failure
    ///   - contentMode: The content mode for the image
    ///   - showLoadingIndicator: Whether to show a loading indicator during image loading
    ///   - cornerRadius: The corner radius for the image
    ///   - hasBorder: Whether to apply a border to the image
    ///   - borderColor: The border color for the image
    ///   - borderWidth: The border width for the image
    ///   - hasShadow: Whether to apply a shadow to the image
    ///   - shadowRadius: The shadow radius for the image
    ///   - accessibilityLabel: The accessibility label for the image
    ///   - isDecorative: Whether the image is decorative (for accessibility)
    public init(
        url: URL?,
        placeholder: Image? = nil,
        contentMode: ContentMode = .fit,
        showLoadingIndicator: Bool = true,
        cornerRadius: CGFloat = 0,
        hasBorder: Bool = false,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        hasShadow: Bool = false,
        shadowRadius: CGFloat = 4,
        accessibilityLabel: String? = nil,
        isDecorative: Bool = false
    ) {
        self.image = nil
        self.url = url
        self.placeholder = placeholder
        self.contentMode = contentMode
        self.showLoadingIndicator = showLoadingIndicator
        self.cornerRadius = cornerRadius
        self.hasBorder = hasBorder
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.hasShadow = hasShadow
        self.shadowRadius = shadowRadius
        self.accessibilityLabel = accessibilityLabel
        self.isDecorative = isDecorative
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // Background (if needed for visual consistency during loading)
            if hasBorder || cornerRadius > 0 {
                Rectangle()
                    .fill(Color.clear)
            }
            
            // Image content based on state
            Group {
                if let image = image {
                    // Local image - display directly
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode.swiftUIContentMode)
                } else if let loadedImage = loadedImage {
                    // Successfully loaded remote image
                    loadedImage
                        .resizable()
                        .aspectRatio(contentMode: contentMode.swiftUIContentMode)
                } else if loadState == .loading && showLoadingIndicator {
                    // Loading state with spinner
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.2)
                        .padding()
                } else if loadState == .failed || (loadState == .loading && !showLoadingIndicator) {
                    // Placeholder for failed load or during loading without spinner
                    placeholder?
                        .resizable()
                        .aspectRatio(contentMode: contentMode.swiftUIContentMode)
                        .foregroundColor(theme.textSecondary.opacity(0.5))
                } else if placeholder != nil {
                    // Just show placeholder if URL is nil but placeholder is provided
                    placeholder?
                        .resizable()
                        .aspectRatio(contentMode: contentMode.swiftUIContentMode)
                        .foregroundColor(theme.textSecondary.opacity(0.5))
                }
            }
            // Add visual styling
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        hasBorder ? (borderColor ?? theme.border) : Color.clear,
                        lineWidth: hasBorder ? borderWidth : 0
                    )
            )
            .shadow(
                color: hasShadow ? theme.shadowColor.opacity(theme.shadowOpacity) : Color.clear,
                radius: hasShadow ? shadowRadius : 0,
                x: hasShadow ? theme.shadowOffset.width : 0,
                y: hasShadow ? theme.shadowOffset.height : 0
            )
        }
        // Configure accessibility
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel ?? "Image")
        .accessibilityAddTraits(.isImage)
        .accessibilityHidden(isDecorative)
        // Load the image if URL is provided
        .onAppear {
            loadImageIfNeeded()
        }
        .onChange(of: url) { newURL in
            if newURL != url {
                loadImageIfNeeded()
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Load the image from the URL if needed
    private func loadImageIfNeeded() {
        // Reset state if we're reloading
        loadedImage = nil
        errorMessage = nil
        
        // Only attempt to load if we have a URL
        guard let url = url else {
            loadState = .ready
            return
        }
        
        // Set loading state and begin async loading
        loadState = .loading
        
        // Use URLSession to fetch the image data
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.loadState = .failed
                }
                return
            }
            
            // Ensure we have valid data and can create a UIImage
            guard let data = data, let uiImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid image data"
                    self.loadState = .failed
                }
                return
            }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.loadedImage = Image(uiImage: uiImage)
                self.loadState = .loaded
            }
        }.resume()
    }
}

// MARK: - View Extensions

public extension CTImage {
    /// Apply a corner radius to the image
    /// - Parameter radius: The corner radius to apply
    /// - Returns: A new image with the corner radius applied
    func cornerRadius(_ radius: CGFloat) -> CTImage {
        if self.image != nil {
            return CTImage(
                image: self.image!,
                contentMode: self.contentMode,
                cornerRadius: radius,
                hasBorder: self.hasBorder,
                borderColor: self.borderColor,
                borderWidth: self.borderWidth,
                hasShadow: self.hasShadow,
                shadowRadius: self.shadowRadius,
                accessibilityLabel: self.accessibilityLabel,
                isDecorative: self.isDecorative
            )
        } else {
            return CTImage(
                url: self.url,
                placeholder: self.placeholder,
                contentMode: self.contentMode,
                showLoadingIndicator: self.showLoadingIndicator,
                cornerRadius: radius,
                hasBorder: self.hasBorder,
                borderColor: self.borderColor,
                borderWidth: self.borderWidth,
                hasShadow: self.hasShadow,
                shadowRadius: self.shadowRadius,
                accessibilityLabel: self.accessibilityLabel,
                isDecorative: self.isDecorative
            )
        }
    }
    
    /// Apply a border to the image
    /// - Parameters:
    ///   - color: The color of the border (default: theme border color)
    ///   - width: The width of the border (default: 1)
    /// - Returns: A new image with the border applied
    func bordered(color: Color? = nil, width: CGFloat = 1) -> CTImage {
        if self.image != nil {
            return CTImage(
                image: self.image!,
                contentMode: self.contentMode,
                cornerRadius: self.cornerRadius,
                hasBorder: true,
                borderColor: color ?? self.borderColor,
                borderWidth: width,
                hasShadow: self.hasShadow,
                shadowRadius: self.shadowRadius,
                accessibilityLabel: self.accessibilityLabel,
                isDecorative: self.isDecorative
            )
        } else {
            return CTImage(
                url: self.url,
                placeholder: self.placeholder,
                contentMode: self.contentMode,
                showLoadingIndicator: self.showLoadingIndicator,
                cornerRadius: self.cornerRadius,
                hasBorder: true,
                borderColor: color ?? self.borderColor,
                borderWidth: width,
                hasShadow: self.hasShadow,
                shadowRadius: self.shadowRadius,
                accessibilityLabel: self.accessibilityLabel,
                isDecorative: self.isDecorative
            )
        }
    }
    
    /// Apply a shadow to the image
    /// - Parameter radius: The radius of the shadow (default: 4)
    /// - Returns: A new image with the shadow applied
    func shadowed(radius: CGFloat = 4) -> CTImage {
        if self.image != nil {
            return CTImage(
                image: self.image!,
                contentMode: self.contentMode,
                cornerRadius: self.cornerRadius,
                hasBorder: self.hasBorder,
                borderColor: self.borderColor,
                borderWidth: self.borderWidth,
                hasShadow: true,
                shadowRadius: radius,
                accessibilityLabel: self.accessibilityLabel,
                isDecorative: self.isDecorative
            )
        } else {
            return CTImage(
                url: self.url,
                placeholder: self.placeholder,
                contentMode: self.contentMode,
                showLoadingIndicator: self.showLoadingIndicator,
                cornerRadius: self.cornerRadius,
                hasBorder: self.hasBorder,
                borderColor: self.borderColor,
                borderWidth: self.borderWidth,
                hasShadow: true,
                shadowRadius: radius,
                accessibilityLabel: self.accessibilityLabel,
                isDecorative: self.isDecorative
            )
        }
    }
    
    /// Set the accessibility label for the image
    /// - Parameter label: The accessibility label
    /// - Returns: A new image with the accessibility label set
    func accessibilityImageLabel(_ label: String) -> CTImage {
        if self.image != nil {
            return CTImage(
                image: self.image!,
                contentMode: self.contentMode,
                cornerRadius: self.cornerRadius,
                hasBorder: self.hasBorder,
                borderColor: self.borderColor,
                borderWidth: self.borderWidth,
                hasShadow: self.hasShadow,
                shadowRadius: self.shadowRadius,
                accessibilityLabel: label,
                isDecorative: self.isDecorative
            )
        } else {
            return CTImage(
                url: self.url,
                placeholder: self.placeholder,
                contentMode: self.contentMode,
                showLoadingIndicator: self.showLoadingIndicator,
                cornerRadius: self.cornerRadius,
                hasBorder: self.hasBorder,
                borderColor: self.borderColor,
                borderWidth: self.borderWidth,
                hasShadow: self.hasShadow,
                shadowRadius: self.shadowRadius,
                accessibilityLabel: label,
                isDecorative: self.isDecorative
            )
        }
    }
    
    /// Mark the image as decorative for accessibility
    /// - Returns: A new image marked as decorative
    func decorative() -> CTImage {
        if self.image != nil {
            return CTImage(
                image: self.image!,
                contentMode: self.contentMode,
                cornerRadius: self.cornerRadius,
                hasBorder: self.hasBorder,
                borderColor: self.borderColor,
                borderWidth: self.borderWidth,
                hasShadow: self.hasShadow,
                shadowRadius: self.shadowRadius,
                accessibilityLabel: self.accessibilityLabel,
                isDecorative: true
            )
        } else {
            return CTImage(
                url: self.url,
                placeholder: self.placeholder,
                contentMode: self.contentMode,
                showLoadingIndicator: self.showLoadingIndicator,
                cornerRadius: self.cornerRadius,
                hasBorder: self.hasBorder,
                borderColor: self.borderColor,
                borderWidth: self.borderWidth,
                hasShadow: self.hasShadow,
                shadowRadius: self.shadowRadius,
                accessibilityLabel: self.accessibilityLabel,
                isDecorative: true
            )
        }
    }
}

// MARK: - Previews

struct CTImage_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: CTSpacing.m) {
                Group {
                    Text("Local Images").ctHeading2()
                    
                    CTImage(image: Image(systemName: "photo"))
                        .frame(height: 200)
                    
                    CTImage(
                        image: Image(systemName: "person.crop.circle.fill"),
                        contentMode: .fit,
                        cornerRadius: 8,
                        hasBorder: true
                    )
                    .frame(width: 150, height: 150)
                    
                    CTImage(
                        image: Image(systemName: "star.fill"),
                        contentMode: .fill,
                        cornerRadius: 75,
                        hasShadow: true
                    )
                    .frame(width: 150, height: 150)
                    .foregroundColor(.yellow)
                }
                
                Group {
                    Text("Remote Images").ctHeading2()
                    
                    CTImage(
                        url: URL(string: "https://picsum.photos/400/300"),
                        placeholder: Image(systemName: "photo"),
                        cornerRadius: 12
                    )
                    .frame(height: 200)
                    
                    CTImage(
                        url: URL(string: "https://picsum.photos/200"),
                        placeholder: Image(systemName: "person.crop.circle"),
                        contentMode: .fill,
                        cornerRadius: 100,
                        hasBorder: true,
                        borderColor: .ctPrimary,
                        borderWidth: 4,
                        hasShadow: true
                    )
                    .frame(width: 200, height: 200)
                    
                    CTImage(
                        url: URL(string: "https://invalid-url"),
                        placeholder: Image(systemName: "exclamationmark.triangle"),
                        showLoadingIndicator: false
                    )
                    .frame(height: 100)
                    .foregroundColor(.ctWarning)
                }
                
                Group {
                    Text("Modifier Extensions").ctHeading2()
                    
                    CTImage(image: Image(systemName: "photo"))
                        .cornerRadius(16)
                        .bordered(color: .ctPrimary, width: 2)
                        .shadowed(radius: 6)
                        .frame(width: 200, height: 150)
                    
                    CTImage(
                        url: URL(string: "https://picsum.photos/300/200"),
                        placeholder: Image(systemName: "photo")
                    )
                    .cornerRadius(8)
                    .bordered()
                    .accessibilityImageLabel("Sample landscape photo")
                    .frame(width: 200, height: 150)
                }
            }
            .padding()
        }
    }
}