//
//  ItineraryInfoViewModel.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 25/04/24.
//

import SwiftUI

class ItineraryInfoViewModel: Identifiable {
    
    var id: String {
        "\(originCode)_\(destinationCode)_\(startDate)_\(endDate)"
    }
    let originCode: String
    let destinationCode: String
    let startDate: String
    let endDate: String
    let badgeViewModel: BadgeViewModel
    var onTap: (() -> ())?
    
    init(originCode: String, 
         destinationCode: String,
         startDate: String,
         endDate: String,
         badgeViewModel: BadgeViewModel) {
        self.originCode = originCode
        self.destinationCode = destinationCode
        self.startDate = startDate
        self.endDate = endDate
        self.badgeViewModel = badgeViewModel
    }
}
