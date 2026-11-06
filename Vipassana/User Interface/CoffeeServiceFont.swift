import Foundation
#if canImport(UIKit)
import UIKit
#endif

enum TitleFontChoice: Equatable {
    case named(String)
    case system
}

enum CoffeeServiceFont {
    static let familyName = "Coffee Service"

    static func selectTitleFont(registeredFamilyNames: [String], namedFontResolves: (String) -> Bool) -> TitleFontChoice {
        for name in registeredFamilyNames where !name.isEmpty {
            if namedFontResolves(name) {
                return .named(name)
            }
        }
        return .system
    }

    #if canImport(UIKit)
    static func titleFont(size: CGFloat) -> UIFont {
        let choice = selectTitleFont(
            registeredFamilyNames: UIFont.fontNames(forFamilyName: familyName),
            namedFontResolves: { name in
                UIFont(name: name, size: size) != nil
            }
        )
        if case .named(let name) = choice, let font = UIFont(name: name, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    #endif
}
