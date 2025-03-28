import Foundation

extension Foundation.Bundle {
    static let module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("CodetwelveUI_CodetwelveUI.bundle").path
        let buildPath = "/Users/rakeshr/Documents/Projects/codetwelve/codetwelve-ios-ui/.build/arm64-apple-macosx/debug/CodetwelveUI_CodetwelveUI.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            // Users can write a function called fatalError themselves, we should be resilient against that.
            Swift.fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}