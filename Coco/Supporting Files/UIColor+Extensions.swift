//
//  UIColor+Extensions.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/07.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit

public extension UIColor {
    enum Color {
        case midnightBlue
        case washoutBlue
        case whiteBlue
        case midnightPink
        case midnightPurple
        case freshBlue

        var name: String {
            switch self {
            case .midnightBlue:
                return "Midnight Blue"
            case .washoutBlue:
                return "Washout Blue"
            case .whiteBlue:
                return "White Blue"
            case .midnightPink:
                return "Midnight Pink"
            case .midnightPurple:
                return "Midnight Purple"
            case .freshBlue:
                return "Fresh Blue"
            }
        }
    }
    
    convenience init(cocoColor: Color) {
        self.init(named: cocoColor.name)!
    }
}


