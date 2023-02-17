//
//  FloatingButton.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 16/02/23.
//

import SwiftUI

class FloatingBookButtonViewModel: ObservableObject {
    @Published var title: String
    @Published var subTitle: String?
    @Published var isEnabled: Bool
    
    init(title: String,
         subTitle: String? = nil,
         isEnabled: Bool = true) {
        self.title = title
        self.subTitle = subTitle
        self.isEnabled = isEnabled
    }
}

struct FloatingBookButton: View {
    
    @ObservedObject var viewModel: FloatingBookButtonViewModel
    
    var body: some View {
        HStack {
            Button(action: {
            }, label: {
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Text(viewModel.title)
                            .font(.system(size: 17, weight: .bold))
                        if let subTitle = viewModel.subTitle {
                            Text(subTitle)
                                .font(.system(size: 10, weight: .bold))
                        }
                    }
                    .foregroundColor(viewModel.isEnabled
                                     ? .white
                                     : ColorUtil.color(0x4F6F8F))
                    Spacer()
                }
            })
            .frame(height: 50)
            .background(viewModel.isEnabled
                        ? ColorUtil.color(0x00AA00)
                        : ColorUtil.color(0xEDF0F3))
            .cornerRadius(12)
        }
        .padding(16)
        .background(ColorUtil.color(0xF5F5F5))
        .cornerRadius(16)
        .shadow(color: ColorUtil.color(0x0000000, alpha: 0.14),
                radius: 24,
                x: 0,
                y: 12)
        .transition(.opacity)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FloatingBookButton(viewModel: .init(title:"Complete Booking", subTitle: "for $2990.10"))
                .previewDisplayName("Title Subtitle Enabled")
            FloatingBookButton(viewModel: .init(title:"Complete Booking",
                                            subTitle: "for $2990.10"
                                            , isEnabled: false))
                .previewDisplayName("Title Subtitle Disabled")
            FloatingBookButton(viewModel: .init(title:"Book Now for $2990.10"))
                .previewDisplayName("Only Title Enabled")
            FloatingBookButton(viewModel: .init(title:"Book Now for $2990.10",
                                            isEnabled: false))
                .previewDisplayName("Only Title Disabled")
        }
    }
}
