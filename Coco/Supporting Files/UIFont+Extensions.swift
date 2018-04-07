//
//  UIFont+Extensions.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/07.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit
import CoreText

class BundleClass {
}

public struct FontRegistrar {
    public static func registerBundledFonts() {
        let fontsToRegister = Bundle(for: BundleClass.self).paths(forResourcesOfType: "otf", inDirectory: nil).map({ URL(fileURLWithPath: $0) })
        CTFontManagerRegisterFontsForURLs(fontsToRegister as CFArray, CTFontManagerScope.process, nil)
    }
}

public extension UIFont {
    
    public enum CocoFont {
        case bold
        case heavy
        case light
        case medium
        case regular
        case semibold
        
        var fontName: String {
            switch self {
            case .bold: return "SFProText-Bold"
            case .heavy: return "SFProText-Heavy"
            case .light: return "SFProText-Light"
            case .medium: return "SFProText-Medium"
            case .regular: return "SFProText-Regular"
            case .semibold: return "SFProText-Semibold"
            }
        }
    }
    
    public convenience init(cocoFont: CocoFont, size: CGFloat) {
        FontRegistrar.registerBundledFonts()
        self.init(name: cocoFont.fontName, size: size)!
    }
}


