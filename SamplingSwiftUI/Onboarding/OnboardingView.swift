//
//  OnboardingView.swift
//  negotiator
//
//  Created by Karun Pant on 22/05/24.
//  Copyright © 2024 Priceline.com. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if let type = OnboardingPermissionViewModel.OnboardingPermissionType(rawValue: viewModel.nextPageIndex),
                   let permissionViewModel = viewModel.permissionViewModel(type) {
                    OnboardingPermissionView(viewModel: permissionViewModel)
                }
            }
            VStack {
                Spacer()
                OnboardingPageIndicator(pageCount: viewModel.viewModels.count,
                                        pageIndex: $viewModel.nextPageIndex)
                .padding(.bottom, 36)
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct OnboardingPageIndicator: View {
    let pageCount: Int
    @Binding var pageIndex: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == pageIndex
                          ? AssetColor.pclnBlue.swiftUIColor
                          : AssetColor.lightBlue.swiftUIColor)
                    .frame(width: 10, height: 10)
            }
        }
    }
}

#Preview {
    let viewModel = OnboardingViewModel(
        push: .pushPermissionViewModel {
            
        },
        location: .locationPermissionViewModel { },
        signin: .signinViewModel(
            signinAction: { },
            createAccountAction: { },
            skipAction: { })
    )
    return OnboardingView(viewModel: viewModel)
}
