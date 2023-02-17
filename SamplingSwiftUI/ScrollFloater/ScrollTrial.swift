//
//  ScrollTrial.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 15/02/23.
//

import SwiftUI
import Combine

struct FabView: View {
    @State var showFab = false
    let bgColor = [ColorUtil.random, ColorUtil.random]

    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                ForEach(0..<30) { i in
                    HStack {
                        Text("Item \(i)").padding()
                        Spacer()
                    }
                    .frame(height: 100)
                    .background(bgColor[ i % 2 ])
                }
            }.background(GeometryReader {
                return Color.clear.preference(key: ViewOffsetKey.self,
                                       value: -$0.frame(in: .named("scroll")).origin.y)
            })
            .onPreferenceChange(ViewOffsetKey.self) { offset in
             withAnimation {
              if offset > 200 {
               showFab = true
              } else  {
               showFab = false
              }
             }
            }
        }
        .coordinateSpace(name: "scroll")
        .overlay(
            showFab ?
            FloatingBookButton(viewModel: .init(title:"Complete Booking",
                                            subTitle: "for $2990.10"))
                : nil
            , alignment: Alignment.bottomTrailing)
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct FabView_Previews: PreviewProvider {
    static var previews: some View {
        FabView()
    }
}
