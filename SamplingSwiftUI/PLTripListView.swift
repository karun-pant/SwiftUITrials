//
//  PLTripListView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 22/11/21.
//

import SwiftUI

struct PLTripMyTripListView: View {
    @ObservedObject var viewModel: PLTripListViewModel
    var modelData = DataModel(modelData: [Model(title: "Item 1"), Model(title: "Item 2"), Model(title: "Item 3")])
    
    var onRefreshControlTriggered: (() -> Void)
    var onOpenTray: (() -> ())? = nil
    var onCloseTray: (() -> ())? = nil
    
    var body: some View {
        GeometryReader{ geometry in
            PLTripRefreshableView(size: geometry.size,
                                  attributedTitle: $viewModel.refreshTrayTitle,
                                  onRefreshControlTriggered: onRefreshControlTriggered,
                                  onOpenTray: onOpenTray,
                                  onCloseTray: onCloseTray,
                                  isRefreshComplete: $viewModel.isRefreshComplete,
                                  content: {
                SwiftUIList(model: self.modelData)
            })
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PLTripListViewModel(refreshTreyTitle: "Some Title")
        return PLTripMyTripListView(viewModel: viewModel,
                                    onRefreshControlTriggered:  {
            DispatchQueue.main.asyncAfter(deadline: .now()+5) { [viewModel] in
                viewModel.isRefreshComplete = true
            }
        })
    }
}

class PLTripListViewModel: ObservableObject {
    @Published var isRefreshComplete: Bool = false
    @Published var refreshTrayTitle: NSAttributedString?
    
    init(refreshTreyTitle: String = "") {
        self.refreshTrayTitle = PLTripListViewModel.refreshTrayTitle(titleText: refreshTreyTitle)
    }
    
    static func refreshTrayTitle(titleText: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.red];
        return NSAttributedString(string: titleText, attributes: attributes)
    }
}


struct SwiftUIList: View {
    
    @ObservedObject var model: DataModel
    
    var body: some View {
        List(model.modelData){
            model in
            Text(model.title)
        }
    }
}


class DataModel: ObservableObject {
    @Published var modelData: [Model]
    
    init(modelData: [Model]) {
        self.modelData = modelData
    }
    
    func addElement(){
        modelData.append(Model(title: "Item \(modelData.count + 1)"))
    }
}
