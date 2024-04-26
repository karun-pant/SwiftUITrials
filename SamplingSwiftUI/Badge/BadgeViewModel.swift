//
//  BadgeViewModel.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 24/04/24.
//


import Foundation
import SwiftUI

struct BadgeViewModel: Identifiable {
    var id: String {
        return title
    }
    let title: String
    let image: Image?
    let style: BadgeStyle
}

// MARK: Style

import SwiftUI

struct BadgeStyle {
    
    let titleColor: Color
    let backgroundColor: Color
    
    static var roundTrip: BadgeStyle {
        return BadgeStyle(titleColor: AssetColor.darkBlue.swiftUIColor,
                          backgroundColor: AssetColor.lightBlue.swiftUIColor)
    }
}
