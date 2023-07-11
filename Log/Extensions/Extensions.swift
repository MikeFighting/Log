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
    
    init(hex: String) {
        var result = hex
        if(result.hasPrefix("0x") || result.hasPrefix("0X")) {
            result.removeFirst()
            result.removeFirst()
        }
        let hex = result.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
