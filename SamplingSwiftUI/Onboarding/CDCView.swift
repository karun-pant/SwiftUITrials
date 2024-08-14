//
//  PLCarCDCVisibilityBannerView.swift
//  PLCar
//
//  Created by Amit Battan on 27/05/24.
//  Copyright © 2024 Priceline.com. All rights reserved.
//

import SwiftUI
//import PLUI
//import PLCarConfig

public struct PLCarCDCVisibilityBannerView: View {
    public var viewModel: PLCarCDCVisibilityBannerViewModel
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
//                Spacer()
                AssetImage.plane.image
                    .resizable()
                    .frame(width: 13, height: 13)
                    .background(.red)
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(viewModel.title)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AssetColor.darkText.swiftUIColor)
                            .id("rcCDAVisibilityBannerTitle")
                        if let subTitle = viewModel.subTitle {
                            Text(subTitle)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AssetColor.darkText.swiftUIColor)
                                .id("rcCDAVisibilityBannerSubTitle")
                        }
                    }
                    Spacer()
                }
                .background(.green)
//                Spacer()
                if let ctaTitle = viewModel.ctaTitle {
                    Button(action: {
                        viewModel.onCTATap()
                    }) {
                        HStack {
                            Text(ctaTitle)
                                .font(.system(size: 14, weight: .bold))
                                .id("rcCDAVisibilityBannerCTATitle")
                        }
                    }
                    .id("rcCDAVisibilityBannerCTA")
//                    .padding(.trailing, 8)
                }
            }
            .background(.yellow)
//            .frame(width: 375)
            .padding(8)
            //            .background(PLCarColor.priclineLightBlue.swiftUIColor)
            //            .cornerRadius(8)
        }
//        .padding(.horizontal ,8)
        .background(AssetColor.lightBlue.swiftUIColor)
//        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .cornerRadius(12)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.25),
                  radius: 12)
    }
    
    public static func heightOf(viewModel: PLCarCDCVisibilityBannerViewModel) -> CGFloat {
        return 100
    }

}

#Preview {
    PLCarCDCVisibilityBannerView(viewModel: PLCarCDCVisibilityBannerViewModel(title: "Worried about road accidents?", subTitle: AttributedString("Get Collision Damage Coverage for $55.67/day (total $111.1)"), ctaTitle: "Add", onCTATap: {
    }))
}
