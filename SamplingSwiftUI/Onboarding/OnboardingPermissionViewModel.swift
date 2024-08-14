//
//  OnboardingViewModel.swift
//  negotiator
//
//  Created by Karun Pant on 22/05/24.
//  Copyright © 2024 Priceline.com. All rights reserved.
//

import SwiftUI

class OnboardingViewStateHelper {
    private var viewModel: OnboardingViewModel?
    
    init() {
        
    }
    
    func makeVM() -> OnboardingViewModel {
        let viewModel = OnboardingViewModel(
            push: .pushPermissionViewModel(action: {
                self.goNext()
            }),
            location: .locationPermissionViewModel(action: {
                self.goNext()
            }),
            signin: .signinViewModel(signinAction: {
            }, createAccountAction: {
                self.goNext()
            }, skipAction: {})
        )
        self.viewModel = viewModel
        return viewModel
    }
    
    func goNext() {
        guard let viewModel,
              let type = OnboardingPermissionViewModel.OnboardingPermissionType(rawValue: viewModel.nextPageIndex) else {
            return
        }
        
        switch type {
        case .locationPermission:
            viewModel.nextPageIndex = 1
        case .pushPermission:
            viewModel.nextPageIndex = 2
        case .signin:
            viewModel.nextPageIndex = 0
        }
    }
    
}

class OnboardingViewModel: ObservableObject {
    
    let viewModels: [OnboardingPermissionViewModel]
    @Published var nextPageIndex: Int
    
    init(push: OnboardingPermissionViewModel,
         location: OnboardingPermissionViewModel,
         signin: OnboardingPermissionViewModel) {
        var viewModels: [OnboardingPermissionViewModel] = []
        for type in OnboardingPermissionViewModel.OnboardingPermissionType.allCases {
            switch type {
            case .locationPermission:
                viewModels.append(location)
            case .pushPermission:
                viewModels.append(push)
            case .signin:
                viewModels.append(signin)
            }
        }
        self.viewModels = viewModels
        // assign first from the order list
        nextPageIndex = OnboardingPermissionViewModel.OnboardingPermissionType.allCases.first?.rawValue
        ?? OnboardingPermissionViewModel.OnboardingPermissionType.locationPermission.rawValue
    }
    
    func permissionViewModel(_ type: OnboardingPermissionViewModel.OnboardingPermissionType) -> OnboardingPermissionViewModel? {
        viewModels.first(where: { $0.type == type })
    }
    
}

class OnboardingPermissionViewModel: Identifiable {
    
    // This enum is being used to maintain order of appearance for Views
    enum OnboardingPermissionType: Int, CaseIterable {
        case locationPermission
        case pushPermission
        case signin
        
        var backgroundImageName: String {
            switch self {
            case .locationPermission:
                return "onboardingLocation"
            case .pushPermission:
                return "onboardingPush"
            case .signin:
                return "onboardingSignin"
            }
        }
        
        var title: String {
            switch self {
            case .locationPermission:
                return "Get our best deals near you!"
            case .pushPermission:
                return "Stay on top with price alerts!"
            case .signin:
                return "Become a Priceline VIP"
            }
        }
        
        var subTitle: String {
            switch self {
            case .locationPermission:
                return "Share your location and we’ll show you great deals right nearby"
            case .pushPermission:
                return "Allow us to send you notifications and save with exciting deals on your next booking"
            case .signin:
                return "Unlock your free VIP membership (and even more savings! by signing in or creating an account."
            }
        }
    }
    var id: OnboardingPermissionViewModel.OnboardingPermissionType {
        type
    }
    let type: OnboardingPermissionType
    let actions: [OnboardingAction]
    init(type: OnboardingPermissionType,
         actions: [OnboardingAction]) {
        self.type = type
        self.actions = actions
    }
    
    static func pushPermissionViewModel(action: @escaping () -> ()) -> OnboardingPermissionViewModel {
      OnboardingPermissionViewModel(type: .pushPermission,
                          actions: [
                            .init(title: "Next",
                                  action: action)
                          ])
    }
    
    static func locationPermissionViewModel(action: @escaping () -> ()) -> OnboardingPermissionViewModel {
      OnboardingPermissionViewModel(type: .locationPermission,
                          actions: [
                            .init(title: "Next",
                                  action: action)
                          ])
    }
    
    static func signinViewModel(signinAction: @escaping () -> (),
                                createAccountAction: @escaping () -> (),
                                skipAction: @escaping () -> ()) -> OnboardingPermissionViewModel {
        OnboardingPermissionViewModel(type: .signin,
                            actions: [
                              .init(title: "Sign in to Priceline",
                                    action: signinAction),
                              .init(title: "Create an account",
                                    type: .secondary,
                                    action: createAccountAction),
                              .init(title: "Do this later",
                                    type: .link,
                                    action: skipAction)
                            ])
    }
}

class OnboardingAction: Identifiable {
    enum ActionType {
        case primary
        case secondary
        case link
    }
    
    var id: String {
        title
    }
    let title: String
    let type: ActionType
    var action: () -> ()
    init(title: String, 
         type: ActionType = .primary,
         action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.type = type
    }
}
