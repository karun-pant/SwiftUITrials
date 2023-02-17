//
//  CoordinateSpaceFrameProvider.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 17/02/23.
//

import SwiftUI

/// This will give frame of a view based on it's parent coordinate space
/// if it's named as passed in `coordinateSpaceID` else it will track global cordinate space.
struct CoordinateSpaceFrameProvider: ViewModifier {
    
    var coordinateSpaceID: String? = nil
    let coordinateSpaceFrame: (_ frame: CGRect) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader(content: { contentProxy in
                Color.clear.onAppear {
                    coordinateSpaceFrame(contentProxy.frame(in: coordinateSpaceID != nil
                                                            ? .named(coordinateSpaceID)
                                                            : .global))
                }
            }))
    }
}
