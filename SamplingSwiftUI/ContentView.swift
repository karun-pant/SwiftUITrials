//
//  ContentView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 22/11/21.
//

import SwiftUI

struct Model: Identifiable {
    var id = UUID()
    var title: String
}

struct ContentView: View {
    @ObservedObject var viewModel = PLTripListViewModel(refreshTreyTitle: "Some Title")
    var body: some View {
        PLTripMyTripListView(viewModel: viewModel,
                                    onRefreshControlTriggered:  {
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                viewModel.refreshTrayTitle = PLTripListViewModel.refreshTrayTitle(titleText: "Some Other Title")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    viewModel.isRefreshComplete = true
                })
            }
        }, onOpenTray: {
            print("Open tray called")
        }, onCloseTray: {
            print("Close tray called")
        })
    }
}
