//
//  SliderCellViewModel.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 24/04/24.
//

class PLFlightSlidableCellViewModel {
    
    let itineraryInfoViewModel: ItineraryInfoViewModel
    let swipeActionViewModel: PLFlightSwipeActionViewModel?
    
    var onSwipeComplete: (() -> ())?
    
    init(originCode: String,
         destinationCode: String,
         originDate: String,
         destinationDate: String,
         badgeViewModel: BadgeViewModel,
         swipeActionViewModel: PLFlightSwipeActionViewModel?) {
        itineraryInfoViewModel = ItineraryInfoViewModel(originCode: originCode,
                                                        destinationCode: destinationCode,
                                                        startDate: originDate,
                                                        endDate: destinationDate,
                                                        badgeViewModel: badgeViewModel)
        self.swipeActionViewModel = swipeActionViewModel
    }
}

struct PLFlightSwipeActionViewModel {
    let title: String
    let colorName: AssetColor
    init(title: String, isDestructive: Bool) {
        self.title = title
        self.colorName = isDestructive ? .urgencyContent : .benefitAsset
    }
}
