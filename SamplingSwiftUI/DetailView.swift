//
//  DetailView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 14/12/22.
//

import SwiftUI

struct DetailView: View {
    let selectedTrialItem: TrialItem
    @ObservedObject var tripListViewModel = PLTripListViewModel(refreshTreyTitle: "Some Title")
    @ObservedObject var materialTextViewModel: MaterialTextFieldViewModel = MaterialTextFieldViewModel(optionalStateText: "Optional", placeHolder: "Name")
    @ObservedObject var errorMaterialTextViewModel: MaterialTextFieldViewModel = MaterialTextFieldViewModel(optionalStateText: "Optional",
                                                                                                            placeHolder: "Name",
                                                                                                            errorMessage: "Input is Empty")
    
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
        case .gestureTrialsUIKit:
            GestureRepresentableVC()
        case .gestureTrialsSwiftUI:
            Text("Not set yet")
        case .apiTrials:
            Text("Not set yet")
        case .switchRowView:
            SwitchRowView { isToggled in
                print("\(isToggled ? "Toggle on" : "Toggle off")")
            }
        case .meterialTextField:
            VStack(alignment: .leading, spacing: 8) {
//                MaterialTextField(viewModel: materialTextViewModel)
//                Text("Text Added:")
//                Text(materialTextViewModel.text)
//                MaterialTextField(viewModel: errorMaterialTextViewModel)
                MeterialTextForm()
                Spacer()
            }
            .padding()
        case .ScrollButtonTrial:
            FabView(viewIndexForThreshold: 25)
        case .AttributedLabel:
            AttributedLabel(attributedText: attributedString, boundingWidth: UIScreen.main.bounds.width)
        }
    }
    
    private let attributedString = {
        let attributedString = NSMutableAttributedString(string: "Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here! Gooooogle something here!")
        attributedString.addAttribute(.link, value: "https://www.google.com", range: NSRange(location: 0, length: 5))
        return attributedString
    }()
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedTrialItem: .meterialTextField)
            .padding()
    }
}
