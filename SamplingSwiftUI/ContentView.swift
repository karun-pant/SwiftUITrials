//
//  ContentView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 22/11/21.
//

import SwiftUI

struct ContentView: View {
    let allTrials = TrialItem.allCases
    
    var body: some View {
        NavigationStack {
            List(allTrials, id:\.id) { trialItem in
                NavigationLink(trialItem.rawValue) {
                    DetailView(selectedTrialItem: trialItem)
                }
            }
        }
    }
}
