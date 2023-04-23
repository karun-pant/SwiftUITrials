//
//  InjectableTextViewModel.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 23/04/23.
//

import Foundation

struct InjectableTextViewModel {
    let onTapAction: (_ actionName: String) -> ()
    let onTapURL: (_ url: URL) -> ()
    let text: AttributedString
    init(targetText: String,
         injectableKeyToValue: [String : String],
         onTapAction: @escaping (_: String) -> Void,
         onTapURL: @escaping (_: URL) -> Void) {
        self.onTapAction = onTapAction
        self.onTapURL = onTapURL
        self.text = {
            var text = targetText
            injectableKeyToValue.forEach {
                text = text.replacingOccurrences(of: "{{\($0.key)}}", with: $0.value)
            }
            let attributedText = (try? AttributedString(markdown: text)) ?? AttributedString(stringLiteral: "")
            return attributedText
        }()
    }
}
