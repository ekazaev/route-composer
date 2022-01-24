//
// RouteComposer
// UIColor.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import UIKit

extension UIColor {

    convenience init(hexString: String) {
        if let rgbValue = UInt(hexString, radix: 16) {
            let red = CGFloat((rgbValue >> 16) & 0xFF) / 255
            let green = CGFloat((rgbValue >> 8) & 0xFF) / 255
            let blue = CGFloat(rgbValue & 0xFF) / 255
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }

}
