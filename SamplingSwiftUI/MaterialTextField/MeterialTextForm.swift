//
//  MeterialTextForm.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 17/03/23.
//

import SwiftUI

struct MeterialTextForm: View {
    //, CaseIterable
    enum Field: Hashable, CaseIterable {
        case username
        case age
        case roll
        case hero
        case movie
    }
    
    enum KeyboardToolbarAction: Hashable {
        case next
        case previous
        case done
    }
    
    @State private var username = ""
    @FocusState private var focusedField: Field?
    
    private func onAction(_ action: KeyboardToolbarAction) {
        guard action != .done else {
            focusedField = nil
            return
        }
        let allCases: [Field] = Field.allCases
        guard let safeFocusedField = focusedField,
              let index = allCases.firstIndex(of: safeFocusedField) else {
            focusedField = nil
            return
        }
        switch action {
        case .next:
            guard safeFocusedField != allCases.last else {
                focusedField = nil
                return
            }
            focusedField = allCases[index + 1]
        case .previous:
            guard safeFocusedField != allCases.first else {
                focusedField = nil
                return
            }
            focusedField = allCases[index - 1]
        case .done:
            assertionFailure("Code should not have reached here.")
        }
    }
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .focused($focusedField, equals: .username)
            TextField("Age", text: $username)
                .focused($focusedField, equals: .age)
            TextField("Role", text: $username)
                .focused($focusedField, equals: .roll)
            TextField("Hero", text: $username)
                .focused($focusedField, equals: .hero)
            TextField("Movie", text: $username)
                .focused($focusedField, equals: .movie)
                .submitLabel(.done)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    onAction(.previous)
                } label: {
                    HStack {
                        Text("<")
                            .font(.system(size: 14, weight: .bold))
                            .padding(8)
                    }
                }
                Button {
                    onAction(.next)
                } label: {
                    HStack {
                        Text(">")
                            .font(.system(size: 14, weight: .bold))
                            .padding(8)
                    }
                }
                Spacer()
                Button {
                    onAction(.done)
                } label: {
                    HStack {
                        Text("Done")
                            .font(.system(size: 14, weight: .bold))
                            .padding(8)
                    }
                }
            }
        }
    }
}
