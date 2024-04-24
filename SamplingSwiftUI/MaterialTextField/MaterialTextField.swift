//
//  MeterialTextField.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 24/01/23.
//

import SwiftUI

struct MeterialTextField: View {
    typealias PLCheckoutTextUpdate = (String) -> Void
    
    @ObservedObject var viewModel: MeterialTextFieldModel
    
    var focusedInputViewID: FocusState<String?>.Binding
    var onInputViewTap: (() -> Void)? = nil
    let onImageTap: ((_ inputViewState: MeterialTextFieldState) -> Void)?
    var onTextChange: PLCheckoutTextUpdate? = nil
    let onTextReturn: PLCheckoutTextUpdate
    @State private var isTextFieldEditing = false
    @FocusState private var isFocused: Bool
    private let inputViewHeight: CGFloat = 64
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Optional Signifier Text
            Text(viewModel.shouldShowOptionalText
                 && !isTextFieldEditing
                 && viewModel.inputText.isEmpty
                 ? viewModel.optionalText ?? ""
                 : "")
                .lineLimit(1)
                .foregroundColor(viewModel.style.optionalTextColor.swiftUIColor)
                .font(viewModel.style.optionalTextFont)
                .frame(height: 16)
                .padding(.top, 4)
            // Text View
            meterialTextView
            Spacer()
            Divider()
                .background(viewModel.dividerColor.swiftUIColor) //inputViewState is warning
            if let error = viewModel.errorText {
                Text(error)
                    .foregroundColor(viewModel.errorWarningColor.swiftUIColor)
                    .font(viewModel.style.errorTextFont)
                    .frame(height: 16)
                    .padding(.top, 2)
            }
        }
        .frame(height: viewModel.errorText != nil
               ? inputViewHeight
               : inputViewHeight - 16 )
        .animation(.easeInOut(duration: 0.15), value: viewModel.errorText)
        .ignoresSafeArea(.keyboard, edges: .all)
        .contentShape(Rectangle())
        .onTapGesture {
            if viewModel.isTextEditable && !viewModel.isDisabled {
                isFocused = true
            } else {
                onInputViewTap?()
            }
        }
    }
    
    // MARK: - Meterial Text View
    
    @ViewBuilder
    var meterialTextView: some View {
        HStack {
            ZStack(alignment: .leading) {
                placeHolder
                if viewModel.isTextEditable && !viewModel.isDisabled {
                    TextField("", text: $viewModel.inputText,
                              onEditingChanged: { isEditing in
                        isTextFieldEditing = isEditing
                        if isEditing {
                            onTextChange?(viewModel.inputText)
                        } else {
                            onTextReturn(viewModel.inputText)
                        }
                    })
                    .focused(focusedInputViewID, equals: viewModel.id)
                    .focused($isFocused)
                    .disableAutocorrection(true)
                    .foregroundColor(viewModel.style.textColor.swiftUIColor)
                    .font(viewModel.style.textFont)
                    .onChange(of: viewModel.inputText) { newValue in
                        onTextChange?(newValue)
                    }
                    .padding(.top, 3)
                    .keyboardType(viewModel.keyboardType)
                } else {
                    Text(viewModel.inputText)
                        .padding(.top, 4)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(viewModel.nonEditableTextColor.swiftUIColor)
                        .font(viewModel.style.textFont)
                        .onChange(of: viewModel.inputText) { newValue in
                            onTextReturn(newValue)
                        }
                        .disabled(viewModel.isDisabled)
                        .animation(.none, value: viewModel.inputText)
                }
            }
            .animation(.easeInOut(duration: 0.15), value: viewModel.inputText)
            .animation(.easeInOut(duration: 0.15), value: isTextFieldEditing)
            if let rightAccesoryImage = viewModel.rightAccesoryImageNames {
                HStack(spacing: 18) {
                    ForEach(rightAccesoryImage, id: \.image) { rightAccessoryViewModel in
                        rightAccessoryViewModel.image.systemImage
                            .fixedSize()
                            .onTapGesture {
                                guard !viewModel.isDisabled else {
                                    return
                                }
                                if viewModel.inputStateImageNames.contains(rightAccessoryViewModel.image) {
                                    // If image of success/error/edting
                                    onImageTap?(viewModel.MeterialTextFieldState)
                                } else {
                                    // For selection input view represting image tap
                                    onInputViewTap?()
                                }
                            }
                    }
                }
                .padding(.trailing, 15)
            }
        }
        .onAppear {
            guard !viewModel.inputText.isEmpty else {
                return
            }
            onTextReturn(viewModel.inputText)
        }
    }
    
    @ViewBuilder
    var placeHolder: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(viewModel.placeholderText)
                .lineLimit(1)
                .padding(.top, 4)
                .foregroundColor(viewModel.placeholderColor(isTextFieldEditing).swiftUIColor)
                .font(
                    !isTextFieldEditing && viewModel.inputText.isEmpty
                    ? viewModel.style.textFont
                    : viewModel.style.placeholderTextFont
                )
                .offset(y: !isTextFieldEditing && viewModel.inputText.isEmpty
                        ? (viewModel.shouldShowOptionalText ? 0 : 0)
                        : -22)
            
            if let placeholderIcon = viewModel.placeholderIcon {
                placeholderIcon.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16, alignment: .center)
                    .foregroundColor(viewModel.placeholderColor(isTextFieldEditing).swiftUIColor)
                    .padding(.leading, 2)
                    .offset(y: -20)
            }
        }
    }
}


struct MeterialTextField_Previews: PreviewProvider, View {
    
    let viewModels = [
        [
            MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews1",
                                   inputText: "A Really Big Text to check compartments",
                                   placeholderText: "First Name",
                                   optionalText: "",
                                   isEditable: true,
                                   isDisabled: false,
                                   rightAccesoryImageNames: [
                                    .init(image: .xMarkSystemImage,
                                          isSFSymbol: true)
                                   ],
                                   style: .basicStyle,
                                   keyboardType: .asciiCapable)
        ],
        [
            MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews2",
                                   inputText: "",
                                   placeholderText: "A Really Big Text to checkbA",
                                   optionalText: "A Really Big Text to checkbA",
                                   isEditable: true,
                                   isDisabled: false,
                                   style: .basicStyle,
                                   keyboardType: .asciiCapable),
            MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews3",
                                   inputText: "",
                                   placeholderText: "A Really Big Text to check compartments",
                                   optionalText: "A Really Big Text",
                                   isEditable: false,
                                   isDisabled: false,
                                   style: .basicStyle,
                                   keyboardType: .asciiCapable,
                                   placeholderIcon: .lock)
        ],
        [
            MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews4",
                                   inputText: "Some",
                                   placeholderText: "Placeholder",
                                   optionalText: "",
                                   isEditable: false,
                                   isDisabled: false,
                                   style: .basicStyle,
                                   keyboardType: .asciiCapable),
            MeterialTextFieldModel(id: "PLCheckoutInputTextView_Previews5",
                                   inputText: "",
                                   placeholderText: "Placeholder",
                                   optionalText: "",
                                   isEditable: true,
                                   isDisabled: false,
                                   style: .basicStyle,
                                   keyboardType: .asciiCapable)
        ]
        
    ]
    @FocusState var focus: String?
    
    var body: some View {
        VStack {
            ForEach(viewModels, id: \.first?.id) { vms in
                HStack {
                    ForEach(vms) { vm in
                        MeterialTextField(viewModel: vm,
                                          focusedInputViewID: $focus,
                                          onImageTap: nil,
                                          onTextReturn: { _ in })
                    }
                }
                .padding(.bottom, 15)
            }
        }
        .padding(16)
    }
    
    
    static var previews: some View {
        Self()
    }
}
