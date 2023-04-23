//
//  MDParsingTests.swift
//  SamplingSwiftUITests
//
//  Created by Karun Pant on 20/04/23.
//

import XCTest
@testable import SamplingSwiftUI

final class MDParsingTests: XCTestCase {
    
    func testParsing() throws {
        let target = "[discount see how](www.google.com) {{home}} normal text normal text **normal bold** **{{listing}}**"
        let parsedTokens = MDParser(text: target,
                              variableToValue: ["home": "Home Screen",
                                                "listing": "Air Listing"]).parsedTokens
        XCTAssertEqual(parsedTokens.count, 7)
    }
    
    // MARK: - Commented tests below are needed for future debugging.
    // MARK: ==== DO NOT DELETE ===.
    
//    func testNormalTextParsing() throws {
//        let parser = MDParser(text: "normal text normal text **normal bold**")
//        let normal = parser.parseNormal(stringTokens: parser.formattedTokens)
//        XCTAssertNotNil(normal)
//        try expectationNormal(token: normal?.token, expectation: "normal text normal text ")
//        XCTAssertEqual(normal?.strippedTokens.count, 13)
//        let firstToken = try XCTUnwrap(normal?.strippedTokens.first)
//        XCTAssertTrue(MDParser.ParseableToken.isStartParseableToken(token: firstToken))
//    }
//
//    func testBoldTextParsing() throws {
//        let parser = MDParser(text: "**normal bold** normal text normal text.")
//        let bold = parser.parseBold(stringTokens: parser.formattedTokens)
//        XCTAssertNotNil(bold)
//        try expectationBoldToken(token: bold?.token,
//                                 expectation: "normal bold",
//                                 expectionDeeperType: .normal)
//        XCTAssertEqual(bold?.strippedTokens.count, 25)
//        let firstToken = try XCTUnwrap(bold?.strippedTokens.first)
//        XCTAssertEqual(firstToken, " ")
//    }
//
//    func testParseLink() throws {
//        let parser = MDParser(text: "[Handle the link](doSomething) normal text normal text.")
//        let link = parser.parselink(stringTokens: parser.formattedTokens)
//        XCTAssertEqual(link?.strippedTokens.count, 25)
//        let firstToken = try XCTUnwrap(link?.strippedTokens.first)
//        XCTAssertEqual(firstToken, " ")
//        let token = try XCTUnwrap(link?.token)
//        try expectationLinkToken(token: token,
//                                 expectationURL: nil,
//                                 expectation: "Handle the link",
//                                 actionExpectation: "doSomething",
//                                 expectionDeeperType: .normal)
//    }
//
//    func testParseBoldLinkText() throws {
//        let parser = MDParser(text: "[**Handle the link**](doSomething) normal text normal text.")
//        let link = parser.parselink(stringTokens: parser.formattedTokens)
//        XCTAssertEqual(link?.strippedTokens.count, 25)
//        let firstToken = try XCTUnwrap(link?.strippedTokens.first)
//        XCTAssertEqual(firstToken, " ")
//        let token = try XCTUnwrap(link?.token)
//        try expectationLinkToken(token: token,
//                                 expectationURL: nil,
//                                 expectation: "Handle the link",
//                                 actionExpectation: "doSomething",
//                                 expectionDeeperType: .bold)
//    }
//
//    func testParseInjectableLink() throws {
//        let parser = MDParser(text: "[{{home}}](doSomething) normal text normal text.", variableToValue: ["home": "Home Page"])
//        let link = parser.parselink(stringTokens: parser.formattedTokens)
//        XCTAssertEqual(link?.strippedTokens.count, 25)
//        let firstToken = try XCTUnwrap(link?.strippedTokens.first)
//        XCTAssertEqual(firstToken, " ")
//        let token = try XCTUnwrap(link?.token)
//        try expectationLinkToken(token: token,
//                                 expectationURL: nil,
//                                 expectation: "Home Page",
//                                 actionExpectation: "doSomething",
//                                 expectionDeeperType: .normal)
//    }
//
//    func testParseInjectableBoldLink() throws {
//        let parser = MDParser(text: "**[{{home}}](doSomething)** normal text normal text.", variableToValue: ["home": "Home Page"])
//        let link = parser.parseBold(stringTokens: parser.formattedTokens)
//        XCTAssertEqual(link?.strippedTokens.count, 25)
//        let firstToken = try XCTUnwrap(link?.strippedTokens.first)
//        XCTAssertEqual(firstToken, " ")
//        let token = try XCTUnwrap(link?.token)
//        try expectationBoldToken(token: token,
//                                 expectation: "Home Page",
//                                 expectionDeeperType: .link)
//    }
//
//    func testBoldInjectableTextParsing() throws {
//        let parser = MDParser(text: "**{{home}}** normal text normal text.", variableToValue: ["home": "Home Page"])
//        let bold = parser.parseBold(stringTokens: parser.formattedTokens)
//        XCTAssertNotNil(bold)
//        try expectationBoldToken(token: bold?.token, expectation: "Home Page", expectionDeeperType: .normal)
//        XCTAssertEqual(bold?.strippedTokens.count, 25)
//        let firstToken = try XCTUnwrap(bold?.strippedTokens.first)
//        XCTAssertEqual(firstToken, " ")
//    }
//
//    func testInjectableTextParsing() throws {
//        let parser = MDParser(text: "{{home}} normal text normal text.", variableToValue: ["home": "Home Page"])
//        let injectable = parser.parseInjectable(stringTokens: parser.formattedTokens)
//        XCTAssertNotNil(injectable)
//        try expectationNormal(token: injectable?.token, expectation: "Home Page")
//        XCTAssertEqual(injectable?.token.handler.text, "Home Page")
//        XCTAssertEqual(injectable?.strippedTokens.count, 25)
//        let firstToken = try XCTUnwrap(injectable?.strippedTokens.first)
//        XCTAssertEqual(firstToken, " ")
//
//        let parserNoValue = MDParser(text: "{{emoh}} normal text normal text.", variableToValue: ["home": "Home Page"])
//        let injectableNoValue = parserNoValue.parseInjectable(stringTokens: parserNoValue.formattedTokens)
//        XCTAssertNotNil(injectableNoValue)
//        try expectationNormal(token: injectableNoValue?.token, expectation: "{{emoh}}")
//        XCTAssertEqual(injectableNoValue?.strippedTokens.count, 25)
//        let firstTokenNoValue = try XCTUnwrap(injectableNoValue?.strippedTokens.first)
//        XCTAssertEqual(firstTokenNoValue, " ")
//    }
//
//    private func expectationNormal(token: MDToken?,
//                                   expectation: String,
//                                   file: StaticString = #filePath,
//                                   line: UInt = #line) throws  {
//        let token = try XCTUnwrap(token, expectation, file: file, line: line)
//        XCTAssertEqual(token.type, .normal, expectation, file: file, line: line)
//        XCTAssertEqual(token.handler.text, expectation, file: file, line: line)
//    }
//
//    private func expectationBoldToken(token: MDToken?,
//                                      expectation: String,
//                                      expectionDeeperType: MDTokenType,
//                                      file: StaticString = #filePath,
//                                      line: UInt = #line) throws {
//        let token = try XCTUnwrap(token, expectation, file: file, line: line)
//        XCTAssertEqual(token.type, .bold, expectation, file: file, line: line)
//        XCTAssertEqual(token.handler.text, expectation, file: file, line: line)
//        try digDeeperExpectation(token: token,
//                                 expectation: expectation,
//                                 typeExpectation: expectionDeeperType,
//                                 file: file,
//                                 line: line)
//    }
//
//    private func expectationLinkToken(token: MDToken?,
//                                      expectationURL: URL?,
//                                      expectation: String,
//                                      actionExpectation: String,
//                                      expectionDeeperType: MDTokenType,
//                                      file: StaticString = #filePath,
//                                      line: UInt = #line) throws {
//        let token = try XCTUnwrap(token, expectation, file: file, line: line)
//        XCTAssertEqual(token.type, .link, expectation, file: file, line: line)
//        XCTAssertEqual(token.handler.text, expectation, file: file, line: line)
//        switch token.handler {
//        case .normal(text: _):
//            XCTFail("Wrong token sent", file: file, line: line)
//        case .bold(token: _):
//            XCTFail("Wrong token sent")
//        case .link(token: let token, action: let action, url: let url):
//            XCTAssertEqual(action, actionExpectation, file: file, line: line)
//            if url == nil {
//                XCTAssertNil(url, file: file, line: line)
//            } else {
//                XCTAssertEqual(url?.absoluteString, expectationURL?.absoluteString)
//            }
//            try digDeeperExpectation(token: token,
//                                     expectation: expectation,
//                                     typeExpectation: expectionDeeperType,
//                                     file: file,
//                                     line: line)
//        }
//    }
//
//    func digDeeperExpectation(token: MDToken?,
//                              expectation: String,
//                              typeExpectation: MDTokenType,
//                              file: StaticString,
//                              line: UInt) throws {
//        let token = try XCTUnwrap(token, expectation, file: file, line: line)
//        switch token.handler {
//        case .normal(text: let text):
//            XCTAssertEqual(text, expectation, file: file, line: line)
//        case .bold(token: let deepToken):
//            XCTAssertEqual(deepToken.type, typeExpectation, file: file, line: line)
//            try digDeeperExpectation(token: deepToken,
//                                     expectation: expectation,
//                                     typeExpectation: deepToken.handler.childToken?.type ?? .normal,
//                                     file: file,
//                                     line: line)
//        case .link(token: let deepToken, action: _, url: _):
//            XCTAssertEqual(deepToken.type, typeExpectation, file: file, line: line)
//            try digDeeperExpectation(token: deepToken,
//                                     expectation: expectation,
//                                     typeExpectation: deepToken.handler.childToken?.type ?? .normal,
//                                     file: file,
//                                     line: line)
//        }
//    }
    
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
}
