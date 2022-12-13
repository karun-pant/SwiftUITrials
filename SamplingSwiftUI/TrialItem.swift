//
//  TrialItem.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 13/12/22.
//

enum TrialItem: String, CaseIterable {
    case tripListView
    case gestureTrials
    case apiTrials
    var id: String {
        rawValue
    }
}
