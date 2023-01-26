//
//  MeterialTextField.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 24/01/23.
//

import SwiftUI

struct MaterialTextField: View {
    
    @ObservedObject var viewModel: MaterialTextFieldViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                if let optionalStateText = viewModel.optionalStateText,
                   isTextEmpty {
                    Text(optionalStateText)
                        .foregroundColor(Color(.placeholderText))
                        .font(.system(size: 12, weight: .semibold))
                        .offset(y: -25)
                }
                Text(viewModel.placeHolder)
                    .foregroundColor(isTextEmpty
                                     ? Color(.placeholderText)
                                     : .blue)
                    .offset(y: isTextEmpty ? 0 : -25)
                    .scaleEffect(isTextEmpty ? 1 : 0.8, anchor: .leading)
                TextField("", text: $viewModel.text)
            }
            .padding(.top, 15)
            .animation(.default, value: viewModel.text)
            Divider()
                .background(Color.gray)
        }
    }
    
    var isTextEmpty: Bool {
        viewModel.text.isEmpty
    }
}

struct MeterialTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MaterialTextField(viewModel: .init(optionalStateText: nil, placeHolder: "Name"))
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("Some")
            MaterialTextField(viewModel: .init(optionalStateText: "Optional", placeHolder: "Name"))
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("Empty")
        }
    }
}
