//
//  RepresentableVCs.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 14/12/22.
//

import SwiftUI

struct GestureRepresentableVC: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> GestureVC {
        let vc = GestureVC(nibName: nil, bundle: nil)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: GestureVC, context: Context) {
    }
}

