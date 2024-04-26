//
//  SliderCellView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 24/04/24.
//

import SwiftUI

struct SliderCellView: View {
    
    let parentWidth: CGFloat
    let viewModel: PLFlightSlidableCellViewModel
    
    
    @State private var offset = CGSize.zero
    @State private var itineraryViewHeight: CGFloat = 0
    @State private var opacity: CGFloat = 0.0
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in
                if value.translation.width < 0 {
                    offset = value.translation
                    opacity = abs(interpolateOpacity(value: offset.width * 3))
                }
            }
            .onEnded { value in
                if value.translation.width < 0 {
                    withAnimation {
                        offset = .init(width: -parentWidth/2, height: 0)
                        opacity = 1
                    }
                } else {
                    // This will happen on action of alert cancel
                    withAnimation {
                        offset = .zero
                        opacity = 0
                    }
                }
                viewModel.onSwipeComplete?()
            }
        ZStack(alignment: .trailing) {
            if let swipeActionViewModel = viewModel.swipeActionViewModel {
                HStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ItineraryInfoView.InfoText(swipeActionViewModel.title)
                            .foregroundStyle(.white)
                        Spacer()
                    }.frame(width: parentWidth/2)
                }
                .frame(width: parentWidth + 16, height:96)
                .background(swipeActionViewModel.colorName.swiftUIColor)
                .opacity(opacity)
            }
            VStack {
                ItineraryInfoView(viewModel: viewModel.itineraryInfoViewModel)
                .padding(.horizontal, 8)
                .offset(x: offset.width,
                        y: 0)
                .gesture(dragGesture)
            }
        }
    }
    
    /// This method interpolates offset value range to 0-1 opacity range.
    private func interpolateOpacity(value: CGFloat) -> CGFloat {
        return 0.0 + (1.0 - 0.0) * (value - 0.0) / (parentWidth - 0.0)
    }
}

#Preview {
    VStack(spacing: 16) {
        SliderCellView(
            parentWidth: 320,
            viewModel: .init(
                originCode: "NYC",
                destinationCode: "LAS",
                originDate: "May 29",
                destinationDate: "Jun 10",
                badgeViewModel: .init(title: "ROUND-TRIP",
                                      image: nil,
                                      style: .roundTrip),
                swipeActionViewModel: .init(title: "Stop Watching", isDestructive: true)))
        SliderCellView(
            parentWidth: 320,
            viewModel: .init(
                originCode: "NYC",
                destinationCode: "LAS",
                originDate: "May 29",
                destinationDate: "Jun 10",
                badgeViewModel: .init(title: "ONE-WAY",
                                      image: nil,
                                      style: .roundTrip),
                swipeActionViewModel: .init(title: "Watch Again", isDestructive: false)))
    }
}
