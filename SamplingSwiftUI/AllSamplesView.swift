//
//  ContentView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 22/11/21.
//

import SwiftUI

struct AllSamplesView: View {
    let allTrials = TrialItem.allCases
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                List(allTrials, id:\.id) { trialItem in
                    NavigationLink(trialItem.rawValue) {
                        DetailView(selectedTrialItem: trialItem)
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            List(allTrials, id:\.id) { trialItem in
                NavigationLink(trialItem.rawValue) {
                    DetailView(selectedTrialItem: trialItem)
                }
            }
        }
    }
}
