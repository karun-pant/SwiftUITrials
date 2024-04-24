//
//  HorizontalListWithHeaderViewModel.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 23/05/23.
//

import Foundation

struct HorizontalListWithHeaderViewModel {
    let headerViewModel: HeaderViewModel
    let fareBrands: [ColumnViewModel]
    
    static var dummy: HorizontalListWithHeaderViewModel {
        let header = HeaderViewModel(airlineViewModel: .init(name: "Air Canada", image: .canAir),
                                     ancillaryNames: ["Carry on Bag",
                                                     "Seat Selection",
                                                     "Checked Bag 2x25kg",
                                                     "Changeable Ticket Changeable Ticket",
                                                     "Cancellation"],
                                     pricingTitle: "Pricing(Per Person)")
        let fareBrands: [ColumnViewModel] = [
            .init(title: "Flex",
                  isSelected: true,
                  incrementalPricePerPerson: "+$0",
                  ancillaries: [
                    .available,
                    .available,
                    .available,
                    .availableForPrice,
                    .availableForPrice
                  ]),
            .init(title: "Latitude",
                  isSelected: false,
                  incrementalPricePerPerson: "+$0",
                  ancillaries: [
                    .available,
                    .available,
                    .available,
                    .availableForPrice,
                    .availableForPrice
                  ]),
            .init(title: "Latitude",
                  isSelected: false,
                  incrementalPricePerPerson: "+$0",
                  ancillaries: [
                    .available,
                    .available,
                    .available,
                    .availableForPrice,
                    .availableForPrice
                  ]),
            .init(title: "Latitude",
                  isSelected: false,
                  incrementalPricePerPerson: "+$0",
                  ancillaries: [
                    .available,
                    .available,
                    .available,
                    .availableForPrice,
                    .availableForPrice
                  ]),
            .init(title: "Latitude",
                  isSelected: false,
                  incrementalPricePerPerson: "+$0",
                  ancillaries: [
                    .available,
                    .available,
                    .available,
                    .availableForPrice,
                    .availableForPrice
                  ])
        ]
        return .init(headerViewModel: header, fareBrands: fareBrands)
    }
}

struct HeaderViewModel {
    let airlineViewModel: AirlineViewModel
    let ancillaryNames: [String]
    let pricingTitle: String
}

struct AirlineViewModel {
    let name: String
    let image: AssetImage
}

struct ColumnViewModel: Identifiable {
    var id: String {
        title
    }
    let title: String
    let isSelected: Bool
    let incrementalPricePerPerson: String
    let ancillaries: [AncillaryPresence]
}

enum AncillaryPresence {
    case available, availableForPrice
}
