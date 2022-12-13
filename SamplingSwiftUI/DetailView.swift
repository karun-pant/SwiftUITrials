//
//  DetailView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 13/12/22.
//

import SwiftUI

struct DetailView: View {
    let selectedTrialItem: TrialItem
    @ObservedObject var tripListViewModel = PLTripListViewModel(refreshTreyTitle: "Some Title")
    var body: some View {
        switch selectedTrialItem {
        case .tripListView:
            PLTripMyTripListView(viewModel: tripListViewModel,
                                        onRefreshControlTriggered:  {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    tripListViewModel.refreshTrayTitle = PLTripListViewModel.refreshTrayTitle(titleText: "Some Other Title")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        tripListViewModel.isRefreshComplete = true
                    })
                }
            }, onOpenTray: {
                print("Open tray called")
            }, onCloseTray: {
                print("Close tray called")
            })
        case .gestureTrials:
            Text("Not set yet")
        case .apiTrials:
            Text("Not set yet")
        }
    }
}
