//
//  SwitchRowView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 11/01/23.
//

import SwiftUI

struct SwitchRowView: View {
    
    @State private var isOn: Bool = false
    var onToggle: (Bool) -> ()
    
    var body: some View {
        HStack {
            Toggle(isOn: $isOn) {
                Text("Non-airport locations only")
                    .padding(-8)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .padding(16)
            .onChange(of: isOn) { newValue in
                onToggle(newValue)
            }
            
        }
        .frame(height: 44)
        .background(.white)
        .cornerRadius(9)
        .padding(8)
        .shadow(color: Color(white: 0, opacity: 0.12), radius: 2, x: 0, y: 1)
    }
}

struct SwitchRowView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchRowView(onToggle: { _ in })
    }
}
