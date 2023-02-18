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
    let viewIndexForThreshold: Int
    let bgColor = [Color.indigo, Color.mint]
    @State private var viewIndexRect: CGRect = .zero

    var body: some View {
        
        // Way 1 Using Modifier
        
        VStack (alignment: .leading) {
            ForEach(0..<30) { i in
                HStack {
                    Text("Item \(i)")
                        .padding()
                    Spacer()
                }
                .frame(height: 100)
                .background(bgColor[ i % 2 ])
                .modifier(CoordinateSpaceFrameProvider(shouldIgnore: viewIndexForThreshold != i,
                                                       coordinateSpace: .named(coordinateSpaceID),
                                                       frame: { frame in
                    print("Index: \(i) rect: \(frame)")
                    viewIndexRect = frame
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
        
        /**
            
         // Way 2 Using Wrapper
         
         FloatingButtonScrollView(
             config: .init(bottomOffsetThreshold: viewIndexRect.maxY,
                           scrollCoordinateSpaceID: coordinateSpaceID,
                           scrollViewBGColor: .white),
             content: {
                 VStack (alignment: .leading) {
                     ForEach(0..<30) { i in
                         HStack {
                             Text("Item \(i)")
                                 .padding()
                             Spacer()
                         }
                         .frame(height: 100)
                         .background(bgColor[ i % 2 ])
                         .modifier(CoordinateSpaceFrameProvider(shouldIgnore: viewIndexForThreshold != i,
                                                                coordinateSpace: .named(coordinateSpaceID),
                                                                frame: { frame in
                             print("Index: \(i) rect: \(frame)")
                             viewIndexRect = frame
                         }))
                     }
                 }
             },
             floatingView: {
                 FloatingBookButton(viewModel: .init(title:"Complete Booking",
                                                     subTitle: "for $2990.10"))
             })
         */
    }
}

struct FabView_Previews: PreviewProvider {
    static var previews: some View {
        FabView(viewIndexForThreshold: 25)
    }
}
