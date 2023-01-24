//
//  MeterialTextField.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 24/01/23.
//

import SwiftUI

struct MaterialTextField: View {
    
    let placeHolder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                Text(placeHolder)
                    .foregroundColor(text.isEmpty
                                     ? Color(.placeholderText)
                                     : .blue)
                    .offset(y: text.isEmpty ? 0 : -25)
                    .scaleEffect(text.isEmpty ? 1 : 0.8, anchor: .leading)
                TextField("", text: $text)
            }
            .padding(.top, 15)
            .animation(.default, value: text)
            Divider()
                .background(Color.gray)
        }
    }
}

struct MeterialTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MaterialTextField(placeHolder: "Name", text: .constant("Some Name"))
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("Some")
            MaterialTextField(placeHolder: "Name", text: .constant(""))
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("Empty")
        }
    }
}
