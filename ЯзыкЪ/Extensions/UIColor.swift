//
//  UIColor.swift
//  ЯзыкЪ
//
//  Created by Ярослав on 02.05.2022.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
    
    static var randomLight: UIColor {
        return UIColor(
            red: .random(in: 0.25...0.85),
            green: .random(in: 0.25...0.85),
            blue: .random(in: 0.25...0.85),
            alpha: 1.0
        )
    }
    
    static var randomDark: UIColor {
        return UIColor(
            red: .random(in: 0.15...0.75),
            green: .random(in: 0.15...0.75),
            blue: .random(in: 0.15...0.75),
            alpha: 1.0
        )
    }
}
