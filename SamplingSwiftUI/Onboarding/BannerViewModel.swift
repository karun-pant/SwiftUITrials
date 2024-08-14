//
//  BannerViewModel.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 28/05/24.
//

import Foundation

@objc public class PLCarCDCVisibilityBannerViewModel: NSObject {
    let title: String
    let subTitle: AttributedString?
    let ctaTitle: String?
    public var onCTATap: () -> ()?
    
    public init(title: String,
                subTitle: AttributedString?,
                ctaTitle: String?,
                onCTATap: @escaping () -> ()?) {
        self.title = title
        self.subTitle = subTitle
        self.ctaTitle = ctaTitle
        self.onCTATap = onCTATap
    }
}
