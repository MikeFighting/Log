//
//  Extensions.swift
//  SwiftUIBootCamp
//
//  Created by MikeWong on 2023/7/11.
//

import Foundation
import SwiftUI

extension Color {
    
    /// 使用Hex初始化Color
    /// - Parameters:
    ///   - hex: hex数据，比如 0xFF00FF
    ///
    /// # Example
    ///
    /// ```
    /// let red = Color(0xFF0000)
    /// let translucentMagenta = Color(0xFF00FF, alpha: 0.4)
    /// ```
    init(_ hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
    
    func hexString()-> String {
        guard let components = UIColor(self).cgColor.components else{ return ""}
        let r: CGFloat = components[0]
        let g: CGFloat = components[1]
        let b: CGFloat = components[2]
        let hexString = String.init(format: "0x%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}
