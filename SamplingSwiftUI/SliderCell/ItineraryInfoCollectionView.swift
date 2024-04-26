//
//  ItineraryInfoCollectionView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 25/04/24.
//

import SwiftUI

struct ItineraryInfoCollectionView: View {
    
    let parentViewWidth: CGFloat
    let infoViewModels: [ItineraryInfoViewModel]
    
    var body: some View {
        if infoViewModels.count == 1,
           let viewModel = infoViewModels.first {
            ItineraryInfoView(viewModel: viewModel)
                .padding(.horizontal, 16)
        } else {
            if #available(iOS 16.0, *) {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(infoViewModels) { viewModel in
                            ItineraryInfoView(viewModel: viewModel)
                                .frame(width: parentViewWidth * 0.83)
                        }
                    }
                    .padding(16)
                }
                .scrollIndicators(.hidden)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(infoViewModels) { viewModel in
                            ItineraryInfoView(viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        Divider()
            .frame(height: 1)
            .background(Color.red)
        Text("Single Item")
        Divider()
            .frame(height: 1)
            .background(Color.red)
        ItineraryInfoCollectionView(
            parentViewWidth: 375,
            infoViewModels: [
                .init(
                    originCode: "NYC",
                    destinationCode: "LAS",
                    startDate: "May 29",
                    endDate: "Jun 10",
                    badgeViewModel: .init(title: "ROUND-TRIP",
                                          image: nil,
                                          style: .roundTrip))
            ])
        
        Divider()
            .frame(height: 1)
            .background(Color.red)
        Text("Multiple Items")
        Divider()
            .frame(height: 1)
            .background(Color.red)
        ItineraryInfoCollectionView(
            parentViewWidth: 375, 
            infoViewModels: [
                .init(
                    originCode: "NYC",
                    destinationCode: "LAS",
                    startDate: "May 29",
                    endDate: "Jun 10",
                    badgeViewModel: .init(title: "ROUND-TRIP",
                                          image: nil,
                                          style: .roundTrip)),
                .init(
                    originCode: "NYC",
                    destinationCode: "LAS",
                    startDate: "May 29",
                    endDate: "Jun 10",
                    badgeViewModel: .init(title: "ONE-WAY",
                                          image: nil,
                                          style: .roundTrip))
            ])
        Divider()
            .frame(height: 1)
            .background(Color.red)
    }
    
}
