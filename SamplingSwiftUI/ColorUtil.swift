//
//  ColorUtil.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 17/02/23.
//

import SwiftUI

struct ColorUtil {
    static func color(_ hex: UInt, alpha: Double = 1) -> Color {
        //background: #00AA00;
        return .init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
    
    static var random: Color {
        Color(red: CGFloat(arc4random()) / CGFloat(UInt32.max),
              green: CGFloat(arc4random()) / CGFloat(UInt32.max),
              blue: CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}
