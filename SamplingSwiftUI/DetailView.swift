//
//  DetailView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 14/12/22.
//

import SwiftUI
import Foundation

struct DetailView: View {
    let selectedTrialItem: TrialItem
    @ObservedObject var tripListViewModel = PLTripListViewModel(refreshTreyTitle: "Some Title")
    @ObservedObject var materialTextViewModel: MaterialTextFieldViewModel = MaterialTextFieldViewModel(optionalStateText: "Optional", placeHolder: "Name")
    @ObservedObject var errorMaterialTextViewModel: MaterialTextFieldViewModel = MaterialTextFieldViewModel(optionalStateText: "Optional",
                                                                                                            placeHolder: "Name",
                                                                                                            errorMessage: "Input is Empty")
    
    @FocusState var focus: String?
    
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
            let viewModels = [
                [
                    MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews1",
                                           inputText: "A Really Big Text to check compartments",
                                           placeholderText: "First Name",
                                           optionalText: "",
                                           isEditable: true,
                                           isDisabled: false,
                                           rightAccesoryImageNames: [
                                            .init(image: .xMarkSystemImage,
                                                  isSFSymbol: true)
                                           ],
                                           style: .basicStyle,
                                           keyboardType: .asciiCapable)
                ],
                [
                    MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews2",
                                           inputText: "",
                                           placeholderText: "Placeholder",
                                           optionalText: "",
                                           isEditable: true,
                                           isDisabled: false,
                                           style: .basicStyle,
                                           keyboardType: .asciiCapable),
                    MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews3",
                                           inputText: "",
                                           placeholderText: "A Really Big Text to check compartments",
                                           optionalText: "A Really Big Text",
                                           isEditable: false,
                                           isDisabled: false,
                                           style: .basicStyle,
                                           keyboardType: .asciiCapable,
                                           placeholderIcon: .lock)
                ],
                [
                    MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews4",
                                           inputText: "Some",
                                           placeholderText: "Placeholder",
                                           optionalText: "A Really Big Text",
                                           isEditable: false,
                                           isDisabled: false,
                                           style: .basicStyle,
                                           keyboardType: .asciiCapable),
                    MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews5",
                                           inputText: "",
                                           placeholderText: "Placeholder",
                                           optionalText: "A Really Big Text",
                                           isEditable: false,
                                           isDisabled: false,
                                           style: .basicStyle,
                                           keyboardType: .asciiCapable)
                ]
                
            ]
            
            VStack {
                ForEach(viewModels, id: \.first?.id) { vms in
                    HStack {
                        ForEach(vms) { vm in
                            MeterialTextField(viewModel: vm,
                                              focusedInputViewID: $focus,
                                              onImageTap: nil,
                                              onTextReturn: { _ in })
                        }
                    }
                    .padding(.bottom, 15)
                }
            }
            .padding(16)
        case .ScrollButtonTrial:
            FabView(viewIndexForThreshold: 25)
        case .AttributedLabel:
            VStack {
                AttributedLabel(
                    attributedText:
                        MDParser(
                            text: "[discount see how](www.google.com) {{home}} normal text normal text **normal bold** **{{listing}}** ===",
                            variableToValue: ["home": "Home Screen",
                                              "listing": "Air Listing"])
                        .attributedString(normalFont: .systemFont(ofSize: 14, weight: .medium),
                                          boldFont: .systemFont(ofSize: 14, weight: .bold),
                                          foregroundColor: .black),
                    boundingWidth: UIScreen.main.bounds.width)
                .environment(\.openURL, OpenURLAction { url in
                    print("---> link actioned: \(url.absoluteURL)")
                    return .discarded
                })
                .padding(10)
            }
        case .InjectableText:
            let viewModel = InjectableTextViewModel(
                targetText: "**[{{rcDiscount}}](doSomething)** {{home}} normal text normal text **normal bold** **{{listing}}** | [Air Discounts](www.priceline.com)",
                injectableKeyToValue: ["home": "Home Screen",
                                       "rcDiscount": "Amazing RC discount Tap to see how",
                                       "listing": "Air Listings"],
                style: MDTextViewStyle(),
                onTapAction: { actionName in
                    print("Action Tapped: \(actionName)")
                },
                onTapURL: { url in
                    print("URL Tapped: \(url.absoluteString)")
                })
            InjectableTextView(viewModel: viewModel)
        case .HTMLText:
            if let attributedString = try? attributedInstructions() {
                Text(attributedString)
            } else {
                Text("Not able to parse HTMl, Printing same data.")
            }
        case .ArrayState:
            ItemListView(itemList: .init(items: [
                Item(name: "Item 1", type: .emojiOnly),
                Item(name: "Item 2", type: .emojiOnly),
                Item(name: "Item 3", type: .emojiOnly)
            ]))
        }
    }
    
    private func attributedInstructions() throws -> AttributedString? {
//        let str = "San Francisco Airport provides AirTrains from all terminals to the Rental Car Center. The RED line AirTrain runs between terminals. The BLUE line AirTrain runs from the terminals to the Rental Car Center. Airport signs will direct you to the train boarding areas. The AirTrains run approximately every 4-5 minutes<br>Upon arrival at the Rental Car Center on the AirTrain follow the signs to Shuttle Island 2 outside the building and board the FOX shuttle for a short ride to our rental counter."
        var str = "Customer’s arriving by flight into Terminal B should Exit baggage claim and cross the road to the common Rental Car Facility on the first floor. Customer’s arriving by flight into Terminal A should exit baggage claim and take the common Rental Car Shuttle Bus to the common Rental Car Facility. The common Rental Car Shuttle Bus makes stops approximately every 10 minutes."
        str = str.replacingOccurrences(of: "’", with: "'")
        guard let instructionsAttributedString = try? NSMutableAttributedString(data: Data(str.utf8),
                                                  options: [.documentType: NSAttributedString.DocumentType.html],
                                                                      documentAttributes: nil) else {
            return nil
        }
        instructionsAttributedString.addAttribute(.font,
                                                  value: UIFont.systemFont(ofSize: 12, weight: .regular),
                                                  range: .init(location: 0, length: instructionsAttributedString.string.count - 1))
        instructionsAttributedString.addAttribute(.foregroundColor,
                                                  value: UIColor.red,
                                                  range: .init(location: 0, length: instructionsAttributedString.string.count - 1))
        var attributedString: AttributedString? = nil
        do {
            attributedString = try AttributedString(instructionsAttributedString, including: \.uiKit)
        } catch {
            print(error.localizedDescription)
        }
        return attributedString
    }
}

struct UIKLabel: UIViewRepresentable {

    typealias TheUIView = UILabel
    fileprivate var configuration = { (view: UILabel) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        let view = TheUIView()
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.frame = .zero
        return view
    }
    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<Self>) {
        uiView.sizeToFit()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        if let superView = uiView.superview {
            NSLayoutConstraint.activate([
                uiView.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0),
                uiView.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0),
                uiView.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0),
                uiView.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0)
            ])
        }
        _ = uiView.frame
        configuration(uiView)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedTrialItem: .HTMLText)
            .padding()
    }
}
