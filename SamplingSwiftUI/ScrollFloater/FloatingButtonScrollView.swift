//
//  FloatingButtonScrollView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 18/02/23.
//

import SwiftUI

struct ViewBottomOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct FloatingButtonScrollView<Content: View>: View {
    
    let config: ScrollTrackingButtonModifierConfig
    let content: () -> Content
    let floatingView: () -> FloatingBookButton
    @State private var showFloatingButton = false
    @State private var scrollViewSize: CGSize = .zero
    
    var body: some View {
        ScrollView {
            content()
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
