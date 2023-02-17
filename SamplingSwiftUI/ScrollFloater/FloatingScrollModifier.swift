//
//  FloatingScrollModifier.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 17/02/23.
//

import SwiftUI


struct ScrollTrackingButtonModifierConfig {
    let bottomOffsetThreshold: CGFloat
    let scrollCoordinateSpaceID: String
    let scrollViewBGColor: Color
}

struct FloatingButtonModifier: ViewModifier {
    
    struct ViewBottomOffsetKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
    
    @State private var showFloatingButton = false
    @State private var viewIndexRect: CGRect = .zero
    @State private var scrollViewSize: CGSize = .zero
    let config: ScrollTrackingButtonModifierConfig
    let floatingView: () -> FloatingBookButton
    
    func body(content: Content) -> some View {
        ScrollView {
            content
            .background(GeometryReader {
                Color.clear.preference(key: ViewBottomOffsetKey.self,
                                       value: -$0.frame(in: .named(config.scrollCoordinateSpaceID)).origin.y + scrollViewSize.height)
            })
            .onPreferenceChange(ViewBottomOffsetKey.self) { offset in
                withAnimation {
                    showFloatingButton = !(offset > config.bottomOffsetThreshold)
                }
            }
        }
        .coordinateSpace(name: config.scrollCoordinateSpaceID)
        .background(GeometryReader { scrollViewProxy in
            config.scrollViewBGColor.onAppear {
                scrollViewSize = scrollViewProxy.frame(in: .global).size
            }
        })
        .overlay(showFloatingButton
                 ? floatingView()
                 : nil,
                 alignment: Alignment.bottomTrailing)
    }
    
}

