//
//  InjectableTextView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 23/04/23.
//

import SwiftUI

struct InjectableTextView: View {
    
    let viewModel: InjectableTextViewModel
    
    var body: some View {
        Text(viewModel.text)
            .tint(Color.red)
            .environment(\.openURL, OpenURLAction { url in
                let linkableURL: URL? = {
                    let absoluteString = url.absoluteString
                    guard !absoluteString.isEmpty,
                          let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue),
                          detector.numberOfMatches(in: absoluteString,
                                                   options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                   range: NSMakeRange(0, absoluteString.count)) > 0 else {
                        return nil
                    }
                    return URL(string: absoluteString)
                }()
                if let linkableURL {
                    viewModel.onTapURL(linkableURL)
                } else {
                    viewModel.onTapAction(url.absoluteString)
                }
                return .discarded
            })
    }
}

struct InjectableTextView_Previews: PreviewProvider {
    static var previews: some View {
        InjectableTextView(
            viewModel: .init(targetText: "**[{{rcDiscount}}](doSomething)** {{home}} normal text normal text **normal bold** **{{listing}}** | [Air Discounts](www.priceline.com)",
                             injectableKeyToValue: ["home": "Home Screen",
                                                    "rcDiscount": "Amazing RC discount Tap to see how",
                                                    "listing": "Air Listings"],
                             style: MDTextViewStyle(),
                             onTapAction: { actionName in
                                 print("Action Tapped: \(actionName)")
                             },
                             onTapURL: { url in
                                 print("URL Tapped: \(url.absoluteString)")
                             }))
    }
}
