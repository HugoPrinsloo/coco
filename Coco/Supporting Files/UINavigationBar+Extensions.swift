//
//  UINavigationBar+Extensions.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/07.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func configureNavigationBar(backgroundColor: UIColor, tintColor: UIColor, shadowColor: UIColor, textColor: UIColor, barStyle: UIBarStyle = UIBarStyle.default) {
        self.barStyle = barStyle
        self.tintColor = tintColor
        titleTextAttributes = [
            .foregroundColor: textColor,
            .font: UIFont.systemFont(ofSize: 16),
        ]
        
        largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        setBackgroundImage(UIImage.imageWithColor(backgroundColor, size: CGSize(width: 1.0, height: 1.0)), for: .default)
        shadowImage = UIImage.imageWithColor(shadowColor.withAlphaComponent(0.0), size: CGSize(width: 1.0, height: 1.0))
    }
}

