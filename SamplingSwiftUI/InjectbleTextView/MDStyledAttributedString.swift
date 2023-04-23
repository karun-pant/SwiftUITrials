//
//  MDStyledAttributedString.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 23/04/23.
//

import SwiftUI

struct MDTextViewStyle {
    let fontSize: CGFloat
    let normalTextFontWeight: Font.Weight
    let color: Color
    let linkColor: Color
    init(fontSize: CGFloat = 14,
         normalTextFontWeight: Font.Weight = .medium,
         color: Color = .black,
         linkColor: Color = .red) {
        self.fontSize = fontSize
        self.normalTextFontWeight = normalTextFontWeight
        self.color = color
        self.linkColor = linkColor
    }
}

struct MDStyledAttributedString {
    
    private enum MarkdownStyledBlock: Equatable {
        case normal
        case blockquote
    }
    
    let attributedText: AttributedString
    init(text: String,
         style: MDTextViewStyle) throws {
        var md = try AttributedString(markdown: text,
                                      options: .init(allowsExtendedAttributes: true,
                                                     interpretedSyntax: .full,
                                                     failurePolicy: .returnPartiallyParsedIfPossible,
                                                     languageCode: "en"),
                                      baseURL: nil)
        md.font = .system(size: style.fontSize, weight: style.normalTextFontWeight)
        md.foregroundColor = style.color
        md.runs.forEach { run in
            let range = run.range
            if run.inlinePresentationIntent == .stronglyEmphasized {
                md[range].font = .system(size: style.fontSize, weight: .bold)
            }
            if run.link != nil {
                md[range].foregroundColor = style.linkColor
            }
        }
        self.attributedText = md
    }
}
