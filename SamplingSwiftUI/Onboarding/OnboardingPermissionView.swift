//
//  OnboardingPermissionView.swift
//  negotiator
//
//  Created by Karun Pant on 22/05/24.
//  Copyright © 2024 Priceline.com. All rights reserved.
//

import SwiftUI

struct OnboardingPermissionView: View {
    
    let viewModel: OnboardingPermissionViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(viewModel.type == .pushPermission
                      ? AssetColor.pclnBlue.swiftUIColor
                      : Color.white)
                .frame(height: 104)
            BackgroundImage
            VStack(spacing: 4) {
                Text(viewModel.type.title)
                    .foregroundStyle(AssetColor.darkText.swiftUIColor)
                    .font(.system(size: 22, weight: .bold))
                Text(viewModel.type.subTitle)
                    .foregroundStyle(AssetColor.darkText.swiftUIColor)
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            .padding(.top, 36)
            VStack(spacing: 8) {
                ForEach(viewModel.actions) { cta in
                    Button {
                        cta.action()
                    } label: {
                        HStack {
                            Spacer()
                            Text(cta.title)
                                .foregroundStyle(Color.white)
                                .font(.system(size: 17, weight: .bold))
                                .padding(14)
                            Spacer()
                        }
                        .background(AssetColor.pclnBlue.swiftUIColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.top, 36)
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
    
    @ViewBuilder
    var BackgroundImage: some View {
        if viewModel.type == .pushPermission {
            Image(viewModel.type.backgroundImageName, bundle: .main)
                .resizable()
                .scaledToFill()
                .frame(height: 250)
        } else {
            Image(viewModel.type.backgroundImageName, bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
        }
    }
}

#Preview("Location Permission") {
    OnboardingPermissionView(
        viewModel: .locationPermissionViewModel {
        
    })
}
#Preview("Push Permission") {
    OnboardingPermissionView(
        viewModel: .pushPermissionViewModel {})
}
#Preview("Sign in") {
    OnboardingPermissionView(
        viewModel: .signinViewModel(
            signinAction: {},
            createAccountAction: {},
            skipAction: {}))
}
