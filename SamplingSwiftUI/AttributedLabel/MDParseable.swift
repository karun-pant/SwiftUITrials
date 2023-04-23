//
//  MDParseable.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 20/04/23.
//

import UIKit

class MDParser {
    
    typealias ParserResponse = (token: MDToken, strippedTokens: [String])
    
    enum ParseableToken: String, CaseIterable {
        case variableInjectonStart = "{{"
        case variableInjectonEnd = "}}"
        case boldFormatEnclosure = "**"
        case linkTitleStart = "["
        case linkTitleEnd = "]"
        case linkActionStart = "("
        case linkActionEnd = ")"
        
        static var startTokens: Set<ParseableToken> {
            [.variableInjectonStart, .linkTitleStart, .boldFormatEnclosure, .linkActionStart]
        }
        
        static func isStartParseableToken(token: String) -> Bool {
            guard let token = ParseableToken(rawValue: token) else {
                return false
            }
            return startTokens.contains(token)
        }
    }
    
    let text: String
    let variableToValue: [String: String]?
    private(set) var parsedTokens: [MDToken] = []
    var formattedTokens: [String] {
        var tokens = text.map { String($0) }
        let markForRemoval = "+|marked for removal|+"
        let tokenCount = tokens.count
        for (index, token) in tokens.enumerated() {
            // merge occurances of variableInjectonStart and variableInjectonEnd
            let injectableOpenTokenCase = token == "{" && tokens.count > index + 1 && tokens[index + 1] == "{"
            if injectableOpenTokenCase {
                tokens[index] = "{{"
                tokens[index + 1] = markForRemoval
            }
            let injectableCloseTokenCase = token == "}" && tokens.count > index + 1 && tokens[index + 1] == "}"
            if injectableCloseTokenCase {
                tokens[index] = "}}"
                tokens[index + 1] = markForRemoval
            }
            
            // merge occurances of boldEnclosures
            let boldTokenCase = token == "*" && tokenCount > index + 1 && tokens[index + 1] == "*"
            if boldTokenCase {
                tokens[index] = "**"
                tokens[index + 1] = markForRemoval
            }
        }
        tokens.removeAll(where: { $0 == markForRemoval })
        return tokens
    }
    
    init(text: String,
         variableToValue: [String : String]? = nil) {
        self.text = text
        self.variableToValue = variableToValue
        parse(formattedTokens)
    }
    
    func attributedString(normalFont: UIFont,
                          boldFont: UIFont,
                          foregroundColor: UIColor) -> NSAttributedString {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString()
        for token in parsedTokens {
            guard let text = token.text else {
                continue
            }
            var attributes: [NSAttributedString.Key: Any] = [.foregroundColor: foregroundColor]
            attributes[.font] = token.isBold ? boldFont : normalFont
            if let url = token.url {
                attributes[.link] = url
            }
            attributedString.append(NSAttributedString(string: text, attributes: attributes))
        }
        return attributedString
    }
}

// MARK: - Private Parsers

private extension MDParser {
    
    func parse(_ formattedTokens: [String]) {
        //"[**{{abc}}** discount see how](somelink) {{someDef}} normal text normal text **normal bold**"
        //        var parsedTokens: [MSToken] = []
        guard let firstToken = formattedTokens.first else {
            return
        }
        if ParseableToken.isStartParseableToken(token: firstToken),
           let token = ParseableToken(rawValue: firstToken) {
            switch token {
            case .variableInjectonStart:
                if let parsed = parseInjectable(stringTokens: formattedTokens) {
                    parsedTokens.append(parsed.token)
                    parse(parsed.strippedTokens)
                } else {
                    return
                }
            case .linkTitleStart:
                if let parsed = parselink(stringTokens: formattedTokens) {
                    parsedTokens.append(parsed.token)
                    parse(parsed.strippedTokens)
                } else {
                    return
                }
            case .boldFormatEnclosure:
                if let parsed = parseBold(stringTokens: formattedTokens) {
                    parsedTokens.append(parsed.token)
                    parse(parsed.strippedTokens)
                } else {
                    return
                }
            case .variableInjectonEnd,
                    .linkTitleEnd,
                    .linkActionStart,
                    .linkActionEnd:
                if let parsed = parseNormal(stringTokens: formattedTokens) {
                    parsedTokens.append(parsed.token)
                    parse(parsed.strippedTokens)
                } else {
                    return
                }
            }
        } else {
            if let parsed = parseNormal(stringTokens: formattedTokens) {
                parsedTokens.append(parsed.token)
                parse(parsed.strippedTokens)
            } else {
                return
            }
        }
    }
    
    func parseNormal(stringTokens: [String]) -> ParserResponse? {
        if let endIndexForNormal = stringTokens.firstIndex(where: { ParseableToken.isStartParseableToken(token:$0) } ) {
            // tokens ending with normal, or complete string is normal text only.
            var mutableStringTokens = stringTokens
            let normalText = mutableStringTokens.prefix(Int(endIndexForNormal)).joined(separator: "")
            let range = 0...endIndexForNormal-1
            mutableStringTokens.removeSubrange(range)
            let token = MDToken(type: .normal, handler: .normal(text: normalText))
            return (token, mutableStringTokens)
        } else {
            let token = MDToken(type: .normal, handler: .normal(text: stringTokens.joined()))
            return (token, [])
        }
        
    }
    
    func parseBold(stringTokens: [String]) -> ParserResponse? {
        guard stringTokens.first ?? ""  == ParseableToken.boldFormatEnclosure.rawValue else {
            assertionFailure("token array should start with link token **.")
            return parseNormal(stringTokens: stringTokens)
        }
        var mutableStringTokens = stringTokens
        _ = mutableStringTokens.removeFirst()
        guard let endIndexForBold = mutableStringTokens.firstIndex(where: { ParseableToken(rawValue: $0) == .boldFormatEnclosure } ) else {
            assertionFailure("token array should end with bold tokens **.")
            return nil
        }
        let boldPreCurserTokens = mutableStringTokens.prefix(Int(endIndexForBold))
        let range = 0...endIndexForBold
        let precursorRange = 0...endIndexForBold - 1
        let precursorTokens = Array<String>(boldPreCurserTokens[precursorRange])
        if let firstToken = boldPreCurserTokens.first(where: { ParseableToken.isStartParseableToken(token: $0) }),
           let parseableToken = ParseableToken(rawValue: firstToken) {
            switch parseableToken {
            case .variableInjectonStart:
                // **{{injectable}}**
                if let parsedInjectable = parseInjectable(stringTokens: precursorTokens) {
                    mutableStringTokens.removeSubrange(range)
                    let token = MDToken(type: .bold, handler: .bold(token: parsedInjectable.token))
                    return (token, mutableStringTokens)
                }
                // Treat as normal Text
                mutableStringTokens.removeSubrange(range)
                let token = MDToken(type: .bold, handler: .normal(text: boldPreCurserTokens.joined()))
                return (token, mutableStringTokens)
            case .linkTitleStart:
                if let parsedLink = parselink(stringTokens: precursorTokens) {
                    mutableStringTokens.removeSubrange(range)
                    let token = MDToken(type: .bold, handler: .bold(token: parsedLink.token))
                    return (token, mutableStringTokens)
                }
                // Treat as normal Text
                mutableStringTokens.removeSubrange(range)
                let token = MDToken(type: .bold, handler: .normal(text: boldPreCurserTokens.joined()))
                return (token, mutableStringTokens)
            case .variableInjectonEnd, .linkTitleEnd, .linkActionEnd, .boldFormatEnclosure, .linkActionStart:
                // Treat as normal Text
                mutableStringTokens.removeSubrange(range)
                let token = MDToken(type: .bold, handler: .normal(text: boldPreCurserTokens.joined()))
                return (token, mutableStringTokens)
            }
        } else {
            mutableStringTokens.removeSubrange(range)
            let token = MDToken(type: .bold, handler: .normal(text: boldPreCurserTokens.joined()))
            return (token, mutableStringTokens)
        }
    }
    
    func parselink(stringTokens: [String]) -> ParserResponse? {
        guard stringTokens.first ?? ""  == ParseableToken.linkTitleStart.rawValue else {
            assertionFailure("token array should start with link token [.")
            return parseNormal(stringTokens: stringTokens)
        }
        var mutableStringTokens = stringTokens
        _ = mutableStringTokens.removeFirst()
        guard let endIndexForLinkTitle = mutableStringTokens.firstIndex(where: { ParseableToken(rawValue: $0) == .linkTitleEnd } ) else {
            assertionFailure("token array should end with link token ].")
            return nil
        }
        let linkPrecursorTokens = mutableStringTokens.prefix(Int(endIndexForLinkTitle)) // injecter, bold or normalText
        let range = 0...endIndexForLinkTitle
        mutableStringTokens.removeSubrange(range)
        let precursorRange = 0...endIndexForLinkTitle - 1
        let precursorTokens = Array<String>(linkPrecursorTokens[precursorRange])
        // parse linkAction and return correct type
        let parsedLinkAction = parseLinkAction(precursorTokens: mutableStringTokens)
        if let firstToken = linkPrecursorTokens.first(where: { ParseableToken.isStartParseableToken(token: $0) }),
           let parseableToken = ParseableToken(rawValue: firstToken) {
            switch parseableToken {
            case .boldFormatEnclosure:
                // [**{{injectable}}**](https://www.google.com)
                if let parsedBold = parseBold(stringTokens: precursorTokens) {
                    let token = MDToken(type: .link,
                                        handler: .link(token: parsedBold.token,
                                                       url: parsedLinkAction.url))
                    
                    return (token, parsedLinkAction.strippedTokens)
                }
                let token = MDToken(type: .link,
                                    handler: .link(token: MDToken(type: .normal, handler: .normal(text: precursorTokens.joined())),
                                                   url: parsedLinkAction.url))
                return (token, parsedLinkAction.strippedTokens)
            case .variableInjectonStart:
                //[{{injectable}}](https://www.google.com)
                if let parsedInjectable = parseInjectable(stringTokens: precursorTokens) {
                    let token = MDToken(type: .link,
                                        handler: .link(token: parsedInjectable.token,
                                                       url: parsedLinkAction.url))
                    return (token, parsedLinkAction.strippedTokens)
                }
                let token = MDToken(type: .link,
                                    handler: .link(token: MDToken(type: .normal, handler: .normal(text: precursorTokens.joined())),
                                                   url: parsedLinkAction.url))
                return (token, parsedLinkAction.strippedTokens)
            case .variableInjectonEnd, .linkTitleEnd, .linkActionStart, .linkActionEnd, .linkTitleStart:
                let token = MDToken(type: .link,
                                    handler: .link(token: MDToken(type: .normal, handler: .normal(text: precursorTokens.joined())),
                                                   url: parsedLinkAction.url))
                return (token, parsedLinkAction.strippedTokens)
            }
        } else {
            let token = MDToken(type: .link,
                                handler: .link(token: MDToken(type: .normal, handler: .normal(text: precursorTokens.joined())),
                                               url: parsedLinkAction.url))
            return (token, parsedLinkAction.strippedTokens)
        }
    }
    
    
    func parseLinkAction(precursorTokens: [String]) -> (action: String, url: URL?, strippedTokens: [String]) {
        guard precursorTokens.first ?? ""  == ParseableToken.linkActionStart.rawValue else {
            assertionFailure("token array should start with link action start token (.")
            return ("", nil, precursorTokens)
        }
        var mutableStringTokens = precursorTokens
        _ = mutableStringTokens.removeFirst()
        guard let endIndex = mutableStringTokens.firstIndex(where: { ParseableToken(rawValue: $0) == .linkActionEnd } ) else {
            assertionFailure("token array should start with link action end tokens ).")
            return ("", nil, precursorTokens)
        }
        let range = 0...endIndex
        let linkActionRange = 0...endIndex-1
        let linkAction = Array(mutableStringTokens[linkActionRange]).joined()
        mutableStringTokens.removeSubrange(range)
        let url: URL? = {
            guard !linkAction.isEmpty,
                  let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue),
                  detector.numberOfMatches(in: linkAction,
                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                           range: NSMakeRange(0, linkAction.count)) > 0 else {
                return nil
            }
            return URL(string: linkAction)
        }()
        return (linkAction, url, mutableStringTokens)
    }
    
    func parseInjectable(stringTokens: [String]) -> ParserResponse? {
        guard stringTokens.first ?? ""  == ParseableToken.variableInjectonStart.rawValue else {
            assertionFailure("token array should start with injection token {{.")
            return parseNormal(stringTokens: stringTokens)
        }
        var mutableStringTokens = stringTokens
        _ = mutableStringTokens.removeFirst()
        guard let endIndexForInjectable = mutableStringTokens.firstIndex(where: { ParseableToken(rawValue: $0) == .variableInjectonEnd } ) else {
            assertionFailure("token array should end with injectable tokens }}.")
            return nil
        }
        let varName = mutableStringTokens.prefix(Int(endIndexForInjectable)).joined(separator: "")
        let range = 0...endIndexForInjectable
        if let value = variableToValue?[varName] {
            mutableStringTokens.removeSubrange(range)
            let token = MDToken(type: .normal, handler: .normal(text: value))
            return (token, mutableStringTokens)
        }
        // treat as normal
        mutableStringTokens.removeSubrange(range)
        let token = MDToken(type: .normal, handler: .normal(text: "{{\(varName)}}"))
        return (token, mutableStringTokens)
    }
}

