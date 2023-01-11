//
//  TrialItem.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 13/12/22.
//

enum TrialItem: String, CaseIterable {
    case tripListView
    case gestureTrialsUIKit
    case gestureTrialsSwiftUI
    case apiTrials
    case switchRowView
    var id: String {
        rawValue
    }
}
