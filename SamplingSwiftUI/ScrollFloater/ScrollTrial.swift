//
//  ScrollTrial.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 15/02/23.
//

import SwiftUI
import Combine

struct FabView: View {
    
    let coordinateSpaceID = "scroll"
    
    @State var showFab = false
    
    let viewIndexForThreshold: Int
    
    let bgColor = [Color.indigo, Color.mint]
    
    let scrollViewBGColor: Color = .white
    @State private var viewIndexRect: CGRect = .zero
    @State private var scrollViewSize: CGSize = .zero

    var body: some View {
        VStack (alignment: .leading) {
            ForEach(0..<30) { i in
                HStack {
                    Text("Item \(i)")
                        .padding()
                    Spacer()
                }
                .frame(height: 100)
                .background(bgColor[ i % 2 ])
                .modifier(CoordinateSpaceFrameProvider(coordinateSpaceID: coordinateSpaceID,
                                                       coordinateSpaceFrame: { frame in
                    if viewIndexForThreshold == i {
                        viewIndexRect = frame
                    }
                }))
            }
        }
        .modifier(FloatingButtonModifier(config: .init(bottomOffsetThreshold: viewIndexRect.maxY,
                                                       scrollCoordinateSpaceID: coordinateSpaceID,
                                                       scrollViewBGColor: .white),
                                         floatingView: {
            FloatingBookButton(viewModel: .init(title:"Complete Booking",
                                       subTitle: "for $2990.10"))
        }))
    }
}

struct FabView_Previews: PreviewProvider {
    static var previews: some View {
        FabView(viewIndexForThreshold: 25)
    }
}
