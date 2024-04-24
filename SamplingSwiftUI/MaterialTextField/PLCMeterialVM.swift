//
//  PLCMeterialVM.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 26/04/23.
//

import Foundation
import SwiftUI

enum MeterialTextFieldState {
    case success
    case error
    case warning
    case editing
    case none
}

struct ImageViewModel {
    let image: AssetImage
    let font: Font?
    let color: Color?
    let isSFSymbol: Bool
    
    init(image: AssetImage,
         font: Font? = nil,
         color: Color? = nil,
         isSFSymbol: Bool) {
        self.image = image
        self.font = font
        self.color = color
        self.isSFSymbol = isSFSymbol
    }
}

struct MeterialTextFieldStyle {
    let textFont: Font
    let textColor: AssetColor
    let textDisabledColor: AssetColor
    let placeholderColorWithText: AssetColor
    let placeholderColorWithoutText: AssetColor
    let placeholderTextFont: Font
    let placeholderTextDisabledColor: AssetColor
    let optionalTextColor: AssetColor
    let optionalTextFont: Font
    let errorTextColor: AssetColor
    let warningTextColor: AssetColor
    let errorTextFont: Font
    let separatorColor: AssetColor
    
    static let basicStyle: MeterialTextFieldStyle = {
        return MeterialTextFieldStyle(textFont: .system(size: 17),
                              textColor: AssetColor.darkText,
                              textDisabledColor: AssetColor.lightContentWithOpacity,
                              placeholderColorWithText: AssetColor.darkText,
                              placeholderColorWithoutText: AssetColor.lightContentWithOpacity,
                              placeholderTextFont: .system(size: 12, weight: .bold),
                              placeholderTextDisabledColor: AssetColor.lightContentWithOpacity,
                              optionalTextColor: AssetColor.lightContentWithOpacity,
                              optionalTextFont: .system(size: 12, weight: .bold),
                              errorTextColor: AssetColor.urgencyContent,
                              warningTextColor: AssetColor.lightContent,
                              errorTextFont: .system(size: 12, weight: .bold) ,
                              separatorColor: AssetColor.lightContentWithOpacity)
    }()
}


class MeterialTextFieldModel: ObservableObject, Identifiable {
    typealias KeyboardToolbarButtonClosure = (_ id: String) -> ()
    
    @Published var inputText: String
    @Published var errorText: String?
    @Published var rightAccesoryImageNames: [ImageViewModel]?
    let id: String
    var placeholderText: String
    var optionalText: String?
    let isDisabled: Bool
    let isTextEditable: Bool
    let style: MeterialTextFieldStyle
    var keyboardType: UIKeyboardType
    let shouldShowValidationIcons: Bool
    let placeholderIcon: AssetImage?
    
    let doneButtonTitle: String = "Done"
    var shouldShowOptionalText: Bool {
        optionalText != nil && !(optionalText?.isEmpty ?? true)
    }
    var nonEditableTextColor: AssetColor {
        if isDisabled {
            return style.textDisabledColor
        }else {
            return style.textColor
        }
    }
    var errorWarningColor: AssetColor {
        if MeterialTextFieldState == .error {
            return style.errorTextColor
        } else {
            return style.warningTextColor
        }
    }
    var dividerColor: AssetColor {
        if MeterialTextFieldState != .error && MeterialTextFieldState != .warning{
            return style.separatorColor //MeterialTextFieldState is success/non
        } else if MeterialTextFieldState == .error {
            return style.errorTextColor // MeterialTextFieldState is error
        } else {
            return style.warningTextColor
        }
    }
    
    var onTapNext: KeyboardToolbarButtonClosure?
    var onTapPrevious: KeyboardToolbarButtonClosure?
    var onTapDone: KeyboardToolbarButtonClosure?
    
    @Published var MeterialTextFieldState: MeterialTextFieldState = .none {
        didSet {
            guard oldValue != MeterialTextFieldState else {
                return
            }
            updateMeterialTextFieldStateImage()
        }
    }
    let inputStateImageNames = [AssetImage.tickSystemImage,
                                AssetImage.errorSystemImage,
                                AssetImage.xMarkSystemImage]
    
    init(id: String,
         inputText: String,
         placeholderText: String,
         optionalText: String?,
         isEditable: Bool,
         isDisabled: Bool,
         rightAccesoryImageNames: [ImageViewModel]? = nil,
         shouldShowValidationIcons: Bool = true,
         style: MeterialTextFieldStyle,
         keyboardType: UIKeyboardType,
         placeholderIcon: AssetImage? = nil) {
        self.inputText = inputText
        self.errorText = nil
        self.placeholderText =  optionalText != nil ? placeholderText : "\(placeholderText)*"
        self.optionalText = optionalText
        self.isTextEditable = isEditable
        self.isDisabled = isDisabled
        self.rightAccesoryImageNames = rightAccesoryImageNames
        self.shouldShowValidationIcons = shouldShowValidationIcons
        self.style = style
        self.keyboardType = keyboardType
        self.id = id
        self.placeholderIcon = placeholderIcon
    }
    
    func placeholderColor(_ isEditing: Bool) -> AssetColor {
        if isDisabled {
            return style.placeholderTextDisabledColor
        } else if (!isEditing && inputText.isEmpty) {
            return style.placeholderColorWithoutText
        } else {
            return style.placeholderColorWithText
        }
    }
    
    //Method to update right accessary 0th image
    private func updateMeterialTextFieldStateImage() {
        guard shouldShowValidationIcons else { return }
        
        var imageViewModel: ImageViewModel?
        switch MeterialTextFieldState {
        case .success:
            imageViewModel = ImageViewModel(image: inputStateImageNames[0],
                                                      color: AssetColor.benefitAsset.swiftUIColor,
                                                      isSFSymbol: true)
        case .error:
            imageViewModel = ImageViewModel(image: inputStateImageNames[1],
                                                      color: AssetColor.urgencyContent.swiftUIColor,
                                                      isSFSymbol: true)
        case .warning:
            imageViewModel = ImageViewModel(image: inputStateImageNames[1],
                                                      color: AssetColor.lightContent.swiftUIColor,
                                                      isSFSymbol: true)
        case .editing:
            imageViewModel = ImageViewModel(image: inputStateImageNames[2],
                                                      color: AssetColor.lightContentWithOpacity.swiftUIColor,
                                                      isSFSymbol: true)
        case .none:
            imageViewModel = nil
        }
        
        if let imageViewModel {
            if rightAccesoryImageNames != nil {
                if let lastViemodeImage = rightAccesoryImageNames?.last,
                   inputStateImageNames.contains(lastViemodeImage.image) {
                    //succes/error/editing image found. replace image at last index
                    rightAccesoryImageNames?[rightAccessoryLastIndex] = imageViewModel
                } else {
                    //succes/error/editing image not found. Insert image at last
                    rightAccesoryImageNames?.append(imageViewModel)
                }
            } else {
                rightAccesoryImageNames = [imageViewModel]
            }
        } else {
            //Remove succes/error/editing image
            if rightAccesoryImageNames?.count ?? 0 > 1{
                rightAccesoryImageNames?.remove(at: rightAccessoryLastIndex)
            } else {
                rightAccesoryImageNames = nil
            }
        }
    }
    
    var rightAccessoryLastIndex: Int {
        if let rightAccesoryImageNames, rightAccesoryImageNames.count > 0 {
            return rightAccesoryImageNames.count - 1
        } else {
            return  0
        }
    }
}
