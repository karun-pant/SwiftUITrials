//
//  AssetImage.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 26/04/23.
//

import SwiftUI
import UIKit

enum AssetImage: String {
    
    case downArrowSystemImage = "chevron.down"
    case xMarkSystemImage = "xmark.circle.fill"
    case errorSystemImage = "exclamationmark.circle.fill"
    case tickSystemImage = "checkmark.circle.fill"
    case chevronRightSystemImage = "chevron.right"
    case checkmarkSystemImage = "checkmark"
    case lock = "envelope.fill"
    case canAir = "can_air"
    case plane = "aeroplane"

    // MARK: -
    // to access images use PLCheckout.calender.image (swiftUI) or PLCheckout.calender.uiImage (UIImage)
    
    var image: Image {
        Image(self.rawValue)
    }
    
    var uiImage: UIImage? {
        UIImage(named: self.rawValue)
    }
    
    var systemImage: Image {
        Image(systemName: self.rawValue)
   }
}

