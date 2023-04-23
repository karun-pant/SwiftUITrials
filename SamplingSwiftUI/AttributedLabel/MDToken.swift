//
//  MDToken.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 21/04/23.
//

import Foundation


enum MDTokenType {
    case normal, bold, link
    
}

indirect enum MDTokenHandler {
    case normal(text: String)
    case bold(token: MDToken)
    case link(token: MDToken, url: URL?)
    
    
    var childToken: MDToken? {
        switch self {
        case .normal(text: _):
            return nil
        case .bold(token: let token):
            return token
        case .link(token: let token, url: _):
            return token
        }
    }
    
}

struct MDToken {
    let type: MDTokenType
    let handler: MDTokenHandler
    
    var isBold: Bool {
        switch self.handler {
        case .normal(text: _):
            return false
        case .bold(token: _):
            return true
        case .link(token: let token, url: _):
            return token.isBold
        }
    }
    var url: URL? {
        switch self.handler {
        case .normal(text: _):
            return nil
        case .bold(token: let token):
            return token.url
        case .link(token: _, url: let url):
            return url
        }
    }
    var text: String? {
        switch self.handler {
        case .normal(text: let text):
            return text
        case .bold(token: let token):
            return token.text
        case .link(token: let token, url: _):
            return token.text
        }
    }
}
