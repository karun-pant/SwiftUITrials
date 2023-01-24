//
//  TrialItem.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 13/12/22.
//

enum TrialItem: String, CaseIterable {
    case tripListView = "Trial List View"
    case gestureTrialsUIKit = "Gesture Trial UIKit"
    case gestureTrialsSwiftUI = "Gesture Trial SwiftUI"
    case apiTrials = "API Trials"
    case switchRowView = "Switch Row View"
    case meterialTextField = "Meterial Textbox"
    var id: String {
        rawValue
    }
}
