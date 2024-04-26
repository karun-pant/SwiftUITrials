//
//  BadgeView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 24/04/24.
//

import SwiftUI

struct BadgeView: View {
    
    let viewModel: BadgeViewModel
    
    var body: some View {
        HStack {
            if let image = viewModel.image {
                image
                    .resizable()
                    .frame(width: 8, height: 10)
            }
            
            Text(viewModel.title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(viewModel.style.titleColor)
        }
        .padding(EdgeInsets.init(top: 4,
                                 leading: 8,
                                 bottom: 4,
                                 trailing: 8))
        .background(viewModel.style.backgroundColor)
        .cornerRadius(8)
    }
}

#Preview {
    BadgeView(viewModel: .init(title: "ROUND-TRIP",
                               image: nil,
                               style: .roundTrip))
}
