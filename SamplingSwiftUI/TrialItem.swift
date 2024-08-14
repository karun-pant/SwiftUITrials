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
    case ScrollButtonTrial = "Scroll Button Trial"
    case AttributedLabel = "Attributed Label"
    case InjectableText = "Injectable Text"
    case HTMLText = "HTML Text"
    case ArrayState = "Handle State In List"
    case slidableUIVIew = "Slidable row view UIKit"
    case onboarding = "Onboarding"
    var id: String {
        rawValue
    }
}
