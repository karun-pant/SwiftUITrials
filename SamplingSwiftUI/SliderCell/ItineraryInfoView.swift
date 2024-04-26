//
//  ItineraryInfoView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 25/04/24.
//

import SwiftUI

struct ItineraryInfoView: View {
    
    let viewModel: ItineraryInfoViewModel
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            HStack(alignment: .center) {
                AssetImage.plane.image
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(16)
                    .background(AssetColor.lightBlue.swiftUIColor)
                    .clipShape(Circle())
                    .padding(.horizontal, 16)
                ItineraryInfo
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color:Color(white: 0, opacity: 0.12),
                radius: 6,
                y: 6)
        .onTapGesture {
            viewModel.onTap?()
        }
    }
    
    private var ItineraryInfo: some View {
        VStack(alignment:.leading, spacing: 4) {
            BadgeView(viewModel: viewModel.badgeViewModel)
                .padding(.bottom, 4)
            HStack {
                Self.InfoText(viewModel.originCode)
                Text(AssetImage.chevronRightSystemImage.systemImage)
                    .font(.system(size: 10, weight: .bold))
                Self.InfoText(viewModel.destinationCode)
            }
            HStack {
                Self.InfoText(viewModel.startDate)
                Self.InfoText("-")
                Self.InfoText(viewModel.endDate)
            }
        }
    }
    
    @ViewBuilder
    static func InfoText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .bold))
    }
}

#Preview {
    VStack(spacing: 16) {
        ItineraryInfoView(
            viewModel: .init(
                originCode: "NYC",
                destinationCode: "LAS",
                startDate: "May 29",
                endDate: "Jun 10",
                badgeViewModel: .init(title: "ROUND-TRIP",
                                      image: nil,
                                      style: .roundTrip)))
        
            ItineraryInfoView(
                viewModel: .init(
                    originCode: "NYC",
                    destinationCode: "LAS",
                    startDate: "May 29",
                    endDate: "Jun 10",
                    badgeViewModel: .init(title: "ONE-WAY",
                                          image: nil,
                                          style: .roundTrip)))
    }
}
