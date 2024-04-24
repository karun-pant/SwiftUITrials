//
//  AssetColor.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 26/04/23.
//

import UIKit
import SwiftUI

enum AssetColor: String {

    case darkBlue = "contentDarkBlue_004499"
    case lightBlue = "lightBlue_E8F2FF"
    case darkText = "darkText_001833"
    case greenHighlight = "greenHighlight_D0F1AC"
    case pclnBlue = "pclnBlue_0068EF"
    case lightContent = "lightContent_4F6F8F"
    case benefitBG = "benefitBG_ECF7EC"
    case benefitAsset = "benefitAsset_00AA00"
    case bookBtnBG = "bookBtnBG_F5F5F5_80"
    case bookBtnShadow = "bookBtnShadow_000000_14"
    case baseBG = "baseBG_EDF0F3"
    case urgencyContent = "red_CC0000"
    case lightContentWithOpacity = "gray_4f6f8f"
    case darkGray = "darkGray_364049"
    case grayBorder = "grayBorder_C0CAD5"
    case lightRed = "lightRed_FBEBEB"
    case pickerColor = "pickerColor_D2D3D8"
    case warningLightBG = "warningLightBG_FFF3C0"
    case keyboardToolBarBG = "kbToolbar_F7F8F7"

    var uiColor:UIColor? {
        UIColor(named: self.rawValue)
    }

    var swiftUIColor: Color {
        Color(uiColor ?? .white)
    }
}
