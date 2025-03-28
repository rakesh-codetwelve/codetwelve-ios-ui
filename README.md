# CodetwelveUI

A SwiftUI native iOS design library inspired by shadcn, providing customizable, accessible UI components.

## Overview

CodetwelveUI is a comprehensive design system for iOS applications built with SwiftUI. It provides a set of customizable, accessible UI components that can be used to build beautiful, consistent interfaces.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/rakesh-codetwelve/codetwelve-ios-ui.git", from: "1.0.0")
]
```

Or add it directly in Xcode:
1. Go to `File` > `Add Packages...`
2. Enter the repository URL: `https://github.com/rakesh-codetwelve/codetwelve-ios-ui.git`
3. Select the version you want to use

## Usage

Import the library in your Swift files:

```swift
import CodetwelveUI
```

Then use the components with the CT prefix:

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            CTButton("Press Me", style: .primary) {
                print("Button pressed")
            }
        }
    }
}
```

## Project Structure

- `Sources` - Main source code
  - `CodetwelveUI` - Main library module
    - `Components` - All UI components
    - `Tokens` - Design tokens
    - `Extensions` - Swift extensions
    - `Utilities` - Utility functions and helpers
    - `Hooks` - SwiftUI property wrappers
    - `Themes` - Theming system
    - `Resources` - Assets and resources
- `Examples` - Example app showcasing components
- `Tests` - Unit and UI tests

## Documentation

For full documentation, visit the [wiki](https://github.com/rakesh-codetwelve/codetwelve-ios-ui/wiki).

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Features

- **Comprehensive Component Library**: Complete collection of UI components including buttons, cards, forms, navigation elements, and more
- **Accessibility First**: Built with iOS accessibility features in mind
- **Theming System**: Support for light/dark mode and custom themes
- **SwiftUI Native**: Built from the ground up with SwiftUI
- **iOS 16+ Compatible**: Designed to work with the latest iOS features
