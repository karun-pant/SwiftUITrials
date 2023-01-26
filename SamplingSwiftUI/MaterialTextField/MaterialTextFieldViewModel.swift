//
//  MaterialTextFieldViewModel.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 26/01/23.
//

import Foundation

class MaterialTextFieldViewModel: ObservableObject {
    typealias TextAction = (_ currentText: String?) -> ()
    
    @Published var text: String
    let placeHolder: String
    let optionalStateText: String?
    var onTap: TextAction?
    var onChange: TextAction?
    var onReturn: TextAction?
    var onTapLeftAccessary: TextAction?
    @Published var errorMessage: String?
    @Published var leftAccessaryImage: String?
    init(text: String? = nil,
         optionalStateText: String?,
         placeHolder: String = "",
         onTap: TextAction? = nil,
         onChange: TextAction? = nil,
         onReturn: TextAction? = nil,
         onTapLeftAccessary: TextAction? = nil,
         errorMessage: String? = nil,
         leftAccessaryImage: String? = nil) {
        self.text = text
        self.optionalStateText = optionalStateText
        self.onTap = onTap
        self.onChange = onChange
        self.onReturn = onReturn
        self.onTapLeftAccessary = onTapLeftAccessary
        self.errorMessage = errorMessage
        self.leftAccessaryImage = leftAccessaryImage
        self.placeHolder = placeHolder
    }
    
}
